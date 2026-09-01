import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

import qs.Services
import qs.Components

Item {
  id: root

  required property PwNode node

  property bool isDefault: false
  property bool selectable: true

  readonly property string displayName: {
    const node = root.node;

    if (!node.isStream) return node.nickname || node.name || node.description;

    const application = node.properties["application.name"] || node.name;
    const media = node.properties["media.name"];

    return media && media !== application ? `${application}: ${media}` : application;
  }

  readonly property int volumeWidth: 40
  readonly property int muteWidth: 70

  signal activated

  implicitHeight: content.implicitHeight + ConfigService.spacing.vertical

  RowLayout {
    id: content

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter

    anchors.leftMargin: ConfigService.spacing.horizontal / 2
    anchors.rightMargin: ConfigService.spacing.horizontal / 2

    spacing: ConfigService.spacing.horizontal / 2

    MesaText {
      visible: root.selectable
      opacity: root.isDefault ? 1 : 0

      text: "*"

      color: ConfigService.colors.base0D
    }

    MesaText {
      id: label

      Layout.fillWidth: true
      Layout.minimumWidth: 0

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

    MesaSlider {
      id: volume

      value: root.node.audio.volume

      onMoved: root.node.audio.volume = volume.value
    }

    MesaText {
      Layout.preferredWidth: root.volumeWidth

      text: `${Math.round(volume.value * 100)}%`
      horizontalAlignment: Text.AlignRight

      color: ConfigService.colors.base04
    }

    MesaText {
      id: mute

      Layout.preferredWidth: root.muteWidth

      text: root.node.audio.muted ? "[unmute]" : "[mute]"
      horizontalAlignment: Text.AlignRight

      MouseArea {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        width: mute.contentWidth

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: root.node.audio.muted = !root.node.audio.muted
      }
    }
  }
}
