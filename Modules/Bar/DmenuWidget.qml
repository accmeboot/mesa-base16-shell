import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

import qs.Services
import qs.Components

RowLayout {
  id: root

  spacing: 0

  ScrollView {
    Layout.fillWidth: true
    Layout.fillHeight: true

    visible: DmenuService.isOpen

    focus: true
    clip: true

    ScrollBar.vertical.policy: ScrollBar.AlwaysOff
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

    spacing: 0

    ListView {
      id: menuList
      model: 1000
      orientation: Qt.Horizontal

      focus: true
      keyNavigationEnabled: true
      highlightFollowsCurrentItem: true

      Keys.onEscapePressed: DmenuService.close()

      spacing: 5

      delegate: ItemDelegate {
        id: delegateRoot
        required property int index

        anchors.verticalCenter: parent?.verticalCenter

        padding: 0
        background: null

        contentItem: Rectangle {
          implicitWidth: label.implicitWidth + 25
          implicitHeight: label.implicitHeight + 5

          color: delegateRoot.ListView.isCurrentItem
            ? SettingsService.colors.base0D
            : SettingsService.colors.base03

          MesaText {
            id: label
            text: "Item " + index
            anchors.centerIn: parent
          }
        }       
      }
    }
  }
}
