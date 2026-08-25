pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property bool isOpen: false

  function open(): void {
    isOpen = true;
  }

  function close(): void {
    isOpen = false;
  }

  IpcHandler {
    target: "dmenu"

    function open(): void {
      root.open();
    }

    function close(): void {
      root.close();
    }

    function toggle(): void {
      root.isOpen ? root.close() : root.open();
    }
  }
}
