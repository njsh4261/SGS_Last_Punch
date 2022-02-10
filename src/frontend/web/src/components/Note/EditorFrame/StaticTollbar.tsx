import React from 'react';
import { isBlockActive, toggleBlock } from './plugin/block';
import { insertLink, isLinkActive, unwrapLink } from './plugin/link';
import { isMarkActive, toggleMark } from './plugin/mark';
import { Icon, IconButton } from './Components';
import { useSlate } from 'slate-react';

const BlockButton: React.FC<any> = ({ format, icon }) => {
  const editor = useSlate();
  return (
    <IconButton
      active={isBlockActive(editor, format)}
      onMouseDown={(event: React.MouseEvent) => {
        event.preventDefault();
        toggleBlock(editor, format);
      }}
    >
      <Icon className="material-icons">{icon}</Icon>
    </IconButton>
  );
};

const MarkButton: React.FC<any> = ({ format, icon }) => {
  const editor = useSlate();
  return (
    <IconButton
      active={isMarkActive(editor, format)}
      onMouseDown={(event: React.MouseEvent) => {
        event.preventDefault();
        toggleMark(editor, format);
      }}
    >
      <Icon className="material-icons">{icon}</Icon>
    </IconButton>
  );
};

const LinkButton = () => {
  const editor = useSlate();

  const isActive = isLinkActive(editor);

  return (
    <IconButton
      active={isActive}
      onMouseDown={(event: React.MouseEvent) => {
        event.preventDefault();

        if (isActive) return unwrapLink(editor);

        const url = window.prompt('Enter the URL of the link:');

        url && insertLink(editor, url);
      }}
    >
      <Icon className="material-icons">link</Icon>
    </IconButton>
  );
};

export default function StaticTollbar() {
  return (
    <div
      style={{
        display: 'flex',
        flexWrap: 'wrap',
        position: 'sticky',
        top: 0,
        backgroundColor: 'white',
        zIndex: 1,
      }}
    >
      <MarkButton format="bold" icon="format_bold" />
      <MarkButton format="italic" icon="format_italic" />
      <MarkButton format="underline" icon="format_underlined" />
      <MarkButton format="code" icon="code" />

      <BlockButton format="heading-one" icon="looks_one" />
      <BlockButton format="heading-two" icon="looks_two" />
      <BlockButton format="block-quote" icon="format_quote" />

      <BlockButton format="numbered-list" icon="format_list_numbered" />
      <BlockButton format="bulleted-list" icon="format_list_bulleted" />

      <LinkButton />
    </div>
  );
}
