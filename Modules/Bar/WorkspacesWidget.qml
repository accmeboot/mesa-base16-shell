import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.Services
import qs.Components

RowLayout {
  id: root

  required property var screen

  spacing: 0

  Repeater {
    model: SwayService.getWorkspacesForMonitor(root.screen.name)

    MesaButton {
      id: workspace

      required property var modelData

      visible: modelData.monitor === root.screen.name

      horizontalPadding: ConfigService.spacing * 2

      text: modelData.name
      color: {
        if (modelData.focused) {
          return ConfigService.colors.highlight
        }

        if (modelData.urgent) {
          return ConfigService.colors.critical
        }

        return ConfigService.colors.surface
      }

      contentColor: modelData.focused ? ConfigService.colors.background : ConfigService.colors.foreground

      onClicked: workspace.modelData.activate()
    }
  }
}
