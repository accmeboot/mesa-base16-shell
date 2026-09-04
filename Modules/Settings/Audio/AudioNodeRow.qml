import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

import qs.Services
import qs.Components

ColumnLayout {
  id: root

  required property PwNode node

  property bool isDefault: false
  property bool selectable: true
  property string icon: "volume"
  property string mutedIcon: "volume-mute"

  readonly property string displayName: {
    const node = root.node;

    if (!node.isStream) return node.nickname || node.description || node.name;

    const application = node.properties["application.name"] || node.name;
    const media = node.properties["media.name"];

    return media && media !== application ? `${application}: ${media}` : application;
  }

  signal activated

  spacing: 0

  TextMetrics {
    id: volumeMetrics

    font: percent.font
    text: "100%"
  }

  RowLayout {
    Layout.fillWidth: true

    spacing: ConfigService.spacing

    MesaIcon {
      Layout.alignment: Qt.AlignVCenter

      visible: root.selectable && root.isDefault
      name: "dot"
      color: ConfigService.colors.ok
      size: ConfigService.font.size * 0.5
    }

    MesaText {
      id: label

      Layout.fillWidth: true

      text: root.displayName
      elide: Text.ElideRight

      MouseArea {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: label.contentWidth

        enabled: root.selectable
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: root.activated()
      }
    }
  }

  RowLayout {
    Layout.fillWidth: true

    MesaSlider {
      id: volume

      Layout.fillWidth: true

      value: root.node.audio.volume

      onMoved: root.node.audio.volume = volume.value
    }

    MesaText {
      id: percent

      Layout.preferredWidth: Math.ceil(volumeMetrics.advanceWidth)

      text: `${Math.round(volume.value * 100)}%`
      horizontalAlignment: Text.AlignRight
      color: ConfigService.colors.foreground
    }

    MesaButton {
      Layout.alignment: Qt.AlignVCenter

      icon: root.node.audio.muted ? root.mutedIcon : root.icon

      onClicked: root.node.audio.muted = !root.node.audio.muted
    }
  }
}
