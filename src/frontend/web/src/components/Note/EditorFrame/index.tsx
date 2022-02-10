import Caret from './Caret';
import React from 'react';
import { Node } from 'slate';
import { Editable, ReactEditor, RenderLeafProps, Slate } from 'slate-react';
import { ClientFrame } from './Components';
import HoveringToolbar from './HoveringToolbar/index';

export interface EditorFrame {
  editor: ReactEditor;
  value: Node[];
  onChange: (value: Node[]) => void;
  onKeyDown: (e: React.KeyboardEvent<HTMLDivElement>) => void;
  readOnly: boolean;
}

const Element: React.FC<any> = ({ attributes, children, element }) => {
  switch (element.type) {
    case 'link':
      console.log(attributes, children, element);
      return (
        <a {...attributes} href={element.href}>
          {children}
        </a>
      );
    case 'block-quote':
      return <blockquote {...attributes}>{children}</blockquote>;
    case 'bulleted-list':
      return <ul {...attributes}>{children}</ul>;
    case 'heading-one':
      return <h1 {...attributes}>{children}</h1>;
    case 'heading-two':
      return <h2 {...attributes}>{children}</h2>;
    case 'list-item':
      return <li {...attributes}>{children}</li>;
    case 'numbered-list':
      return <ol {...attributes}>{children}</ol>;
    default:
      return <p {...attributes}>{children}</p>;
  }
};

const Leaf: React.FC<RenderLeafProps> = ({ attributes, children, leaf }) => {
  if (leaf.bold) {
    children = <strong>{children}</strong>;
  }

  if (leaf.code) {
    children = (
      <code style={{ backgroundColor: 'lightGray' } as React.CSSProperties}>
        {children}
      </code>
    );
  }

  if (leaf.italic) {
    children = <em>{children}</em>;
  }

  if (leaf.underline) {
    children = <u>{children}</u>;
  }

  const data = leaf.data as any;

  return (
    <span
      {...attributes}
      style={
        {
          position: 'relative',
          backgroundColor: data?.alphaColor,
        } as React.CSSProperties
      }
    >
      {leaf.isCaret ? <Caret {...(leaf as any)} /> : null}
      {children}
    </span>
  );
};

const renderElement = (props: any) => <Element {...props} />;
const renderLeaf = (props: any) => <Leaf {...props} />;

const EditorFrame: React.FC<EditorFrame> = ({
  editor,
  value,
  onChange,
  onKeyDown,
  readOnly,
}) => {
  return (
    <ClientFrame>
      <HoveringToolbar editor={editor}></HoveringToolbar>
      <Slate editor={editor} value={value} onChange={onChange}>
        <Editable
          readOnly={readOnly}
          renderElement={renderElement}
          renderLeaf={renderLeaf}
          onKeyDown={onKeyDown}
        />
      </Slate>
    </ClientFrame>
  );
};

export default EditorFrame;
