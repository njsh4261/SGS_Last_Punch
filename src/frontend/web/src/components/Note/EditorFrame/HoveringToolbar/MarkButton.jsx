import React from 'react';
import { Editor } from 'slate';
import { useSlate } from 'slate-react';
import { ToggleButton } from '@material-ui/lab';

const isMarkActive = (editor, format) => {
  const marks = Editor.marks(editor);
  return marks ? marks[format] === true : false;
};

const toggleMark = (editor, format) => {
  const isActive = isMarkActive(editor, format);
  if (isActive) {
    Editor.removeMark(editor, format);
  } else {
    Editor.addMark(editor, format, true);
  }
};

const MarkButton = ({ format, label, className, size, children }) => {
  const editor = useSlate();
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
