import React, { useState, useEffect } from 'react';
import { Popper, Paper } from '@material-ui/core';
import { makeStyles } from '@material-ui/core/styles';
import { grey } from '@material-ui/core/colors';
import { Range, Editor } from 'slate';
import { useSlate, ReactEditor } from 'slate-react';
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

function HoveringToolbar() {
  const [open, setOpen] = useState(false);
  const [anchorEl, setAnchorEl] = useState(null);
  const [formats, setFormats] = useState(() => []);
  const classes = useStyles();
  const editor = useSlate();
  const { selection } = editor;
  const id = open ? 'hovering-toolbar' : undefined;

  const handleFormats = (_, newFormat) => {
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

    // console.log(getBoundingClientRect().height);

    setOpen(true);
    setAnchorEl({
      clientWidth: getBoundingClientRect().width,
      clientHeight: getBoundingClientRect().height,
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
          <MarkButton format="bold" label="bold">
            <FormatBoldIcon />
          </MarkButton>
          <MarkButton format="italic" label="italic">
            <FormatItalicIcon />
          </MarkButton>
          <MarkButton format="underline" label="underlne">
            <FormatUnderlinedIcon />
          </MarkButton>
        </StyledToggleButtonGroup>
      </Paper>
    </Popper>
  );
}

export default HoveringToolbar;
