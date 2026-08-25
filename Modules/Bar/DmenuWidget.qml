import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

import qs.Services
import qs.Components

RowLayout {
  id: root

  spacing: 5

  visible: DmenuService.isOpen

  onVisibleChanged: {
    if (!visible) {
      searchField.text = "";
      menuList.currentIndex = 0;
    }
  }

  property var filteredApplications: {
    const query = searchField.text.toLowerCase();
    if (query === "") {
      return DmenuService.applications;
    }
    return DmenuService.applications.filter(app => app.toLowerCase().includes(query));
  }

  TextField {
    id: searchField

    Layout.fillHeight: true

    focus: true

    font.family: SettingsService.font.name
    font.pointSize: SettingsService.font.size
    color: SettingsService.colors.base05

    leftPadding: 5
    rightPadding: 5
    topPadding: 0
    bottomPadding: 0

    background: Rectangle {
      implicitWidth: 150
      color: SettingsService.colors.base02
    }

    onTextChanged: {
      menuList.currentIndex = 0;
    }

    Keys.onEscapePressed: DmenuService.close()
    Keys.onReturnPressed: {
      if (menuList.currentIndex >= 0 && menuList.currentIndex < root.filteredApplications.length) {
        DmenuService.execute(root.filteredApplications[menuList.currentIndex]);
      }
    }
    Keys.onEnterPressed: {
      if (menuList.currentIndex >= 0 && menuList.currentIndex < root.filteredApplications.length) {
        DmenuService.execute(root.filteredApplications[menuList.currentIndex]);
      }
    }
    Keys.onDownPressed: {
      menuList.currentIndex = 0;
    }
    Keys.onRightPressed: {
      if (menuList.currentIndex < 0) {
        menuList.currentIndex = 0;
      } else {
        menuList.incrementCurrentIndex();
      }
    }
    Keys.onLeftPressed: {
      if (menuList.currentIndex < 0) {
        menuList.currentIndex = 0;
      } else {
        menuList.decrementCurrentIndex();
      }
    }
  }

  ScrollView {
    Layout.fillWidth: true
    Layout.fillHeight: true

    clip: true

    ScrollBar.vertical.policy: ScrollBar.AlwaysOff
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

    spacing: 0

    ListView {
      id: menuList
      model: root.filteredApplications
      orientation: Qt.Horizontal

      keyNavigationEnabled: true

      highlightFollowsCurrentItem: true
      highlightMoveDuration: 0

      spacing: 0

      delegate: ItemDelegate {
        id: delegateRoot
        required property int index
        required property string modelData

        anchors.verticalCenter: parent?.verticalCenter

        padding: 0
        background: null

        contentItem: Rectangle {
          implicitWidth: label.implicitWidth + 20
          implicitHeight: label.implicitHeight + 5

          color: delegateRoot.ListView.isCurrentItem
            ? SettingsService.colors.base05
            : SettingsService.colors.base00

          MesaText {
            id: label
            text: modelData
            anchors.centerIn: parent

            color: delegateRoot.ListView.isCurrentItem
              ? SettingsService.colors.base00
              : SettingsService.colors.base05
          }
        }       
      }
    }
  }
}
