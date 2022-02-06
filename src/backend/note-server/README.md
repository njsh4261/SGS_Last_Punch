# 실시간 노트 선점 편집 서버

(작동 gif 추후 추가)

실시간 노트 편집 기능 제공 서버
- note-http 서버 (port:9000) - 노트 생성, 조회, 수정 기능 + Operation 추가, 조회 기능 
- note-websocket 서버 (port:9001) - 노트 선점 관리, 업데이트 알림(노트, 제목), 접속자 관리

## 실시간 노트 선점 편집이란?
 - 문서를 먼저 수정하기 시작한 선점자가 문서의 편집 권한을 갖고 문서에 접속한 다른 유저들은 수정되는 내용을 실시간으로 받아볼 수 있는 기능.
 - 문서를 동시편집을 위한 기술(OT, CRDT) 라이브러리를 사용하지 않고 선점 시스템을 도입하여 동시 편집을 막아서 기능을 스스로 구현.
   (라이브러리로 구현하면 라이브러리가 해주는 부분이 너무 많아 기술적으로 더 성장할 수 있는 방향으로 가기 위해 선점 편집 방식으로 구현 )

## 사용 기술 
<pre>
- Spring Boot 
- Redis  
- WebSocket + STOMP + SockJS
- MongoDB
</pre>

## 아키텍쳐 및 작동 방식

## 시나리오
### **선점**

1. 노트에 들어 왔을 때는 무선점 상태(default)
2. 무선점 상태일 때는 누구나 입력이 가능하도록 **프론트**에서 처리
3. 무선점 상태에서 누군가 입력을 할 때 **websocket 서버**로, 선점 정보 publish
4. **websocket 서버**는 이를 subscriber들에게 전송하고 Redis에 선점 정보(noteId - userId)를 저장
5. 클라이언트들은 userId를 가진 사람이 선점 상태인걸 알게 되고, **프론트**에서 입력이 불가능하도록 처리
6. 새로운 클라이언트가 해당 노트에 접속하고 **websocket 서버**로 ENTER 를 publish하면 웹소켓 서버는 Redis로부터 해당 유저에게 현재 선점자의 userId와 노트 사용자 리스트 정보를 보내줌

### **선점 상태 해제**

1. 선점자가 1초간 입력을 하지 않을 때(????) 선점 상태를 해제
2. **websocket 서버**에서는 Redis에 NoteId - null 으로 업데이트하여 선점이 끝났음을 저장하고 선점 해제 정보 subscriber에게 전송
3. **프론트**에서 입력 제한을 풀어줌
4. 유저가 브라우저를 닫거나 네트워크가 끊기는 등 웹소켓 연결이 끊어지면 **websocket 서버**에서 이를 감지하고 선점자였다면 선점 상태를 해지(Redis 업데이트)해주고, UNLOCK과 LEAVE 메세지를 생성하여 subscriber들에게 전달

### **실시간 업데이트 & 저장**

- 설계 1) 업데이트는 websocket 서버를 통해 op를 주고받는 방식으로 이루어지고, 문서 저장은 선점자가 주기적으로 전체 문서를 http 서버에 저장한다.
  => 매번 전체 문서가 http 서버로 전송되어야하기 때문에 비효율적이다.
- 설계 2) 선점자가 타이핑을 해서 op가 생기면 http 서버에서 해당 노트를 불러오고 op를 적용한 후 다시 db에 저장한다.
  => 서버에서 많은 문서에 대해 op 업데이트를 해야하기 때문에 서버에 부담이 많이 간다.
- 설계 3) 업데이트된 블록만 따로 http 서버에 저장을 하자
  => 프론트와 백 모두 블록이 update, insert되면 나머지 블록들의 인덱스가 변화하기 때문에 관련된 추가적 처리를 해줘야한다.
- 최종 설계
- 선점자가 긴 주기로 전체 문서를 서버로 보내고, op가 업데이트될 때마다 op를 서버에게 보내고 서버는 이를 버전 정보와 함께 기록한다.


1. 선점자는 op를 0.5초(???) 마다 ws/http-server로 보낸다. **('update', op), (update, content)**
2. **endtyping** 시에도 업데이트 필요
3. 다른 클라이언트들은 웹소켓 서버에서 받은 업데이트 timestamp를 통해 **http 서버**에서 op를 받아 적용시킨다.

## 예외 케이스
1. 동시에 두 유저가 선점 상태를 요청했을 때
    - 서버에서 현재 선점자가 있는지 확인해서 먼저 선점 상태를 요청한 유저만 선점권을 가지도록 한다.
2. 예상치 못하게 유저의 웹소켓 연결이 끊겼을 때
    - 기존 구현 방식에는 'LEAVE' 이벤트를 클라이언트에서 노트를 나갈때 보내는 방식으로 구현했다. 하지만 이런 방식에서는 클라이언트의 네트워크 연결이 끊겼을 때 등의 예외상황을 처리하기 힘들었다. 
    - 그래서, 클라이언트가 아닌 서버에서 웹소켓 연결이 끊겼음을 감지할 때, sessionId를 이용해서 선점자였다면 선점 상태를 해지하고, UNLOCK과 LEAVE 메세지를 생성하여 subscriber들에게 전달하는 방식으로 수정했다.


## API 문서
1. note-http 서버
- https://documenter.getpostman.com/view/7437901/UVeGpQzb

2. note-websocket 서버
<pre>
ENTRY POINT: /ws/note
SUBSCRIBE POINT: /sub/note/{noteId}
PUBLISH POINT: /pub/note

선점
{
	type: LOCK, UNLOCK
	userId,
	userName,
	noteId,
}

업데이트
{
	type: UPDATE
	userId, 
	userName,
	noteId,
	timestamp // 해당 timestamp를 가진 operation을 note-http 서버에서 조회
}

문서 참여
{
	type: ENTER, LEAVE
	noteId,
	userId,
	userName
}

SUBSCRIBE POINT: /user/note/{userId}
처음 ENTER할 경우 현재 선점자, 노트 사용자 리스트 정보 제공
{
	ownerId: number,
    ownerName: string,
	userList: [{id: number, name: string},...],
}
</pre>


## mongoDB
<pre>
</pre>

