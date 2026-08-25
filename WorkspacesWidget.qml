import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.I3
import "./services"

RowLayout {
  id: root

  required property var screen

  spacing: 0

  Repeater {
    model: WorkspacesService.getWorkspacesForMonitor(root.screen.name)

    Rectangle {
      required property var modelData

      visible: modelData.monitor === root.screen.name

      implicitWidth: label.implicitWidth + 20
      implicitHeight: label.implicitHeight + 6

      color: modelData.focused ? Settings.colors.base05 : (modelData.urgent ? Settings.colors.base08 : Settings.colors.base01)

      MesaText {
        id: label
        anchors.centerIn: parent
        text: modelData.name
        color: modelData.focused ? Settings.colors.base00 : Settings.colors.base05
      }


      Rectangle {
        visible: modelData.occupied

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 3

        width: 5
        height: 5

        color: modelData.focused ? Settings.colors.base00 : "transparent"
        border.width: 1
        border.color: modelData.focused ? Settings.colors.base00 : Settings.colors.base05
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
