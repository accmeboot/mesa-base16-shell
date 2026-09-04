import Quickshell
import QtQuick

import qs.Services

Scope {
  id: root

  LazyLoader {
    id: loader

    activeAsync: SettingsService.isOpen

    FloatingWindow {
      title: "Settings"

      implicitWidth: 600
      implicitHeight: 600

      property size size: Qt.size(implicitWidth, implicitHeight)

      minimumSize: size
      maximumSize: size

      color: ConfigService.colors.background

      onClosed: SettingsService.close()

      Rectangle {
        id: background

        anchors.fill: parent

        color: ConfigService.colors.background

        border.color: ConfigService.colors.on_surface
        border.width: ConfigService.border

        Sections {
          anchors.fill: parent
          anchors.margins: background.border.width
        }
      }
    }
  }
}
