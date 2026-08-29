import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import qs.Components
import qs.Services

Rectangle {
  id: root

  color: SettingsService.colors.base00

  implicitWidth: ramRow.implicitWidth + SettingsService.spacing.horizontal
  implicitHeight: ramRow.implicitHeight + SettingsService.spacing.vertical

  property real used: 0
  property real total: 0

  RowLayout {
    id: ramRow
    anchors.centerIn: parent

    MesaText {
      text: "RAM"
      color: total > 0 && used / total > 0.8 ? SettingsService.colors.base08 : SettingsService.colors.base0A
    }

    MesaText {
      text: used.toFixed(1) + "G" + " / " + total.toFixed(0) + "G"
    }
  }

  FileView {
    id: meminfoFile

    path: "/proc/meminfo"

    onLoaded: {
      function field(name) {
        const match = text().match(new RegExp("^" + name + ":\\s+(\\d+)", "m"))
        return match ? Number(match[1]) / 1024 / 1024 : 0
      }

      const memTotal = field("MemTotal")
      const memAvailable = field("MemAvailable")

      root.total = memTotal
      root.used = memTotal - memAvailable
    }

    Component.onCompleted: reload()
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: meminfoFile.reload()
  }
}
