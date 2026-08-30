import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Wayland
import QtQuick.Layouts

import qs.Services
import qs.Components

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      color: SettingsService.colors.base00

      WlrLayershell.keyboardFocus: {
        if (DmenuService.isOpen) return WlrKeyboardFocus.Exclusive;
        if (tray.menuOpen) return WlrKeyboardFocus.OnDemand;

        return WlrKeyboardFocus.None;
      }

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: mainLayout.height

      RowLayout {
        id: mainLayout
        anchors.left: parent.left
        anchors.right: parent.right

        spacing: 0

        WorkspacesWidget {
          Layout.alignment: Qt.AlignLeft
          screen: modelData
        }
        ModeWidget {}
        DmenuWidget {}

        Item { Layout.fillWidth: true }

        TrayWidget { id: tray }
        MesaSeparator { visible: cpuWidget.visible }

        CpuWidget { id: cpuWidget }
        MesaSeparator { visible: cpuWidget.visible }

        RamWidget { id: ramWidget }
        MesaSeparator { visible: ramWidget.visible }

        BatteryWidget { id: batteryWidget }
        MesaSeparator { visible: batteryWidget.visible }

        NetworkWidget { id: networkWidget }
        MesaSeparator { visible: networkWidget.visible }

        ClockWidget {}
      }
    }
  }
}
