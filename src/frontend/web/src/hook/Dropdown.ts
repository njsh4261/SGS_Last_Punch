import { useState, useCallback, useEffect, useRef } from 'react';

interface Returns {
  drop: boolean;
  dropdownHandler: () => void;
  NAV_BUTTON_ID: string;
  NAV_DROPDOWN_ID: string;
}

export default function DropdownHook(): Returns {
  const NAV_BUTTON_ID = 'nav-button';
  const NAV_DROPDOWN_ID = 'nav-modal';

  const dropRef = useRef(false);
  const [drop, setDrop] = useState(false);

  const clickOutOfDropdownHandler = useCallback((e: MouseEvent) => {
    const { id } = e.currentTarget as Element;
    if (dropRef.current && id !== NAV_BUTTON_ID && id !== NAV_DROPDOWN_ID) {
      dropdownHandler();
    }
  }, []);

  const dropdownHandler = () => {
    setDrop((currentDrop) => !currentDrop);
    dropRef.current = !dropRef.current;
  };

  useEffect(() => {
    window.addEventListener('click', clickOutOfDropdownHandler);
    return () => {
      window.removeEventListener('click', clickOutOfDropdownHandler);
    };
  }, []);

  return { drop, dropdownHandler, NAV_BUTTON_ID, NAV_DROPDOWN_ID };
}
