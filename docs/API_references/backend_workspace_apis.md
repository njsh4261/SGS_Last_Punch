# 워크스페이스 서버 API 명세서

---

## 워크스페이스 API
| Method | URI                      | Description          | Parameter | Request Body       | etc    |
|--------|--------------------------|----------------------|-----------|--------------------|--------|
| GET    | /workspace               | 사용자 1명의 워크스페이스 목록 조회 | userId    | -                  | -      |
| GET    | /workspace/{id}          | 워크스페이스 1개의 정보 조회     | -         | -                  | -      |
| GET    | /workspace/{id}/members  | 워크스페이스 1개의 멤버 조회     | -         | -                  | paging |
| GET    | /workspace/{id}/channels | 워크스페이스 1개의 채널 조회     | -         | -                  | paging |
| POST   | /workspace               | 워크스페이스 생성            | -         | WorkspaceImportDTO | -      |
| PUT    | /workspace/{id}          | 워크스페이스 수정            | -         | WorkspaceImportDTO | -      |
| DELETE | /workspace/{id}          | 워크스페이스 삭제            | -         | -                  | -      |

## 워크스페이스-멤버 API
| Method | URI               | Description    | Parameter | Request Body        | etc |
|--------|-------------------|----------------|-----------|---------------------|-----|
| POST   | /workspace/member | 워크스페이스에 멤버 추가  | -         | AccountWorkspaceDTO | -   |
| DELETE | /workspace/member | 워크스페이스에서 멤버 삭제 | -         | AccountWorkspaceDTO | -   |

## 채널 API
| Method | URI                   | Description  | Parameter | Request Body     | etc    |
|--------|-----------------------|--------------|-----------|------------------|--------|
| GET    | /channel/{id}         | 채널 1개의 정보 조회 | -         | -                | -      |
| GET    | /channel/{id}/members | 채널 1개의 멤버 조회 | -         | -                | paging |
| POST   | /channel              | 채널 생성        | -         | ChannelImportDTO | -      |
| PUT    | /channel/{id}         | 채널 수정        | -         | ChannelImportDTO | -      |
| DELETE | /channel/{id}         | 채널 삭제        | -         | ChannelImportDTO | -      |

## 채널-멤버 API
| Method | URI             | Description     | Parameter | Request Body      | etc |
|--------|-----------------|-----------------|-----------|-------------------|-----|
| POST   | /channel/member | 채널에 멤버 추가       | -         | AccountChannelDto | -   |
| PUT    | /channel/member | 채널에 대한 멤버 정보 수정 | -         | AccountChannelDto | -   |
| DELETE | /channel/member | 채널에서 멤버 삭제      | -         | AccountChannelDto | -   |


- WorkspaceImportDTO 예시
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
    - 모든 속성이 항상 필요함


- ChannelImportDTO 예시
  ```
  {
      "workspaceId": 6,
      "creatorId": 3,
      "name": "new channel",
      "topic": "channel test",
      "description": "asdf",
      "settings": 123,
      "status": 45
  }
  ```
  - `POST /channel`에서 `workspaceId`, `creatorId`, `name` 필수
  - `PUT /workspace/{id}`에서 모든 속성 생략 가능


- AccountChannelDto 예시
  ```
  {
      "accountId": 8,
      "channelId": 3,
      "roleId": 1
  }
  ```
  - `DELETE /channel/member`에서만 `roleId` 생략 가능
  - 이외 속성 생략 불가


- `etc`에 `paging`으로 표기된 API는 페이징 정보를 parameter로 넘겨줘야 함
  - `page`: 요청할 페이지 번호
  - `size`: 1페이지당 조회할 element 수
  - `sort`: sorting 기준
  - e.g.) `GET http://localhost:8080/workspace/123/members?page=2&size=15`
  - 더 자세한 내용은 Spring Boot Pageable 객체 참조
