import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.Services

PopupWindow {
  id: root

  property QsMenuHandle menuHandle: null
  property Item anchorItem: null
  property bool submenu: false
  property PopupWindow parentMenu: null
  property QsMenuEntry openEntry: null

  readonly property bool isOpen: root.menuHandle !== null
  readonly property bool shouldShow: root.isOpen && opener.children.values.length > 0
  readonly property int rowPadding: Math.round(ConfigService.spacing / 2)
  readonly property int indicatorSize: Math.round(ConfigService.font.size * 1.5)
  readonly property bool hasIndicators: opener.children.values.some(entry => entry.icon !== "" || entry.buttonType !== QsMenuButtonType.None)

  visible: root.shouldShow
  color: "transparent"
  grabFocus: true
  anchor.item: root.anchorItem
  anchor.edges: root.submenu ? Edges.Right | Edges.Top : Edges.Bottom | Edges.Left
  anchor.gravity: root.submenu ? Edges.Right | Edges.Bottom : Edges.Bottom | Edges.Right
  implicitWidth: background.implicitWidth
  implicitHeight: background.implicitHeight

  onBackerVisibilityChanged: if (!root.backingWindowVisible && root.shouldShow) root.closeAll()

  function openAt(item, handle): void {
    const toggle = root.isOpen && root.anchorItem === item;
    root.close();

    if (toggle) return;

    root.anchorItem = item;
    root.menuHandle = handle;
  }

  function close(): void {
    root.openEntry = null;
    root.menuHandle = null;
  }

  function closeAll(): void {
    if (root.parentMenu) root.parentMenu.closeAll();
    else root.close();
  }

  QsMenuOpener {
    id: opener

    menu: root.menuHandle
  }

  Rectangle {
    id: background

    anchors.fill: parent
    implicitWidth: entries.implicitWidth + border.width * 2
    implicitHeight: entries.implicitHeight + border.width * 2
    color: ConfigService.colors.background
    border.width: ConfigService.border
    border.color: ConfigService.colors.on_surface
    focus: true
    Keys.onEscapePressed: root.closeAll()

    ColumnLayout {
      id: entries

      anchors.fill: parent
      anchors.margins: background.border.width
      spacing: 0

      Repeater {
        model: opener.children

        Rectangle {
          id: row

          required property QsMenuEntry modelData

          readonly property bool highlighted: mouse.containsMouse
          readonly property bool submenuOpen: root.openEntry === row.modelData
          readonly property color foreground: {
            if (!modelData.enabled) return ConfigService.colors.on_surface;
            return highlighted ? ConfigService.colors.background : ConfigService.colors.foreground;
          }

          Layout.fillWidth: true
          implicitWidth: modelData.isSeparator ? 0 : content.implicitWidth + root.rowPadding * 2
          implicitHeight: modelData.isSeparator ? ConfigService.border : content.implicitHeight + ConfigService.spacing
          color: {
            if (modelData.isSeparator) return ConfigService.colors.on_surface;
            return highlighted ? ConfigService.colors.highlight : ConfigService.colors.background;
          }
          onSubmenuOpenChanged: {
            if (!row.submenuOpen) {
              submenuLoader.source = "";
              return;
            }

            submenuLoader.setSource(Qt.resolvedUrl("MesaMenu.qml"), {
              submenu: true,
              parentMenu: root,
              anchorItem: row,
              menuHandle: row.modelData
            });
          }

          RowLayout {
            id: content

            visible: !row.modelData.isSeparator
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: root.rowPadding
            anchors.rightMargin: root.rowPadding
            spacing: ConfigService.spacing

            Item {
              visible: root.hasIndicators
              Layout.preferredWidth: root.indicatorSize
              Layout.preferredHeight: root.indicatorSize

              MesaIndicator {
                id: indicator

                anchors.centerIn: parent
                visible: row.modelData.buttonType !== QsMenuButtonType.None
                checked: row.modelData.checkState === Qt.Checked
                radio: row.modelData.buttonType === QsMenuButtonType.RadioButton
                color: row.foreground
              }

              IconImage {
                anchors.centerIn: parent
                visible: !indicator.visible && row.modelData.icon !== ""
                implicitSize: root.indicatorSize
                source: row.modelData.icon
              }
            }

            MesaText {
              Layout.fillWidth: true
              text: row.modelData.text
              color: row.foreground
            }

            MesaIcon {
              visible: row.modelData.hasChildren
              name: "arrow-right"
              size: root.indicatorSize
              color: row.foreground
            }
          }

          Loader { id: submenuLoader }

          MouseArea {
            id: mouse

            anchors.fill: parent
            enabled: !row.modelData.isSeparator && row.modelData.enabled
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: root.openEntry = row.modelData.hasChildren ? row.modelData : null
            onClicked: {
              if (row.modelData.hasChildren) {
                root.openEntry = row.modelData;
                return;
              }

              row.modelData.triggered();
              root.closeAll();
            }
          }
        }
      }
    }
  }
}
