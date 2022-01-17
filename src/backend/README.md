# SGS_Last_Punch
SGS 2021 Dev Camp 2nd Team Last Punch

------
2022.01.15 gateway, auth-server, mysql, eureka 서비스에 대한 README
(추후 리드미 위치 수정 예정)

# 실행 방법

1. cd /src/backend 
- backend 경로로 이동
2. docker-compose pull 
- 필요한 이미지 pull
3. docker-compose up --build 
- 이미지 빌드 (다음 실행부터는 docker-compose up 사용)
- 모든 컨테이너가 실행되는데 시간이 몇초~몇십초 정도 소요될 수 있습니다
4. 브라우저에서 localhost:8761 접속
- eureka 에서 instances currently registered with Eureka에 AUTH-SERVER 와 GATEWAY 있는지 확인
- 이제부터 통신을 하시면 됩니다!

기타 명령어
(docker-compose로 올라온 컨테이너들 모두에 적용됨)
- docker-compose stop: 정지
- docker-compose rm: 일괄 삭제
- docker-compose down: 네트워크 정보, 볼륨, 컨테이너들을 일괄 정지 및 삭제 처리
- docker-compose logs: 로그를 확인

# 도커 실행 오류
오류 1. [Docker] "docker: Error response from daemon: Mounts denied
- 원인: MySQL에서 사용하는 볼륨의 위치에 대한 Mount 권한이 없어 실행에 실패
- 해결: Docker Client를 실행하고 Preferences -> Resources -> FILE SHARING 메뉴에서 마운트 할 경로(SGS_LAST_PUNCH 경로)를 추가
- 참고: https://jinseongsoft.tistory.com/340 



# API 문서 
https://documenter.getpostman.com/view/7437901/UVXgLHFb

--------