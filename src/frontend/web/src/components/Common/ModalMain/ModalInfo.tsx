import React from 'react';
import styled from 'styled-components';

const Container = styled.article`
  margin: 18px 28px;
  border: 1px solid lightgray;
  border-radius: 6px;
  overflow: hidden;
`;

const ItemBox = styled.section`
  padding: 16px 20px;
  border-bottom: 1px solid lightgray;
  background-color: white;
  :hover {
    background-color: #f6f6f6;
    cursor: pointer;
  }
  :last-child {
    border-bottom: none;
    color: #e01e5a;
  }
`;

const ItemL1 = styled.div`
  font-weight: bold;
  display: flex;
  justify-content: space-between;
`;

const ItemL1Edit = styled.div`
  color: #1264a3;
  font-size: 14px;
`;

const ItemL2 = styled.div`
  margin-top: 4px;
  opacity: 50%;
`;

export default function ModalInfo() {
  return (
    <Container>
      <ItemBox>
        <ItemL1>
          <div>주제</div>
          <ItemL1Edit>편집</ItemL1Edit>
        </ItemL1>
        <ItemL2>주제 추가</ItemL2>
      </ItemBox>
      <ItemBox>
        <ItemL1>
          <div>설명</div>
          <ItemL1Edit>편집</ItemL1Edit>
        </ItemL1>
        <ItemL2>설명 추가</ItemL2>
      </ItemBox>
      <ItemBox>
        <ItemL1>
          <div>소유자</div>
        </ItemL1>
        <ItemL2>소유자: [소유자이름], 생성 날짜: [createDt]</ItemL2>
      </ItemBox>
      <ItemBox>
        <ItemL1>채널에서 나가기</ItemL1>
      </ItemBox>
    </Container>
  );
}
