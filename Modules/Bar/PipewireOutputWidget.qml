import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

import qs.Components
import qs.Services

RowLayout {
  id: root

  spacing: 0

  property var device: Pipewire.defaultAudioSink
  property real volumeStep: 0.01

  readonly property bool menuOpen: MenuService.isCurrent("pipewireOutput")

  property var sinks: Pipewire.nodes.values.filter(node => node.isSink && node.audio && !node.isStream)

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  PwObjectTracker {
    objects: root.sinks
  }

  Rectangle {
    color: SettingsService.colors.base00

    implicitWidth: outputRow.implicitWidth + 20
    implicitHeight: outputRow.implicitHeight + 5

    RowLayout {
      id: outputRow
      anchors.centerIn: parent

      MesaText {
        text: device?.audio.muted ? "" : ""
        color: root.device?.audio.muted ? SettingsService.colors.base08 : SettingsService.colors.base05
      }

      MesaText {
        text: Math.round(root.device?.audio.volume * 100) + "%"
      }
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      acceptedButtons: Qt.LeftButton | Qt.MiddleButton
      onClicked: mouse => {
        if (mouse.button === Qt.LeftButton) {
          MenuService.toggle("pipewireOutput");
        }

        if (mouse.button === Qt.MiddleButton && root.device) {
          root.device.audio.muted = !root.device.audio.muted;
        }
      }
      onWheel: wheel => {
        if (!root.device)
          return;

        const delta = wheel.angleDelta.y !== 0 ? wheel.angleDelta.y : wheel.angleDelta.x;
        if (delta === 0)
          return;

        const steps = delta / 120;
        root.device.audio.volume = Math.max(0, Math.min(1, root.device.audio.volume + steps * root.volumeStep));
      }
    }
  }

  MesaMenu {
    visible: root.menuOpen

    Layout.maximumWidth: 500
    Layout.fillHeight: true

    source: root.sinks
    labelFn: node => (node === device ? "" : "") + (node.nickname || node.name)

    onAccepted: item => {
      Pipewire.preferredDefaultAudioSink = item;
      MenuService.close();
    }
    onCancelled: MenuService.close()
  }
}
