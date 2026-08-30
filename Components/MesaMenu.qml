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

  property Loader activeSubmenu: null

  property bool pendingOpen: false
  property bool settled: false
  readonly property bool ready: opener.children.values.length > 0

  readonly property int rowPadding: Math.round(SettingsService.spacing.vertical / 2)
  readonly property int indicatorSize: Math.round(SettingsService.font.size * 1.5)
  readonly property bool hasIndicators: opener.children.values.some(entry => entry.icon !== "" || entry.buttonType !== QsMenuButtonType.None)

  visible: root.pendingOpen && root.ready && root.settled
  color: "transparent"
  grabFocus: true

  anchor.item: root.anchorItem
  anchor.edges: root.submenu ? Edges.Right | Edges.Top : Edges.Bottom | Edges.Left
  anchor.gravity: root.submenu ? Edges.Right | Edges.Bottom : Edges.Bottom | Edges.Right

  implicitWidth: background.implicitWidth
  implicitHeight: background.implicitHeight

  onImplicitWidthChanged: root.remap()
  onImplicitHeightChanged: root.remap()

  function openAt(item, handle): void {
    const reopening = root.pendingOpen && root.anchorItem === item;
    root.close();

    if (reopening) return;

    root.anchorItem = item;
    root.menuHandle = handle;
    root.pendingOpen = true;
    root.remap();
  }

  function remap(): void {
    root.settled = false;
    if (root.pendingOpen) settleTimer.restart();
  }

  function close(): void {
    root.closeSubmenu();
    root.pendingOpen = false;
    root.settled = false;
  }

  function closeAll(): void {
    if (root.parentMenu) root.parentMenu.closeAll();
    else root.close();
  }

  function closeSubmenu(): void {
    if (!root.activeSubmenu) return;

    if (root.activeSubmenu.item) root.activeSubmenu.item.close();
    root.activeSubmenu.source = "";
    root.activeSubmenu = null;
  }

  Timer {
    id: settleTimer

    interval: 30
    onTriggered: root.settled = true
  }

  QsMenuOpener {
    id: opener
    menu: root.pendingOpen ? root.menuHandle : null
  }

  Rectangle {
    id: background

    anchors.fill: parent

    implicitWidth: entries.implicitWidth + border.width * 2
    implicitHeight: entries.implicitHeight + border.width * 2

    color: SettingsService.colors.base00

    border.width: 2
    border.color: SettingsService.colors.base02

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
          readonly property color foreground: {
            if (!modelData.enabled) return SettingsService.colors.base03;
            return highlighted ? SettingsService.colors.base00 : SettingsService.colors.base05;
          }

          Layout.fillWidth: true

          implicitWidth: modelData.isSeparator ? 0 : content.implicitWidth + SettingsService.spacing.horizontal
          implicitHeight: modelData.isSeparator ? 1 : content.implicitHeight + root.rowPadding * 2

          color: {
            if (modelData.isSeparator) return SettingsService.colors.base01;
            return highlighted ? SettingsService.colors.base05 : SettingsService.colors.base00;
          }

          function openSubmenu(): void {
            if (root.activeSubmenu === submenuLoader) return;

            root.closeSubmenu();

            submenuLoader.setSource(Qt.resolvedUrl("MesaMenu.qml"), {
              submenu: true,
              parentMenu: root
            });
            submenuLoader.item.openAt(row, row.modelData);

            root.activeSubmenu = submenuLoader;
          }

          function activate(): void {
            if (row.modelData.hasChildren) {
              row.openSubmenu();
              return;
            }

            row.modelData.triggered();
            root.closeAll();
          }

          RowLayout {
            id: content

            visible: !row.modelData.isSeparator

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: SettingsService.spacing.horizontal / 2
            anchors.rightMargin: SettingsService.spacing.horizontal / 2

            spacing: SettingsService.spacing.horizontal / 2

            Item {
              visible: root.hasIndicators

              Layout.preferredWidth: Math.max(root.indicatorSize, checkMark.visible ? checkMark.implicitWidth : 0)
              Layout.preferredHeight: root.indicatorSize

              MesaText {
                id: checkMark

                anchors.centerIn: parent

                visible: row.modelData.buttonType !== QsMenuButtonType.None
                color: row.foreground

                text: {
                  const checked = row.modelData.checkState === Qt.Checked;

                  if (row.modelData.buttonType === QsMenuButtonType.CheckBox) return checked ? "[x]" : "[ ]";
                  if (row.modelData.buttonType === QsMenuButtonType.RadioButton) return checked ? "(o)" : "( )";
                  return "";
                }
              }

              IconImage {
                anchors.centerIn: parent

                visible: !checkMark.visible && row.modelData.icon !== ""

                implicitSize: root.indicatorSize
                source: row.modelData.icon
              }
            }

            MesaText {
              Layout.fillWidth: true

              text: row.modelData.text
              color: row.foreground
            }

            MesaText {
              visible: row.modelData.hasChildren

              text: ">"
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

            onEntered: {
              if (row.modelData.hasChildren) row.openSubmenu();
              else root.closeSubmenu();
            }

            onClicked: row.activate()
          }
        }
      }
    }
  }
}
