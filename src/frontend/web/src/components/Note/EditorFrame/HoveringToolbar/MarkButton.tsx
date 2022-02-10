import React from 'react';
import { Editor } from 'slate';
import { ToggleButton } from '@material-ui/lab';

const isMarkActive = (editor: any, format: any) => {
  const marks = Editor.marks(editor);
  return marks ? marks[format] === true : false;
};

const toggleMark = (editor: any, format: any) => {
  const isActive = isMarkActive(editor, format);
  if (isActive) {
    Editor.removeMark(editor, format);
  } else {
    Editor.addMark(editor, format, true);
  }
};

const MarkButton = ({
  editor,
  format,
  label,
  className,
  size,
  children,
}: any) => {
  return (
    <ToggleButton
      selected={isMarkActive(editor, format)}
      onMouseDown={(event) => {
        event.preventDefault();
        toggleMark(editor, format);
      }}
      value={format}
      className={className}
      size={size}
      aria-label={label}
    >
      {children}
    </ToggleButton>
  );
};

export default MarkButton;
