pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  readonly property alias colors: adapter.colors
  readonly property alias font: adapter.font
  readonly property alias spacing: adapter.spacing
  readonly property alias border: adapter.border

  IpcHandler {
    target: "config"

    function reload(): void {
      view.reload();
    }
  }

  FileView {
    id: view

    path: Qt.resolvedUrl("../config.json")
    watchChanges: true
    onFileChanged: reload()

    JsonAdapter {
      id: adapter

      property JsonObject colors: JsonObject {
        property string background: "#1d2021"
        property string surface: "#3c3836"
        property string on_surface: "#504945"
        property string foreground: "#d5c4a1"
        property string highlight: "#83a598"
        property string attention: "#fabd2f"
        property string ok: "#b8bb26"
        property string critical: "#fb4934"
      }

      property JsonObject font: JsonObject {
        property string name: "JetBrainsMono Nerd Font"
        property int size: 12
      }

      property int spacing: 10

      property int border: 1
    }
  }
}
