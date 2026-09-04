import Quickshell
import Quickshell.Io
import QtQuick

import qs.Services
import qs.Modules.Settings.Common

SettingsCard {
  id: root

  readonly property string session: Quickshell.env("XDG_CURRENT_DESKTOP") || Quickshell.env("XDG_SESSION_DESKTOP") || ""

  property string distro: ""
  property string kernel: ""
  property string hostname: ""
  property real uptime: 0

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

  component Field: InfoValue {
    color: text === "Unknown" ? ConfigService.colors.on_surface : ConfigService.colors.foreground
  }

  InfoGrid {
    InfoLabel {
      text: "OS"
    }

    Field {
      text: root.distro || "Unknown"
      font.bold: root.distro !== ""
    }

    InfoLabel {
      text: "Kernel"
    }

    Field {
      text: root.kernel || "Unknown"
    }

    InfoLabel {
      text: "Hostname"
    }

    Field {
      text: root.hostname || "Unknown"
    }

    InfoLabel {
      text: "Session"
    }

    Field {
      text: root.session || "Unknown"
    }

    InfoLabel {
      text: "Uptime"
    }

    Field {
      text: root.uptime > 0 ? root.formatUptime(root.uptime) : "Unknown"
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
