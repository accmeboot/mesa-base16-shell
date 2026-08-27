import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

import qs.Components
import qs.Services

Rectangle {
  color: SettingsService.colors.base00

  implicitWidth: batteryRow.implicitWidth + 20
  implicitHeight: batteryRow.implicitHeight + 5

	PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}

  property var device: Pipewire.defaultAudioSink
  property real volumeStep: 0.01

  RowLayout {
    id: batteryRow
    anchors.centerIn: parent

    MesaText {
      text: device?.audio.muted ? "" : ""
      color: device?.audio.muted ? SettingsService.colors.base08 : SettingsService.colors.base05
    }

    MesaText {
      text: Math.round(device?.audio.volume * 100) + "%"
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
    onClicked: mouse => {
      if (mouse.button === Qt.MiddleButton && device) {
        device.audio.muted = !device.audio.muted
      }
    }
    onWheel: wheel => {
      if (!device)
        return

      const delta = wheel.angleDelta.y !== 0 ? wheel.angleDelta.y : wheel.angleDelta.x
      if (delta === 0)
        return

      const steps = delta / 120
      device.audio.volume = Math.max(0, Math.min(1, device.audio.volume + steps * volumeStep))
    }
  }
}
