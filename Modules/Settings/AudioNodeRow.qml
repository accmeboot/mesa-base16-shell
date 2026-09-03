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
  property string icon: 'volume'
  property string mutedIcon: 'volume-mute'

  readonly property string displayName: {
    const node = root.node;

    if (!node.isStream) return node.nickname || node.name || node.description;

    const application = node.properties["application.name"] || node.name;
    const media = node.properties["media.name"];

    return media && media !== application ? `${application}: ${media}` : application;
  }

  signal activated

  implicitHeight: content.implicitHeight + ConfigService.spacing.vertical

  TextMetrics {
    id: volumeMetrics
    font: percent.font
    text: "100%"
  }

  ColumnLayout {
    id: content
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    anchors.leftMargin: ConfigService.spacing.horizontal / 2
    anchors.rightMargin: ConfigService.spacing.horizontal / 2
    spacing: 0
    RowLayout {
      Layout.fillWidth: true
      spacing: 0
      MesaText {
        id: label
        Layout.fillWidth: true
        Layout.minimumWidth: 0
        Layout.maximumWidth: Math.ceil(label.implicitWidth)
        text: root.displayName
        elide: Text.ElideRight
        MouseArea {
          anchors.left: parent.left
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          width: label.contentWidth
          enabled: root.selectable
          visible: root.selectable
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: root.activated()
        }
      }
      MesaIcon {
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: ConfigService.spacing.horizontal / 2
        visible: root.selectable && root.isDefault
        name: "dot"
        color: ConfigService.colors.base0B
      }
      Item {
        Layout.fillWidth: true
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
        color: ConfigService.colors.base04
      }
      MesaButton {
        Layout.alignment: Qt.AlignVCenter
        icon: root.node.audio.muted ? root.mutedIcon : root.icon
        onClicked: root.node.audio.muted = !root.node.audio.muted
      }
    }
  }
}
