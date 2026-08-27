import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.Components
import qs.Services

RowLayout {
  id: root

  spacing: 10

  Layout.fillWidth: DmenuService.isOpen

  Rectangle {
    color: SettingsService.colors.base00

    implicitWidth: buttonLabel.implicitWidth + 20
    implicitHeight: buttonLabel.implicitHeight + 5

    MesaText {
      id: buttonLabel
      anchors.centerIn: parent
      text: ""
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: DmenuService.isOpen ? DmenuService.close() : DmenuService.open()
    }
  }

  MesaMenu {
    visible: DmenuService.isOpen

    Layout.fillWidth: true
    Layout.fillHeight: true

    searchable: true
    source: DmenuService.applications

    onAccepted: item => DmenuService.execute(item)
    onCancelled: DmenuService.close()
  }
}
