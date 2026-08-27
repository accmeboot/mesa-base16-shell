import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Wayland
import QtQuick.Layouts

import qs.Services

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      color: SettingsService.colors.base00

      WlrLayershell.keyboardFocus: MenuService.isOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

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

        ModeWidget {
          Layout.alignment: Qt.AlignLeft
        }

        DmenuWidget {
          Layout.alignment: Qt.AlignLeft
        }

        Item {
          Layout.fillWidth: true
        }

        PipewireOutputWidget {}

        PipewireInputWidget {}

        BatteryWidget {}

        NetworkWidget {}

        ClockWidget {
          Layout.alignment: Qt.AlignRight
        }
      }
    }
  }
}
