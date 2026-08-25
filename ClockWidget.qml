import Quickshell
import QtQuick


MesaText {
  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  text: Qt.formatDateTime(clock.date, "dddd HH:mm") + " "
}
