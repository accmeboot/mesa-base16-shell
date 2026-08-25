pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  readonly property alias colors: adapter.colors
  readonly property alias font: adapter.font
  readonly property alias workspaces: adapter.workspaces

  IpcHandler {
    target: "settings"

    function reload(): void {
      view.reload();
    }
  }

  FileView {
    id: view

    path: Qt.resolvedUrl("../settings.json")
    watchChanges: true
    onFileChanged: reload()

    JsonAdapter {
      id: adapter

      property JsonObject colors: JsonObject {
        property string base00: "#1d2021"
        property string base01: "#3c3836"
        property string base02: "#504945"
        property string base03: "#665c54"
        property string base04: "#bdae93"
        property string base05: "#d5c4a1"
        property string base06: "#ebdbb2"
        property string base07: "#fbf1c7"
        property string base08: "#fb4934"
        property string base09: "#fe8019"
        property string base0A: "#fabd2f"
        property string base0B: "#b8bb26"
        property string base0C: "#8ec07c"
        property string base0D: "#83a598"
        property string base0E: "#d3869b"
        property string base0F: "#d65d0e"
      }


      property JsonObject font: JsonObject {
        property string name: "JetBrainsMono Nerd Font"
        property int size: 12
      }

      property JsonObject workspaces: JsonObject {
        property bool persistent: true
      }
    }
  }
}
