import Quickshell
import QtQuick

import qs.Components


MesaText {
  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  text: Qt.formatDateTime(clock.date, "dddd HH:mm") + " "
}
