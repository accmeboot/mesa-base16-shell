import Quickshell
import QtQuick

import qs.Components
import qs.Services


Rectangle {
  color: SettingsService.colors.base00

  implicitWidth: clockText.implicitWidth + 20
  implicitHeight: clockText.implicitHeight + 5

  MesaText {
    id: clockText
    anchors.centerIn: parent

    SystemClock {
      id: clock
      precision: SystemClock.Minutes
    }

    text: Qt.formatDateTime(clock.date, "dddd HH:mm")
  }
}
