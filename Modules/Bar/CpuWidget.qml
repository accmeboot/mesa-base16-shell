import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import qs.Components
import qs.Services

Rectangle {
  id: root

  color: ConfigService.colors.base00

  implicitWidth: cpuRow.implicitWidth + ConfigService.spacing.horizontal
  implicitHeight: cpuRow.implicitHeight + ConfigService.spacing.vertical

  property int usage: 0

  RowLayout {
    id: cpuRow
    anchors.centerIn: parent

    MesaText {
      text: "CPU"
      color: usage > 60 ? ConfigService.colors.base08 : ConfigService.colors.base05
    }

    MesaText {
      text: usage + "%"
    }
  }

  FileView {
    id: statFile

    property real previousTotal: 0
    property real previousIdle: 0

    path: "/proc/stat"

    onLoaded: {
      // first line of /proc/stat is the aggregate: "cpu user nice system idle iowait ..."
      const times = text().split("\n")[0].split(/\s+/).slice(1).map(Number)

      const total = times.reduce((sum, time) => sum + time, 0)
      const idle = times[3] + times[4]

      const totalDiff = total - previousTotal
      const idleDiff = idle - previousIdle

      const hasBaseline = previousTotal > 0

      previousTotal = total
      previousIdle = idle

      if (hasBaseline && totalDiff > 0) root.usage = Math.round((1 - idleDiff / totalDiff) * 100)
    }

    Component.onCompleted: reload()
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: statFile.reload()
  }
}
