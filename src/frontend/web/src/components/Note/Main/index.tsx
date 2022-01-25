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
    const target = e.target as HTMLInputElement;
    const index = blockList.findIndex(({ id }) => id === target.id);
    // 엔터를 누른 블록의 배열의 다음 위치에 새 블록 삽입
    if (e.key === 'Enter') {
      const randomId = uuidv4();
      setBlockList([
        ...blockList.slice(0, index + 1),
        { id: randomId },
        ...blockList.slice(index + 1, blockList.length),
      ]);
      setNewBlockId(randomId);
    }

    if (e.key === 'ArrowUp' && index > 0) {
      const previous = blockList[index - 1];
      const el = document.getElementById(previous.id);
      el?.focus();
    }
    if (e.key === 'ArrowDown' && index < blockList.length - 1) {
      const next = blockList[index + 1];
      const el = document.getElementById(next.id);
      el?.focus();
    }
    if (e.key === 'Backspace' && index > 0) {
      // todo: 삭제 후 커서 위치 어떻게 할지
      if (target.value.length < 1) {
        setBlockList([
          ...blockList.slice(0, index),
          ...blockList.slice(index + 1, blockList.length),
        ]);
      }
    }
  };

  useEffect(() => {
    (ref.current as HTMLInputElement)?.focus();
  }, [blockList]);

  return (
    <Container>
      {blockList.map((block) => (
        <Block
          ref={block.id === newBlockId ? ref : undefined}
          id={block.id}
          key={block.id}
          createBlock={createBlock}
        ></Block>
      ))}
    </Container>
  );
}
