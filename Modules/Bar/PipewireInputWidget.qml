import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

import qs.Components
import qs.Services

RowLayout {
  id: root

  spacing: 0

  property var device: Pipewire.defaultAudioSource
  property real volumeStep: 0.01

  readonly property bool menuOpen: MenuService.isCurrent("pipewireInput")

  property var sources: Pipewire.nodes.values.filter(node => !node.isSink && node.audio && !node.isStream)

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSource]
  }

  PwObjectTracker {
    objects: root.sources
  }

  Rectangle {
    color: SettingsService.colors.base00

    implicitWidth: inputRow.implicitWidth + 20
    implicitHeight: inputRow.implicitHeight + 5

    RowLayout {
      id: inputRow
      anchors.centerIn: parent

      MesaText {
        text: device?.audio.muted ? "" : ""
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
          MenuService.toggle("pipewireInput");
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

    source: root.sources
    labelFn: node => (node === device ? "" : "") + (node.nickname || node.name)

    onAccepted: item => {
      Pipewire.preferredDefaultAudioSource = item;
      MenuService.close();
    }
    onCancelled: MenuService.close()
  }
}
