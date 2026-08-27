pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property string current: ""

  readonly property bool isOpen: current !== ""

  function open(name: string): void {
    current = name;
  }

  function close(): void {
    current = "";
  }

  function toggle(name: string): void {
    current = current === name ? "" : name;
  }

  function isCurrent(name: string): bool {
    return current === name;
  }

  IpcHandler {
    target: "menu"

    function open(name: string): void {
      root.open(name);
    }

    function close(): void {
      root.close();
    }

    function toggle(name: string): void {
      root.toggle(name);
    }
  }
}
