# Scripts

## Schema
- `./LastPunch_schema.sql`: MySQL 콘솔에서 `source [sql_location]`를 통해 스키마를 데이터베이스에 바로 적용할 수 있음

## ChangeLog
- 21.12.19 SQL 스크립트 추가
- 22.01.03 SQL 스크립트 수정
  - `file` 테이블 추가 및 `message`, `reply` 테이블에 관련 필드 추가
  - Join table들의 이름을 member가 앞으로 오도록 고치고 PK 변경
