# Workspace server

---

워크스페이스 및 채널 관련 API를 제공하는 서버
- 2022.01.17: 워크스페이스 CRUD 및 멤버 추가/삭제 API 제공 

# How to Run

---
- Java 11 필요 (OpenJDK 11 설치 권장)
- MySQL 환경 세팅이 필요 (`/scripts/MySQL` 참조)
- `./src/main/resources/application.yml`에서 개인 환경에 맞춰서 내용 수정
- 설정 후 아래 명령어대로 build & run (Windows는 gradlew.bat으로 build)

```
./ > ./gradlew build
./ > java -jar ./build/libs/workspace-0.0.1-SNAPSHOT.jar 
```

# API Reference

---

- `/docs/API_references/backend_workspace_apis.md` 참조

# TODO

---

- 워크스페이스-멤버 API 및 채널-멤버 API에 대해 수정할 사항
  - 권한에 따라 API call permission을 지정하는 코드 추가 필요
  - 중복된 record 처리에 대한 로직 필요
- DTO에서 생략 불가능한 field가 있는데 생략된 정보가 있을 경우의 에러처리
- DB 관련 에러들을 BusinessError로 wrapping 해야 함
~~- 현재 `GET /channel/{id}/members` API가 멤버 목록을 정상 반환하지 않음 ([관련 이슈](https://github.com/njsh4261/SGS_Last_Punch/issues/91))~~ 220120 수정
- 이외 내용은 코드 주석 내용 참조
