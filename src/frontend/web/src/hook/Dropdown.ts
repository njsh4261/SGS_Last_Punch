import React, { useState, useCallback, useEffect, useRef } from 'react';

interface Returns {
  drop: boolean;
  dropdownHandler: (e: React.MouseEvent<HTMLElement>) => void;
  NAV_BUTTON_ID: string;
  NAV_DROPDOWN_ID: string;
  channelDrop: boolean;
  CHANNEL_BUTTON_CLASSNAME: string;
  CHANNEL_DROPDOWN_ID: string;
}

export default function DropdownHook(): Returns {
  const NAV_BUTTON_ID = 'nav-button';
  const NAV_DROPDOWN_ID = 'nav-dropdown';

  const CHANNEL_BUTTON_CLASSNAME = 'channel-button';
  const CHANNEL_DROPDOWN_ID = 'channel-dropdown';

  const dropRef = useRef(false);
  const dropChannelRef = useRef(false);

  const [drop, setDrop] = useState(false);
  const [channelDrop, setChannelDrop] = useState(false);

  const clickOutOfDropdownHandler = useCallback((e: MouseEvent) => {
    const { id } = e.target as Element;

    if (dropRef.current && id !== NAV_BUTTON_ID && id !== NAV_DROPDOWN_ID) {
      setDrop(false);
      dropRef.current = false;
    } else {
      const target = e.target as Element;
      if (
        dropChannelRef.current &&
        !target.classList.contains(CHANNEL_BUTTON_CLASSNAME) &&
        target.id !== CHANNEL_DROPDOWN_ID
      ) {
        setChannelDrop(false);
        dropChannelRef.current = false;
      }
    }
  }, []);

  const dropdownHandler = (e: React.MouseEvent<HTMLElement>) => {
    if ((e.target as Element).id === NAV_BUTTON_ID) {
      setDrop((currentDrop) => !currentDrop);
      dropRef.current = !dropRef.current;
      if (channelDrop || dropChannelRef) {
        setChannelDrop(false);
        dropChannelRef.current = false;
      }
    }
    if ((e.target as Element).classList.contains(CHANNEL_BUTTON_CLASSNAME)) {
      setChannelDrop((currentDrop) => !currentDrop);
      dropChannelRef.current = !dropChannelRef.current;
      if (drop || dropRef) {
        setDrop(false);
        dropRef.current = false;
      }
    }
  };

  useEffect(() => {
    window.addEventListener('click', clickOutOfDropdownHandler);
    return () => {
      window.removeEventListener('click', clickOutOfDropdownHandler);
    };
  }, []);

  return {
    drop,
    channelDrop,
    dropdownHandler,
    NAV_BUTTON_ID,
    NAV_DROPDOWN_ID,
    CHANNEL_BUTTON_CLASSNAME,
    CHANNEL_DROPDOWN_ID,
  };
}
