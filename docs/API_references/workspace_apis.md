# Workspace Server API Reference

## 워크스페이스 API
| Method | URI                             | Description               | Request Body       | Response Body      | etc                    |
|--------|---------------------------------|---------------------------|--------------------|--------------------|------------------------|
| GET    | /workspace                      | 사용자 1명의 워크스페이스 목록 조회      | -                  | 워크스페이스 목록          | paging                 |
| GET    | /workspace/{id}                 | 워크스페이스 1개의 정보 조회          | -                  | 워크스페이스 1개 정보       | 워크스페이스 소유자 정보 포함       |
| GET    | /workspace/{id}/members         | 워크스페이스 1개의 멤버 전체 조회       | -                  | 멤버 목록              |                        |
| GET    | /workspace/{id}/members/paging  | 워크스페이스 1개의 멤버 조회 (paging) | -                  | 멤버 목록              | paging                 |
| GET    | /workspace/{id}/channels        | 워크스페이스 1개의 채널 전체 조회       | -                  | 채널 목록              | 현재 요청한 사용자가 소속된 채널만 조회 |
| GET    | /workspace/{id}/channels/paging | 워크스페이스 1개의 채널 조회 (paging) | -                  | 채널 목록              | paging                 |
| POST   | /workspace                      | 워크스페이스 생성                 | WorkspaceCreateDTO | 워크스페이스, 채널 각 1개 정보 | -                      |
| PUT    | /workspace/{id}                 | 워크스페이스 수정                 | WorkspaceEditDTO   | -                  | -                      |
| DELETE | /workspace/{id}                 | 워크스페이스 삭제                 | -                  | -                  | -                      |

## 워크스페이스-멤버 API
| Method | URI               | Description      | Request Body        | Response Body | etc                                 |
|--------|-------------------|------------------|---------------------|---------------|-------------------------------------|
| POST   | /workspace/member | 워크스페이스에 멤버 추가    | AccountWorkspaceDTO | -             | -                                   |
| PUT    | /workspace/member | 워크스페이스에 멤버 정보 수정 | AccountWorkspaceDTO | -             | -                                   |
| DELETE | /workspace/member | 워크스페이스에서 멤버 삭제   | AccountWorkspaceDTO | -             | URL parameter: accountId, channelId |

## 채널 API
| Method | URI                   | Description              | Request Body     | Response Body | etc          |
|--------|-----------------------|--------------------------|------------------|---------------|--------------|
| GET    | /channel/{id}         | 채널 1개의 정보 조회             | -                | 채널 1개 정보      | 채널 소유자 정보 포함 |
| GET    | /channel/{id}/members | 채널 1개의 멤버 조회             | -                | 멤버 목록         | paging       |
| POST   | /channel              | 채널 생성                    | ChannelCreateDTO | 채널 1개 정보      | -            |
| PUT    | /channel/{id}         | 채널 수정                    | ChannelEditDTO   | -             | -            |
| DELETE | /channel/{id}         | 채널 삭제                    | -                | -             | -            |
| POST   | /channel/find         | 채널 이름으로 현재 워크스페이스의 채널 검색 | ChannelFindDTO   | 채널 목록         | paging       |


## 채널-멤버 API
| Method | URI             | Description     | Request Body      | Response Body | etc                                 |
|--------|-----------------|-----------------|-------------------|---------------|-------------------------------------|
| POST   | /channel/member | 채널에 멤버 추가       | AccountChannelDto | -             | -                                   |
| PUT    | /channel/member | 채널에 대한 멤버 정보 수정 | AccountChannelDto | -             | -                                   |
| DELETE | /channel/member | 채널에서 멤버 삭제      | -                 | -             | URL parameter: accountId, channelId |

## 계정 API
| Method | URI           | Description      | Request Body   | Response Body | etc    |
|--------|---------------|------------------|----------------|---------------|--------|
| POST   | /account/find | 이메일로 계정 목록 조회    | AccountFindDto | 계정 목록         | paging |
| GET    | /account/self | 현재 접속한 사용자 정보 조회 | -              | 계정 1개 정보      | -      |


- WorkspaceCreateDTO 예시
    ```
    {
        "workspaceName": "workspaceMake",
        "workspaceDescription": "make new workspace",
        "channelName": "channelMake",
        "channelTopic": "test",
        "channelDescription": "make new channel"
    }
    ```
    - `workspaceDescription`, `channelDescription` 생략 가능, 이외 생략 불가


- WorkspaceEditDTO 예시
  ```
  {
    "name": "workspaceEdited",
    "description": "editing workspace",
    "settings": 123
  }
  ```
  - 모든 속성 생략 가능 (모두 생략 시 `PUT /workspace/{id}` 통한 변경사항 없음)


- AccountWorkspaceDTO 예시
  ```
  {
    "accountId": 123,
    "workspaceId": 456,
    "roleId": 1
  }
  ```
  - 모든 속성 생략 불가


- ChannelCreateDTO 예시
  ```
  {
    "workspaceId": 6,
    "name": "new channel",
    "topic": "channel test",
    "description": "asdf"
  }
  ```
  - `topic`, `description` 생략 가능, 이외 생략 불가


- ChannelEditDTO 예시
  ```
  {
    "name": "edit channel",
    "topic": "test",
    "description": "qwer",
    "settings": 12
  }
  ```
  - 모든 속성 생략 가능 (모두 생략 시 `PUT /channel/{id}` 통한 변경사항 없음)

- ChannelFindDTO 예시
  ```
  {
    "workspaceId": 1,
    "name": "asdf"
  }
  ```
  - 모든 속성 생략 불가

- AccountChannelDto 예시
  ```
  {
      "accountId": 8,
      "channelId": 3,
      "roleId": 1
  }
  ```
  - 모든 속성 생략 불가

- AccountFindDto 예시
  ```
  {
      "email": "asdf@qwer"
  }
  ```
  - `email` 생략 불가

- `etc`에 `paging`으로 표기된 API는 페이징 정보를 parameter로 넘겨줘야 함
  - `page`: 요청할 페이지 번호
  - `size`: 1페이지당 조회할 element 수
  - `sort`: sorting 기준
  - e.g.) `GET http://localhost:8082/workspace/123/members?page=2&size=15`
  - 더 자세한 내용은 Spring Boot Pageable 객체 참조
