# Scripts

## Schema
- `./LastPunch_schema.sql`: MySQL 콘솔에서 `source [sql_location]`를 통해 스키마를 데이터베이스에 바로 적용할 수 있음

## ChangeLog
- 21.12.19 SQL 스크립트 추가
- 22.01.03 SQL 스크립트 수정
  - `file` 테이블 추가 및 `message`, `reply` 테이블에 관련 필드 추가
  - Join table들의 이름을 member가 앞으로 오도록 고치고 PK 변경
- 22.01.10 DB 스키마 수정 및 추가
  - MySQL 스키마에서 MongoDB로 분리한 테이블 삭제, presence 테이블 추가
  - [MongoDB schema validation](https://docs.mongodb.com/manual/core/schema-validation/) 용도의 json 파일 추가
  - column명을 camel case로 일괄 수정
- 22.01.10 DB 스키마 수정
  - MySQL 스키마에서 member -> account로 수정 (연관 테이블 일괄 수정)
    - MySQL 8.0에서 member가 예약어인 관계로 생기는 문제 해결
- 22.01.17 DB 스키마 수정 및 SQL 테스트 스크립트 추가
  - 일관성을 위해 DB 테이블명 표기법을 snake case에서 소문자만 사용하는 방식으로 변경
  - 워크스페이스 서버 테스트용 SQL insert 스크립트 추가
