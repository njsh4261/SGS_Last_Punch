import React, { useState, useEffect } from 'react';
import { Popper, Paper } from '@material-ui/core';
import { makeStyles } from '@material-ui/core/styles';
import { grey } from '@material-ui/core/colors';
import { Range, Editor } from 'slate';
import { ReactEditor } from 'slate-react';
import FormatBoldIcon from '@material-ui/icons/FormatBold';
import FormatItalicIcon from '@material-ui/icons/FormatItalic';
import FormatUnderlinedIcon from '@material-ui/icons/FormatUnderlined';

import StyledToggleButtonGroup from './StyledTBG';
import MarkButton from './MarkButton';

const useStyles = makeStyles(() => ({
  paper: {
    backgroundColor: grey[200],
  },
}));

export default function HoveringToolbar({ editor }: { editor: ReactEditor }) {
  const [open, setOpen] = useState(false);
  const [anchorEl, setAnchorEl] = useState<any>(null);
  const [formats, setFormats] = useState(() => []);
  const classes = useStyles();
  const { selection } = editor;
  const id = open ? 'hovering-toolbar' : undefined;

  const handleFormats = (_: any, newFormat: any) => {
    setFormats(newFormat);
    setOpen(false);
  };

  useEffect(() => {
    const domSelection = window.getSelection();

    if (
      !selection ||
      !ReactEditor.isFocused(editor) ||
      Range.isCollapsed(selection) ||
      Editor.string(editor, selection) === ''
    ) {
      setOpen(false);
      return;
    }

    const getBoundingClientRect = () =>
      domSelection?.getRangeAt(0).getBoundingClientRect();

    setOpen(true);
    setAnchorEl({
      clientWidth: getBoundingClientRect()?.width,
      clientHeight: getBoundingClientRect()?.height,
      getBoundingClientRect,
    });
  }, [editor, selection]);

  return (
    <Popper
      id={id}
      open={open}
      anchorEl={anchorEl}
      placement="top"
      modifiers={{
        offset: {
          enabled: true,
          offset: '0,5',
        },
      }}
    >
      <Paper className={classes.paper}>
        <StyledToggleButtonGroup
          value={formats}
          size="small"
          aria-label="text format"
          onChange={handleFormats}
        >
          <MarkButton editor={editor} format="bold" label="bold">
            <FormatBoldIcon />
          </MarkButton>
          <MarkButton editor={editor} format="italic" label="italic">
            <FormatItalicIcon />
          </MarkButton>
          <MarkButton editor={editor} format="underline" label="underlne">
            <FormatUnderlinedIcon />
          </MarkButton>
        </StyledToggleButtonGroup>
      </Paper>
    </Popper>
  );
}
