import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

import qs.Services
import qs.Components

RowLayout {
  id: root

  readonly property bool hasArguments: /\s/.test(searchField.text.trim())

  property var filteredApplications: {
    if (hasArguments) {
      return [];
    }

    const query = searchField.text.trim().toLowerCase();
    if (query === "") {
      return DmenuService.applications;
    }
    return DmenuService.applications.filter(app => app.toLowerCase().includes(query));
  }

  function submit(): void {
    const hasSelection = menuList.currentIndex >= 0 && menuList.currentIndex < filteredApplications.length;

    if (hasSelection) {
      DmenuService.execute(filteredApplications[menuList.currentIndex]);
      return;
    }

    const command = searchField.text.trim();
    if (command !== "") {
      DmenuService.execute(command);
    }
  }


  Rectangle {
    implicitWidth: toggleLabel.implicitWidth + ConfigService.spacing.horizontal
    implicitHeight: toggleLabel.implicitHeight + ConfigService.spacing.vertical

    color: ConfigService.colors.base00

    MesaText {
      id: toggleLabel

      anchors.centerIn: parent

      text: DmenuService.isOpen ? "X" : ">"
      color: ConfigService.colors.base05
    }

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      hoverEnabled: true

      onClicked: () => {
        DmenuService.isOpen ? DmenuService.close() : DmenuService.open();
      }
    }
  }

  RowLayout {
    id: menuRow

    visible: DmenuService.isOpen

    onVisibleChanged: {
      if (!visible) {
        searchField.text = "";
        menuList.currentIndex = 0;
      }
    }
    TextField {
      id: searchField

      Layout.fillHeight: true

      focus: true

      font.family: ConfigService.font.name
      font.pointSize: ConfigService.font.size
      color: ConfigService.colors.base05

      leftPadding: 5
      rightPadding: 5
      topPadding: 0
      bottomPadding: 0

      background: Rectangle {
        implicitWidth: 150
        color: ConfigService.colors.base01
      }

      onTextChanged: {
        menuList.currentIndex = 0;
      }

      Keys.onEscapePressed: DmenuService.close()
      Keys.onReturnPressed: root.submit()
      Keys.onEnterPressed: root.submit()
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

        interactive: false

        spacing: 0

        WheelHandler {
          acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad

          property int accumulated: 0

          onWheel: event => {
            accumulated += event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x;

            while (accumulated <= -120) {
              accumulated += 120;
              menuList.incrementCurrentIndex();
            }
            while (accumulated >= 120) {
              accumulated -= 120;
              menuList.decrementCurrentIndex();
            }
          }
        }

        delegate: ItemDelegate {
          id: delegateRoot
          required property int index
          required property string modelData

          anchors.verticalCenter: parent?.verticalCenter

          padding: 0
          background: null

          focusPolicy: Qt.NoFocus

          onClicked: {
            menuList.currentIndex = index;
            DmenuService.execute(modelData);
          }

          contentItem: Rectangle {
            implicitWidth: label.implicitWidth + ConfigService.spacing.horizontal
            implicitHeight: label.implicitHeight + ConfigService.spacing.vertical

            color: delegateRoot.ListView.isCurrentItem
            ? ConfigService.colors.base0D
            : ConfigService.colors.base00

            MesaText {
              id: label
              text: modelData
              anchors.centerIn: parent

              color: delegateRoot.ListView.isCurrentItem
              ? ConfigService.colors.base00
              : ConfigService.colors.base05
            }
          }       
        }
      }
    }
    MesaSeparator {}
  }
}
