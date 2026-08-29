import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.Components
import qs.Services


Rectangle {
  color: SettingsService.colors.base00

  implicitWidth: clockRow.implicitWidth + SettingsService.spacing.horizontal
  implicitHeight: clockRow.implicitHeight + SettingsService.spacing.vertical

  RowLayout {
    id: clockRow
    anchors.centerIn: parent

    MesaText {
      text: "RTC"
      color: SettingsService.colors.base0A
    }

    MesaText {
      SystemClock {
        id: clock
        precision: SystemClock.Minutes
      }

      text: Qt.formatDateTime(clock.date, "dddd HH:mm")
    }
  }
}
