import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs.Services

FocusScope {
  id: root

  property var source: []
  property var labelFn: item => String(item)
  property bool searchable: false
  property alias query: searchField.text

  property Component delegate: defaultDelegate

  readonly property int count: menuList.count
  readonly property int currentIndex: menuList.currentIndex

  readonly property var items: {
    const query = searchField.text.toLowerCase();
    if (!root.searchable || query === "") {
      return root.source;
    }
    return root.source.filter(item => root.labelFn(item).toLowerCase().includes(query));
  }

  signal accepted(var item, int index)
  signal cancelled

  implicitWidth: layout.implicitWidth
  implicitHeight: layout.implicitHeight

  onVisibleChanged: {
    if (visible) {
      if (searchable) {
        searchField.forceActiveFocus();
      } else {
        root.forceActiveFocus();
      }
    } else {
      reset();
    }
  }

  function reset(): void {
    searchField.text = "";
    menuList.currentIndex = 0;
  }

  function activateCurrent(): void {
    if (menuList.currentIndex >= 0 && menuList.currentIndex < root.items.length) {
      root.accepted(root.items[menuList.currentIndex], menuList.currentIndex);
    }
  }

  function moveSelection(delta: int): void {
    if (menuList.count === 0) {
      return;
    }
    if (menuList.currentIndex < 0) {
      menuList.currentIndex = 0;
    } else {
      menuList.currentIndex = Math.max(0, Math.min(menuList.count - 1, menuList.currentIndex + delta));
    }
    menuList.positionViewAtIndex(menuList.currentIndex, ListView.Contain);
  }

  function handleKey(event): void {
    switch (event.key) {
    case Qt.Key_Escape:
      root.cancelled();
      event.accepted = true;
      break;
    case Qt.Key_Return:
    case Qt.Key_Enter:
      root.activateCurrent();
      event.accepted = true;
      break;
    case Qt.Key_Right:
    case Qt.Key_Down:
      root.moveSelection(1);
      event.accepted = true;
      break;
    case Qt.Key_Left:
    case Qt.Key_Up:
      root.moveSelection(-1);
      event.accepted = true;
      break;
    }
  }

  Keys.onPressed: event => root.handleKey(event)

  Component {
    id: defaultDelegate

    ItemDelegate {
      id: delegateRoot
      required property int index
      required property var modelData

      anchors.verticalCenter: parent?.verticalCenter

      padding: 0
      background: null

      focusPolicy: Qt.NoFocus

      HoverHandler {
        cursorShape: Qt.PointingHandCursor
      }

      onClicked: {
        menuList.currentIndex = index;
        root.activateCurrent();
      }

      contentItem: Rectangle {
        implicitWidth: label.implicitWidth + 20
        implicitHeight: label.implicitHeight + 5

        color: delegateRoot.ListView.isCurrentItem ? SettingsService.colors.base05 : SettingsService.colors.base00

        MesaText {
          id: label
          text: root.labelFn(delegateRoot.modelData)
          anchors.centerIn: parent

          color: delegateRoot.ListView.isCurrentItem ? SettingsService.colors.base00 : SettingsService.colors.base05
        }
      }
    }
  }

  RowLayout {
    id: layout
    anchors.fill: parent

    spacing: 0

    MesaText {
      visible: !root.searchable
      Layout.fillHeight: true
      Layout.rightMargin: 10
      text: ""
      verticalAlignment: Text.AlignVCenter
    }

    TextField {
      id: searchField

      visible: root.searchable

      Layout.fillHeight: true

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

      Keys.onPressed: event => root.handleKey(event)
    }

    ScrollView {
      Layout.fillWidth: true
      Layout.fillHeight: true

      Layout.preferredWidth: menuList.contentWidth
      Layout.preferredHeight: menuList.contentHeight

      clip: true

      ScrollBar.vertical.policy: ScrollBar.AlwaysOff
      ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

      ListView {
        id: menuList
        model: root.items
        orientation: Qt.Horizontal

        highlightFollowsCurrentItem: true
        highlightMoveDuration: 0

        interactive: false

        spacing: 0

        delegate: root.delegate

        WheelHandler {
          acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad

          onWheel: event => {
            const delta = event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x;

            if (delta > 0)
              root.moveSelection(-1);
            if (delta < 0)
              root.moveSelection(1);
          }
        }
      }
    }

    MesaSeparator {}
  }
}
