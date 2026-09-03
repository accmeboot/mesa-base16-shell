import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Pipewire

import qs.Services

Rectangle {
  id: root

  property alias model: view.model
  readonly property alias count: view.count

  property PwNode defaultNode: null
  property bool selectable: true
  property int visibleRows: 3
  property string icon: 'volume'
  property string mutedIcon: 'volume-mute'

  readonly property int padding: ConfigService.spacing.vertical

  signal nodeActivated(PwNode node)

  Layout.fillWidth: true
  Layout.preferredHeight: view.contentHeight + root.padding * 2
  Layout.maximumHeight: view.rowHeight * root.visibleRows + root.padding * 2

  visible: view.count > 0

  color: ConfigService.colors.base01

  ListView {
    id: view

    readonly property real rowHeight: count > 0 ? contentHeight / count : 0

    anchors.fill: parent
    anchors.margins: root.padding

    clip: true
    boundsBehavior: Flickable.StopAtBounds

    ScrollBar.vertical: ScrollBar {
      policy: view.count > root.visibleRows ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
    }

    delegate: AudioNodeRow {
      required property PwNode modelData

      width: ListView.view.width

      node: modelData
      isDefault: root.defaultNode === modelData
      selectable: root.selectable
      icon: root.icon
      mutedIcon: root.mutedIcon

      onActivated: root.nodeActivated(modelData)
    }
  }
}
