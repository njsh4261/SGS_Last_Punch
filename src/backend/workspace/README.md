# Workspace server
- 워크스페이스, 채널, 사용자에 관한 REST API를 제공하는 서버

## 기술 스택
![Generic badge](https://img.shields.io/badge/11-OpenJDK-537E99.svg)
![Generic badge](https://img.shields.io/badge/2.6.2-SpringBoot-6DB33F.svg)
![Generic badge](https://img.shields.io/badge/8.0-MySQL-01578B.svg)
![Generic badge](https://img.shields.io/badge/5.0-MongoDB-81C564.svg)

## Setup & How To Run

### 백엔드 Docker 통합 환경에서 실행
- `/src/backend` 경로에서 다음 명령어를 사용하여 다른 프로젝트와 함께 실행
  ```
  > docker-compose pull
  > docker-compose up --build
  ```

### 로컬 환경에서 단독 서버로 실행 (소스 코드 수정 필요)
- 프로젝트 빌드 및 실행 시 OpenJDK 11 필요
- 로컬에서 MySQL 8.0 서버 구동 필요
  - `./src/main/resources/application.yml`에서 개인 환경에 맞춰서 MySQL 관련 항목 수정
  - MySQL 터미널에서 프로젝트 구동에 필요한 스키마 스크립트 로딩 필요
    - `> source [프로젝트 루트 경로]/scripts/MySQL/LastPunch_schema.sql`
    - 테스트용 데이터가 필요한 경우 테스트 데이터 스크립트 로드
      - `> source [프로젝트 루트 경로]/scripts/MySQL/workspace_test.sql`
- Eureka Client에 관한 일부 라인을 비활성화 해야 함
  - `build.gradle`에서 다음 라인을 주석처리
    - `implementation 'org.springframework.cloud:spring-cloud-starter-netflix-eureka-client'`
  - `./src/main/java/lastpunch/workspace/WorkspaceApplication.java`에서 다음 라인을 주석처리
    - `import org.springframework.cloud.netflix.eureka.EnableEurekaClient;`
    - `@EnableEurekaClient`
- 위의 모든 설정 완료 후 터미널 통해 build & run (Windows는 gradlew.bat으로 build)
  ```
  > ./gradlew build -x test
  > java -jar ./build/libs/workspace-server.jar
  ```
- `http://localhost:8082/` 주소를 통해 REST API 호출

## 프로젝트 구조
```
/src/main
├── resources
│   └── application.yml           (프로젝트 관련 설정 파일)
└── java/lastpunch/workspace
    ├── common                    (에러 처리와 서버 상태 코드 관련)
    │   └── exception             (글로벌 에러 처리 핸들러 및 BusinessException 포함)
    ├── config                    (MongoDB 관련 설정)
    ├── controller                (API 엔드포인트를 명시하는 컨트롤러)
    ├── dto                       (Entity에 관련 DTO는 하위 클래스로 포함; Wrapping을 위한 DTO만 남겨 두었음)
    ├── entity                    (DB 테이블과 entity를 1:1 매칭)
    ├── repository
    │   ├── ...Repository         (Spring JPA에서 제공하는 CRUD 인터페이스 및 @Query annotation 활용)
    │   ├── ...RepositoryCustom   (QueryDSL을 통해 query를 작성하고 하는 메소드를 정의)
    │   └── ...RepositoryImpl     (QueryDSL 메소드 구현)
    ├── service                   (controller와 repository를 연결, 비즈니스 로직 처리)
    └── WorkspaceApplication.java (애플리케이션 실행)
```

## API Reference
[API 문서 링크](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/docs/API_references/workspace_apis.md) 를 참조
