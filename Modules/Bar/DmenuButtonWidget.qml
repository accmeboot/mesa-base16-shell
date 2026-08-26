import Quickshell
import QtQuick

import qs.Components
import qs.Services


Rectangle {
  color: SettingsService.colors.base00

  implicitWidth: buttonLabel.implicitWidth + 20
  implicitHeight: buttonLabel.implicitHeight + 5

  MesaText {
    id: buttonLabel
    anchors.centerIn: parent
    text: ""
    color: SettingsService.colors.base0A
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: DmenuService.isOpen ? DmenuService.close() : DmenuService.open()
  }
}
