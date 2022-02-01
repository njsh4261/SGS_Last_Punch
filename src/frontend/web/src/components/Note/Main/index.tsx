import React, { useState, useMemo, useRef, useEffect } from 'react';
import styled from 'styled-components';
import { createEditor, Node, Text, Transforms, Editor } from 'slate';
import { withHistory } from 'slate-history';
import { withReact } from 'slate-react';
import { useParams } from 'react-router-dom';

import EditorFrame from './EditorFrame';
import { Note } from '../../../../types/note.type';
import noteSocketHook from '../../../hook/noteSocket';
import { User } from '../../../hook/noteSocket';
import {
  updateNoteAllAPI,
  updateNoteOPAPI,
  getSpecificNoteAPI,
} from '../../../Api/note';

const Container = styled.article`
  display: flex;
  flex-direction: column;
  width: 50%;
  margin: 0 96px;
  height: 100%;
`;

const TestContainer = styled.div`
  margin-top: 50px;
`;

export default function NoteMain() {
  const initialValue = [
    {
      type: 'paragraph',
      children: [{ text: '' }],
    },
  ];

  const params = useParams();
  const [note, setNote] = useState<Note | null>(null);
  const [title, setTitle] = useState('test title');
  const [value, setValue] = useState<Node[]>(initialValue);
  const editor = useMemo(() => withReact(withHistory(createEditor())), []);

  const { updateNote, remote, lockNote, unlockNote, owner, myUser, userList } =
    noteSocketHook(editor, note);

  type Timeout = ReturnType<typeof setTimeout>;
  const typing = useRef<Timeout | null>(null);

  const changeHandler = async (value: Node[]) => {
    setValue(value);
    const ops = editor.operations.filter((op) => {
      if (op) return op.type !== 'set_selection';
      return false;
    });

    // todo: op를 배열에 저장하고 수초에 한번씩 call API to note server
    if (ops.length > 0) {
      const stringOP = JSON.stringify(ops);
      const timestamp = await updateNoteOPAPI(note!.id, stringOP);
      if (timestamp) updateNote(timestamp);
      else console.error('update fail - Note/main/index');
    }
  };

  /**
   * 키 입력시 선점에 대한 핸들링
   * @ 선점자: 입력 허용
   * @ 비선점자: 선점자가 있으면 입력 금지, 없으면 선점 요창
   */
  const keydownHandler = (e: React.KeyboardEvent<HTMLDivElement>) => {
    if (owner && owner.id === myUser.id) {
      if (e.ctrlKey) {
        switch (e.key) {
          case 'b':
            e.preventDefault();
            Transforms.setNodes(
              editor,
              { bold: true },
              { match: (n) => Text.isText(n), split: true },
            );
            break;
          case 'i':
            e.preventDefault();
            Transforms.setNodes(
              editor,
              { italic: true },
              { match: (n) => Text.isText(n), split: true },
            );
            break;
          case 'u':
            e.preventDefault();
            Transforms.setNodes(
              editor,
              { underline: true },
              { match: (n) => Text.isText(n), split: true },
            );
            break;
          case '`':
            e.preventDefault();
            Transforms.setNodes(
              editor,
              { code: true },
              { match: (n) => Text.isText(n), split: true },
            );
            break;
        }
      }

      if (typing.current) clearTimeout(typing.current);
      typing.current = setTimeout(() => {
        console.log('end typing');
        unlockNote();
      }, 1000);
      return;
    }
    e.preventDefault();
    if (owner === null) {
      lockNote();
    }
  };

  // todo: onwer일 때 일정 주기마다 자동으로 api 날리기
  const updateHandler = async () => {
    if (!note) return;
    const { id } = note;
    console.log('send:', JSON.stringify(value));
    const res = await updateNoteAllAPI(id, title, JSON.stringify(value));
    if (res) console.log('updated note all!');
    else alert('fail update');
  };

  const getSpecificNoteHandler = async () => {
    if (params.noteId) {
      const responseNote = await getSpecificNoteAPI(params.noteId.toString());
      setNote(responseNote);
    } else {
      console.error('no noteId at param');
    }
  };

  useEffect(() => {
    getSpecificNoteHandler();
  }, [params]);

  useEffect(() => {
    if (owner) {
      typing.current = setTimeout(() => {
        console.log('end typing');
        unlockNote();
      }, 1000);
    }
  }, [owner]);

  useEffect(() => {
    if (note) {
      try {
        const content = JSON.parse(note.content);
        setValue(content);

        const { ops } = note;
        Editor.withoutNormalizing(editor, () => {
          ops.forEach((op: any) => editor.apply(JSON.parse(op)));
        });
      } catch (e) {
        console.error('Wrong Format - note.content');
      }
      // setTitle(note.title);
    } else setValue(initialValue);
  }, [note]);

  return (
    <>
      {!note ? (
        <div>select any note</div>
      ) : (
        <Container>
          <h1>{note?.title || title}</h1>
          <button onClick={updateHandler}>update</button>
          <EditorFrame
            value={value}
            onChange={changeHandler}
            onKeyDown={keydownHandler}
            editor={editor}
          ></EditorFrame>
          <TestContainer>
            <div>my: {JSON.stringify(myUser)}</div>
            <div>owner: {JSON.stringify(owner)}</div>
            <div>
              userList:
              {userList.map((u: User) => (
                <div key={u.id}>{JSON.stringify(u)}</div>
              ))}
            </div>
          </TestContainer>
        </Container>
      )}
    </>
  );
}
