import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.Services
import qs.Components

RowLayout {
  id: root

  required property var screen

  spacing: 0

  Repeater {
    model: SwayService.getWorkspacesForMonitor(root.screen.name)

    Rectangle {
      required property var modelData

      visible: modelData.monitor === root.screen.name

      implicitWidth: label.implicitWidth + 25
      implicitHeight: label.implicitHeight + 5

      color: modelData.focused ? SettingsService.colors.base05 : (modelData.urgent ? SettingsService.colors.base08 : SettingsService.colors.base00)

      MesaText {
        id: label
        anchors.centerIn: parent
        text: modelData.name
        color: modelData.focused ? SettingsService.colors.base00 : SettingsService.colors.base05
      }


      Rectangle {
        visible: modelData.occupied

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 3

        width: 5
        height: 5

        color: modelData.focused ? SettingsService.colors.base00 : "transparent"
        border.width: 1
        border.color: modelData.focused ? SettingsService.colors.base00 : SettingsService.colors.base05
      }

      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: modelData.activate()
      }
    }
  }
}
