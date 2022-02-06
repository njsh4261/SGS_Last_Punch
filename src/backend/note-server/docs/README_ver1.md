# 실시간 노트 편집 서버

실시간 노트 편집 기능에 관련된 서버
- note-http 서버 (port:9000)
- note-websocket 서버 (port:9001)

자세한 request, response는 API 문서(https://documenter.getpostman.com/view/7437901/UVe9S9zg) 혹은 postman workspace 참고


## API 및 작동 방식

### 1. POST `/note` 새 노트 생성
- 노트 제목(title)과 제목 블록의 id(titleBlockId) 입력 - 모든 블록 id는 프론트에서 생성해야하기 때문에 제목 블록의 id도 프론트에서 생성
- response: 새로 생성된 노트의 id

### 2. GET `/note` 채널에 속한 노트 목록 조회
- 노트id, 제목 등 노트의 일부 정보만 반환

### 3. PATCH `/note` 노트 수정 (블록 정보 업데이트)
- transactions에 어떤 블록(id)이 어떻게 수정(op)되었는지 작성하면 서버에서는 기존 노트에 transaction을 적용한 후 mongoDB에 수정된 노트를 저장
- 각 transaction은 하나의 블록의 수정사항만을 다루고, content에는 블록 텍스트 전체가 들어가야함
- 아래 예시는 1,2,3번 블록을 생성하고 2번 블록의 content를 수정하고, 3번 블록을 삭제 -> 결과는 4번 GET /note/{noteId} 에서 확인
```
{
    "noteId": "61f01a088118c7207a9fce0d",
    "transactions":
    [
        {
        "op": "insert",
        "id": "1",
        "type": "text",
        "parentBlockId": "0",
        "lastModifyDt": "2022-01-19T14:14:03.452", 
        "lastWriter": 1,
        "content": "content1"
        },
        {
        "op": "insert",
        "id": "2",
        "type": "text",
        "parentBlockId": "0",
        "lastModifyDt": "2022-01-19T14:14:03.452", 
        "lastWriter": 1,
        "content": "content2"
        },
        {
        "op": "insert",
        "id": "3",
        "type": "text",
        "parentBlockId": "0",
        "lastModifyDt": "2022-01-19T14:14:03.452", 
        "lastWriter": 1,
        "content": "content3"
        },
        {
        "op": "update",
        "id": "2",
        "type": "text",
        "parentBlockId": "0",
        "lastModifyDt": "2022-01-19T14:14:03.452", 
        "lastWriter": 2,
        "content": "content2-updated"
        },
        {
        "op": "delete",
        "id": "3"
        }
    ]
}
```

### 4. GET `/note/{noteId}` 노트 조회
- noteId에 해당하는 노트 조회
- 3번 예시의 결과로 1번 블록이 생성되었고, 2번 블록의 content가 변경되었고, 3번 블록이 삭제됨을 확인 가능.
```
{
    "code": "15000",
    "data": {
        "note": {
            "id": "61f01a088118c7207a9fce0d",
            "blocks": [
                {
                    "id": "some-block-id",
                    "type": "title",
                    "parentBlockId": null,
                    "lastModifyDt": null,
                    "lastWriter": null,
                    "content": "Note2"
                },
                {
                    "id": "1",
                    "type": "text",
                    "parentBlockId": "0",
                    "lastModifyDt": "2022-01-19T14:14:03.452",
                    "lastWriter": 1,
                    "content": "content1"
                },
                {
                    "id": "2",
                    "type": "text",
                    "parentBlockId": "0",
                    "lastModifyDt": "2022-01-19T14:14:03.452",
                    "lastWriter": 2,
                    "content": "content2-updated"
                }
            ],
            "createdt": "2022-01-26T00:40:56.189",
            "modifydt": "2022-01-26T00:40:56.189"
        }
    }
}
```

### 5. POST `/note/block`
- 주의! => 조회 API이지만 body가 필요하기 때문에 POST method 사용
- 노트Id와 웹소켓을 통해 서버에서 받은 업데이트된 블록들의 id를 사용해 서버에서 업데이트된 블록 데이터 조회
- 프론트에서 업데이트된 블록 데이터를 사용자의 노트 화면에 반영시켜서 보여줘야함

### 6. WebSocket
- Entry point: `/ws/note`
  - http://[gateway-address]/ws/note (sockJS 연결 주소- Web)
  - ws://[gateway-address]/ws/note (웹소켓 STOMP 연결 주소- iOS)

- Publish message: `/pub/note/update`
  - 자신이 변경한 블록, 커서 정보를 전송. 정보의 타입은 type으로 구분
- Subscibe message: `/topic/note/{noteId}`
  - {noteId}에 해당하는 모든 변경사항 정보 구독

- 데이터 전송 형식
  - 송수신 모두 JSON 사용
  - 데이터는 아래 Payload의 형식
  - Type: ENTER - 노트 입장, UPDATE - 노트 변경, CURSOR - 커서 위치 변경
```
public class Payload {
    // 메시지 타입 : 입장, 노트 업데이트
    public enum Type {
        ENTER, UPDATE, CURSOR
    }
    private Type type; // 메시지 타입
    private String noteId; // 노트 번호
    private String sender; // 메세지 보낸 사람 id
    private List<String> blockId; // 업데이트된 블록들 id
    private LocalDateTime createDt;
}
```


## 이슈
(2022.1.25)
- 노트id, 블록id에 대한 협의 필요 (현재 노트id는 mongoDB에서 쓰는 objectId, 블록id는 String 사용)