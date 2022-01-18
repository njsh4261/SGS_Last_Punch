import React, { useState, useRef, useEffect } from 'react';
import { v4 as uuidv4 } from 'uuid';
import styled from 'styled-components';
import Block from './Block';

const Container = styled.article`
  display: flex;
  flex-direction: column;
  margin: 0 96px;
  height: 100%;
`;

export default function NoteMain() {
  const ref = useRef<HTMLInputElement>(null);
  const [newBlockId, setNewBlockId] = useState(uuidv4()); // 새로 생성되어 focus될 blcok id
  const [blockList, setBlockList] = useState([{ id: newBlockId }]); // todo: 블록 데이터 저장

  const createBlock = (e: React.KeyboardEvent) => {
    // 엔터를 누른 블록의 배열의 다음 위치에 새 블록 삽입
    if (e.key === 'Enter') {
      const randomId = uuidv4();
      const index = blockList.findIndex(
        ({ id }) => id === (e.target as HTMLInputElement).id,
      );

      setBlockList([
        ...blockList.slice(0, index + 1),
        { id: randomId },
        ...blockList.slice(index + 1, blockList.length),
      ]);
      setNewBlockId(randomId);
    }
  };

  useEffect(() => {
    (ref.current as HTMLInputElement)?.focus();
  }, [blockList]);

  return (
    <Container>
      {blockList.map((block) =>
        block.id === newBlockId ? (
          <Block
            ref={ref}
            id={block.id}
            key={block.id}
            createBlock={createBlock}
          ></Block>
        ) : (
          <Block id={block.id} key={block.id} createBlock={createBlock}></Block>
        ),
      )}
    </Container>
  );
}
