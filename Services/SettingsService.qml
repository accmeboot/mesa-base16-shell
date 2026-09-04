pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property bool isOpen: false

  function open(): void {
    root.isOpen = true;
  }

  function close(): void {
    root.isOpen = false;
  }

  function toggle(): void {
    root.isOpen = !root.isOpen;
  }

  IpcHandler {
    target: "settingsWindow"

    function open(): void {
      root.open();
    }

    function close(): void {
      root.close();
    }

    function toggle(): void {
      root.toggle();
    }
  }
}
