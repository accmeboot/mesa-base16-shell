import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

import qs.Components
import qs.Services


RowLayout {
  id: trayRow

  readonly property bool menuOpen: trayMenu.visible

  property bool isVisible: false

  spacing: 0

  onIsVisibleChanged: if (!trayRow.isVisible) trayMenu.close()

  visible: Boolean(SystemTray.items.values.length)

  Repeater {
    model: SystemTray.items

    Rectangle {
      id: item

      required property SystemTrayItem modelData

      visible: trayRow.isVisible

      implicitWidth: label.implicitWidth + ConfigService.spacing.horizontal
      implicitHeight: label.implicitHeight + ConfigService.spacing.vertical

      color: ConfigService.colors.base00

      MesaText {
        id: label

        anchors.centerIn: parent

        text: {
          var appName = item.modelData.title || item.modelData.tooltipTitle || item.modelData.id;
          const hasUnderscore = appName.includes("_")

          if (hasUnderscore) {
            appName = appName.substring(0, item.modelData.id.indexOf("_"));
          }

          return appName.toLowerCase()
        }
      }

      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: mouse => {
          if (mouse.button === Qt.LeftButton && !item.modelData.onlyMenu) {
            item.modelData.activate();
          } else if (item.modelData.hasMenu) {
            trayMenu.openAt(item, item.modelData.menu);
          }
        }
      }
    }
  }

  MesaMenu {
    id: trayMenu
  }

  Rectangle {
    implicitWidth: toggleLabel.implicitWidth + ConfigService.spacing.horizontal
    implicitHeight: toggleLabel.implicitHeight + ConfigService.spacing.vertical

    color: ConfigService.colors.base00

    MesaText {
      id: toggleLabel

      anchors.centerIn: parent

      text: trayRow.isVisible ? "X" : "<"
      color: ConfigService.colors.base05
    }

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      hoverEnabled: true

      onClicked: trayRow.isVisible = !trayRow.isVisible
    }
  }
}
