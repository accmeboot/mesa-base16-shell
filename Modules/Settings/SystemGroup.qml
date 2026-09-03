import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import qs.Services
import qs.Components

ColumnLayout {
  id: root

  property string distro: ""
  property string kernel: ""
  property string hostname: ""
  property real uptime: 0

  readonly property string session: Quickshell.env("XDG_CURRENT_DESKTOP") || Quickshell.env("XDG_SESSION_DESKTOP") || ""

  Layout.fillWidth: true
  spacing: ConfigService.spacing.vertical

  component InfoRow: MesaText {
    Layout.fillWidth: true
    elide: Text.ElideRight
    color: text === "Unknown" ? ConfigService.colors.base03 : ConfigService.colors.base05
  }

  function formatUptime(seconds: real): string {
    const days = Math.floor(seconds / 86400);
    const hours = Math.floor(seconds % 86400 / 3600);
    const minutes = Math.floor(seconds % 3600 / 60);

    const parts = [];

    if (days > 0) parts.push(`${days}d`);
    if (hours > 0) parts.push(`${hours}h`);
    parts.push(`${minutes}m`);

    return parts.join(" ");
  }

  Rectangle {
    Layout.fillWidth: true
    implicitHeight: content.implicitHeight + ConfigService.spacing.vertical * 2
    color: ConfigService.colors.base01

    GridLayout {
      id: content
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      anchors.leftMargin: ConfigService.spacing.horizontal / 2
      anchors.rightMargin: ConfigService.spacing.horizontal / 2
      columns: 2
      columnSpacing: ConfigService.spacing.horizontal
      rowSpacing: ConfigService.spacing.vertical / 2

      MesaText {
        text: "OS"
        color: ConfigService.colors.base04
      }

      InfoRow {
        text: root.distro || "Unknown"
        font.bold: root.distro !== ""
      }

      MesaText {
        text: "Kernel"
        color: ConfigService.colors.base04
      }

      InfoRow {
        text: root.kernel || "Unknown"
      }

      MesaText {
        text: "Hostname"
        color: ConfigService.colors.base04
      }

      InfoRow {
        text: root.hostname || "Unknown"
      }

      MesaText {
        text: "Session"
        color: ConfigService.colors.base04
      }

      InfoRow {
        text: root.session || "Unknown"
      }

      MesaText {
        text: "Uptime"
        color: ConfigService.colors.base04
      }

      InfoRow {
        text: root.uptime > 0 ? root.formatUptime(root.uptime) : "Unknown"
      }
    }
  }

  FileView {
    path: "/etc/os-release"
    onLoaded: {
      const match = text().match(/^PRETTY_NAME="?(.*?)"?$/m);
      if (match) root.distro = match[1];
    }
    Component.onCompleted: reload()
  }

  FileView {
    path: "/proc/sys/kernel/osrelease"
    onLoaded: root.kernel = text().trim()
    Component.onCompleted: reload()
  }

  FileView {
    path: "/proc/sys/kernel/hostname"
    onLoaded: root.hostname = text().trim()
    Component.onCompleted: reload()
  }

  FileView {
    id: uptimeFile
    path: "/proc/uptime"
    onLoaded: root.uptime = Number(text().split(/\s+/)[0])
    Component.onCompleted: reload()
  }

  Timer {
    interval: 30000
    running: true
    repeat: true
    onTriggered: uptimeFile.reload()
  }
}
