# Kubernetes, docker에서 Hyperledger fabric 실험
* 블록체인은 데이터 분산 처리 기술로 스마트 컨트랙트, 물류 관리 시스템 등 다양한 분야에서 활용되고 있다. 대표적인 오픈소스 블록체인 플랫폼인 하이퍼레저 패브릭에서는 블록체인 네트워크를 구성하는 요소들이 컨테이너 형태로 생성되어 서버상에 동작한다. 따라서, 이러한 블록체인 컨테이너에 적절한 자원을 할당하기 위해서는 컨테이너 환경에서의 블록체인 플랫폼 성능 분석이 필요하다. 본 논문은 도커 및 쿠버네티스를 이용한 컨테이너 환경에서 블록체인 플랫폼인 하이퍼레저 패브릭의 성능과 자원 사용량을 측정하고 그 공통점과 차이점을 비교 및 분석한다. 

## 실험 환경
* Kubernetes 1.21.1, Docker version 20.10.9
* 4대의 서버 사용, (각 container에 2 cores 할당)
	* Orderer (oslab@163.152.20.138 / 10.0.0.25) 10 cores, 256Mb memory - Master node
	* Ca (oslab2@163.152.20.139 / 10.0.0.15) 10 cores, 128 Mb memory - Worker node
	* Peer (server3@163.152.20.140 / 10.0.0.12) 10 cores, 256 Mb memory - Worker node
	* Benchmark ( oslab@163.152.20.172) 10 cores, 128 Mb memory - Worker node

## 실험 방법
* Kubernetes cluster 구성
	* https://hiseon.me/linux/ubuntu/ubuntu-kubernetes-install/
	* kubectl, kubelet, kubeadm, kubernetes-cni 설치하는 부분은 아래의 커맨드 사용
		* sudo apt-get install kubectl=1.21.1-00 kubelet=1.21.1-00 kubeadm=1.21.1-00 kubernetes-cni=0.8.7-00
* 1번, 2번, 3번, 12번 서버에 각각 nfs 디렉토리 마운트 
	* mount -t nfs 10.0.0.23:/mnt/s2 /mnt/eskim (내부 다른 디렉토리 삭제하면 X)
	* /mnt/eskim/temp 디렉토리에서  각 인증 키 등 패브릭 관련 정보들 저장됨
* pod 생성하기 전에 route 설정 필요
	* /home/oslab/go/src/github.com/consensus-performance/caliper_es/bin 에서 route_es.sh 실행하여 route 설정 가능 -> 각 서버마다 Destination, gateway IP 수정 필요
	* 예시) 
		* <img width="569" alt="스크린샷 2021-12-08 오후 4 54 48" src="https://user-images.githubusercontent.com/28219985/145193168-23ec7ef9-ff22-4b6b-b7bd-6e51c886a602.png">
	* route 설정 삭제는 ./route_es.sh 실행
* 패브릭 네트워크 삭제시 사용
	* /home/oslab/go/src/github.com/consensus-performance/caliper_es/bin 에서 stop.sh 실행
		* docker 환경에서 실행했으면 브릿지 삭제도 필요
			* ./stop.sh raft[합의 알고리즘 이름]
	* /home/oslab/go/src/github.com/eskim/blockchain-network-on-kubernetes-5 or -6 에서 ./deleteNetwork.sh 실행

### Docker 환경 실험
#### fabric container 실행
* 1,2,4번 각각의 서버에서 역할에 맞는 노드 실행 -> /home/oslab, oslab2, server3/go/src/github.com/consensus-performance/caliper or caliper_es/
* bin 디렉토리에서 start.sh [consensus 이름] [노드 이름]를 실행하여 각 노드 실행
	* orderer (oslab) : bash ./start.sh r o
	* ca (oslab2) : bash ./start.sh r c
	* peer (server3) : bash ./start.sh r p

#### 벤치마크 실행
* bash ./benchmark.sh raft test  -> benchmark.sh [consensus 이름] test

### Kubernetes 환경 실험
#### fabric pod 생성 
* 12번 서버 -> Kubernetes에서 hyperledger fabric pod 생성 디렉토리 
	* /home/oslab/go/src/github.com/eskim/blockchain-network-on-kubernetes-5/ -> 캘리퍼에서 채널 생성 및 체인코드 설치 시 디렉토리 (기존의 패브릭 실험 환경의 채널과 구성이 달라지지 않도록 캘리퍼에서 채널 생성하도록 함 [채널 생성, 체인 코드 설치 job이 docker에서 실행됨] / 정보과학회 실험에서는 이 코드 사용)
	* /home/oslab/go/src/github.com/eskim/blockchain-network-on-kubernetes-6/ -> IBM 패브릭 오픈소스에서 채널 생성 및 체인코드 설치 시 디렉토리 (채널 생성 및 체인코드 설치까지 kubernetes에서 할 수 있도록 구현)
* Master에 orderer, peer, ca 외의 job을 처리하는 pod들을 실행하기 위해 taint 해제
	* 	kubectl taint nodes baas2 node-role.kubernetes.io/master-
* 각 서버에 fabric의 노드 (peer, orderer, ca, others) 역할을 지정해주기 위해 아래의 커맨드 실행
	* ./role_setting.sh 
		* 	구성하려는 노드에 맞게 지정해야됨	
* 위의 디렉토리에서 아래 커맨드 실행
	* ./setup_blockchainNetwork.sh (configFiles에 있는 kubernetes에 띄울 yaml파일 실행. 자세한 내용은 스크립트 확인)
	* Pod가 Running 상태인지 확인, 서버 별로 pod 역할에 맞게 배치되었는지 확인 (Completed로 되어있는 상태들은 job이 실행 완료된 상태이므로 상관 안해도 됨)
	`kubectl get pods  -o wide`
* 주요 폴더별 설명 [참고용]
	* artifacts : 네트워크 설정 파일 포함 디렉토리
		* configtx.yaml : Organization, Ordering Service, Channel, Profile, Policy 등 정의
		* crypto-config.yaml : 네트워크에 참여하는 Orderer, Peer 조직 정의 (e.g., orderer 및 peer 노드 수, 이름 등)
	* configFiles : Kubernetes 설정 파일 포함 디렉토리
		* 각 컴포넌트 (CA, peer, orderer)에 대한 service, volume, deployment를 생성하기 위한 yaml 파일 
		* channel 생성 및 참여, crypto-config 디렉토리 (CA, peer, orderer 를 위한 인증서 포함 디렉토리) 등의  생성을 위한 설정 파일 
	* .sh : 네트워크 배포 및 삭제 스크립트
		* configFiles 디렉토리의 yaml파일을 기반으로 한 네트워크 배포 스크립트

#### caliper benchmark 실행
* 12번 서버 -> /home/oslab/go/src/github.com/eskim/consensus-performance/caliper_es 디렉토리
* network/caliper/raft/fabric-go.yaml 파일에서 orderer, ca, peer의 서버 IP로 변경
	* 이미 설정은 해놔서 url 부분 참고하면 될 듯 합니다.
	* 캘리퍼에서 채널 생성 및 체인코드 생성을 하고 싶으면 Channel: false로 변경하고 미리 IBM 패브릭에서 생성하고 캘리퍼에서 트랜잭션 생성 및 측정만 하고 싶으면 Channel: true로 변경하여 실험
* bin 디렉토리에서 아래의 커맨드 실행하여 benchmark 실행
	* ./benchmark.sh raft test 
* fabric-script 디렉토리에 실험 스크립트 있음
	* ./measure.sh -> 해당 스크립트를 실행하면 각각 1번, 2번, 3번 서버에서 각 노드에 대한 (orderer, peer, ca) 측정 스크립트가 실행되고 디렉토리 생성
	* ./measure_peer.sh, ./measure_orderer.sh, ./measure_ca.sh 각 역할의 노드를 가진 서버에서 cpu, network, perf data 측정

#### 실험 관련
* perf나 cpu 측정 툴은 그대로 사용하면 되고 vnstat을 사용할 때 interface에 대해 측정하는 것이 아닌 각 pod별로 측정 
	* 이전에 xtella 실험 데이터 수집할 때 사용했던 network 측정 방법대로 진행하면 됩니다.
* 실험 데이터는 각 /home/oslab, oslab2, server3, baas2/eskim/fabric_script 에 있음
	* 정보과학회에 쓰인 실험 데이터는 아래의 디렉토리에 있음
		* 각 3번씩 실험한 결과로 peer1, peer2, peer3 or  orderer1, orderer2, orderer3 이런식으로 폴더 구성
			* pidstat, mpstat, vnstat으로 CPU와 network 성능 측정 결과, perf data 있음
			* kubernetes 환경 데이터 :  /home/oslab, oslab2, server3/eskim/fabric_script/k8s_data_caliper/
			* docker 환경 데이터 : /home/oslab, oslab2, server3/eskim/fabric_script/docker_data2
		* 12번 서버에는 benchmark 실험 결과 (TPS, latency)가 report 형태로 저장되는 html파일이 저장됨
			* kubernetes results : /home/baas2/go/src/github.com/consensus-performance/caliper_es/results/k8s_data_caliper/
			* docker results : /home/baas2/go/src/github.com/consensus-performance/caliper/results/docker_report2

### 정보과학회 논문 첨부
* 제출하여 accept를 받았으나 아직 게재되지 않아 게재 된 후 첨부 예정
	* 컨테이너 환경(Kubernetes, Docker)에서의 하이퍼레저 패브릭의 성능 및 자원사용량 비교 분석
* 혹시, 논문 내용에 대해 궁금하시면 저에게 따로 메일 부탁드립니다. 
	* 이메일 : dkdla58@gmail.com

### 레퍼런스
* IBM cloud Kubernetes services https://github.com/IBM/blockchain-network-on-kubernetes
* Qioi: [Applied Sciences | Free Full-Text | QiOi: Performance Isolation for Hyperledger Fabric](https://www.mdpi.com/2076-3417/11/9/3870)
* 멀티 테넌트 환경에서 이종 워크로드 간 성능 간섭 분석 https://www.cseric.or.kr/literature/ser_view.php?searchCate=literature&SnxGubun=INME&mode=total&SnxGubun=INME&gu=INME000G2&cmd=qryview&SnxIndxNum=220743&rownum=1&f1=MN&q1=%C0%CC%B0%FC%C8%C6
* 블록체인 플랫폼 성능 벤치마크 분석: 하이퍼레저 캘리퍼 [논문보기 - DBpia](https://www.dbpia.co.kr/pdf/pdfView.do?nodeId=NODE09874646&mark=0&useDate=&ipRange=N&accessgl=Y&language=ko_KR)
