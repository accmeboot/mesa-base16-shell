import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

import qs.Services
import qs.Modules.Settings.Common

SettingsGroup {
  id: root

  property var nodes: []
  property PwNode defaultNode: null
  property bool selectable: true
  property string icon: "volume"
  property string mutedIcon: "volume-mute"

  signal nodeActivated(PwNode node)

  empty: root.nodes.length === 0

  ColumnLayout {
    Layout.fillWidth: true

    spacing: ConfigService.border

    Repeater {
      model: root.nodes

      SettingsCard {
        id: card

        required property PwNode modelData

        AudioNodeRow {
          Layout.fillWidth: true

          node: card.modelData
          isDefault: root.defaultNode === card.modelData
          selectable: root.selectable
          icon: root.icon
          mutedIcon: root.mutedIcon

          onActivated: root.nodeActivated(card.modelData)
        }
      }
    }
  }
}
