# Workspace server
워크스페이스 및 채널 관련 API를 제공하는 서버
- 2022.01.17: 워크스페이스 CRUD 및 멤버 추가/삭제 API 제공 

# How to Run
- MySQL 환경 세팅이 필요 (`/scripts/MySQL` 참조)
- `./src/main/resources/application.yml`에서 개인 환경에 맞춰서 내용 수정
- 설정 후 아래 명령어대로 build & run (Windows는 gradlew.bat으로 build)

```
./ > ./gradlew build
./ > java -jar ./build/libs/workspace-0.0.1-SNAPSHOT.jar 
```

# API Reference

| Method | URI               | Parameter | Body                 |
|--------|-------------------|-----------|----------------------|
| GET    | /workspace        | userId    | -                    |
| GET    | /workspace/{id}   | -         | -                    |
| POST   | /workspace        | -         | WorkspaceDTO         |
| PUT    | /workspace/{id}   | -         | WorkspaceDTO         |
| DELETE | /workspace/{id}   | -         | -                    |
| POST   | /workspace/member | -         | AccountWorkspaceDTO  |
| DELETE | /workspace/member | -         | AccountWorkspaceDTO  |


- WorkspaceDTO 예시
    ```
    {
        "name": "workspace1",
        "description": "my first workspace",
        "settings": 12,
        "status": 34,
    }
    ```
  - `POST /workspace`에서는 `name` 생략 불가능, 이외 속성은 생략 가능
  - `PUT /workspace/{id}`에서는 모든 속성 생략 가능
  

- AccountWorkspaceDTO 예시
    ```
    {
        "accountId": 123,
        "workspaceId": 456
    }
    ```

# TODO
코드 주석 내용 참조
