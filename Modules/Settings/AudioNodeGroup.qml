import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

import qs.Services
import qs.Components

ColumnLayout {
  id: root

  property string title
  property string emptyText

  property alias model: list.model
  property alias defaultNode: list.defaultNode
  property alias selectable: list.selectable
  property alias visibleRows: list.visibleRows
  property alias icon: list.icon
  property alias mutedIcon: list.mutedIcon

  signal nodeActivated(PwNode node)

  Layout.fillWidth: true

  spacing: ConfigService.spacing.vertical

  MesaText {
    text: root.title
    font.bold: true
    color: ConfigService.colors.base04
  }

  MesaText {
    visible: list.count === 0

    text: root.emptyText
    color: ConfigService.colors.base03
  }

  AudioNodeList {
    id: list

    onNodeActivated: node => root.nodeActivated(node)
  }
}
