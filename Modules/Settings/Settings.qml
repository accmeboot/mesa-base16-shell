import Quickshell
import Quickshell.Io
import QtQuick

import qs.Services

Scope {
  id: root

  LazyLoader {
    id: loader

    FloatingWindow {
      title: "Settings"

      implicitWidth: 800
      implicitHeight: 600

      property size size: Qt.size(implicitWidth, implicitHeight)

      minimumSize: size
      maximumSize: size

      color: ConfigService.colors.base00

      onClosed: loader.active = false

      Sections {
        anchors.fill: parent
      }
    }
  }

  IpcHandler {
    target: "settingsWindow"

    function toggle(): void {
      loader.activeAsync = !(loader.active || loader.loading);
    }
  }
}
