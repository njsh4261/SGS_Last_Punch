import React from 'react';
import styled from 'styled-components';

const Container = styled.div`
  padding: 14px;
`;

const List = styled.article``;
const Item = styled.section`
  & + & {
    margin-top: 10px;
  }
`;

export default function NoteSideList() {
  const dummyList = [
    'hello',
    'note',
    'snack',
    'over flow test. over flow test. over flow test. over flow test. ',
  ];
  return (
    <Container>
      <List>
        {dummyList.map((item) => (
          <Item key={item}>{item}</Item>
        ))}
      </List>
    </Container>
  );
}
