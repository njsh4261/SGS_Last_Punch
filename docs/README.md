# Docs

## ChangeLog
- 21.12.19 DB 스키마 이미지 파일 추가
- 22.01.03 DB 스키마 이미지 수정
  - `file` 테이블 추가 및 `message`, `reply` 테이블에 관련 필드 추가
  - Join table들의 이름을 member가 앞으로 오도록 고치고 PK 변경
- 22.01.10 DB 스키마 이미지 수정
  - MySQL 스키마에서 MongoDB로 분리한 테이블 삭제, presence 테이블 추가
  - MongoDB 스키마 이미지 및 원본 파일(drawio) 추가
  - column명을 camel case로 일괄 수정
- 22.01.10 DB 스키마 수정
  - MySQL 스키마에서 member -> account로 수정
- 22.01.26 DB 스키마 수정 및 테스트 코드 
  - 일부 필드에 UNIQUE constraint 추가
  - 테스트용 access token을 보유한 account 추가
  - Docker 환경의 스크립트도 일괄 수정
