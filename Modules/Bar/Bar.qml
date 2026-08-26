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

      WlrLayershell.keyboardFocus: DmenuService.isOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

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

        DmenuButtonWidget {
          Layout.alignment: Qt.AlignLeft
        }

        DmenuWidget {
          id: dmenuWidget
          Layout.fillWidth: true
        }

        SeparatorWidget {
          visible: dmenuWidget.visible
        }

        Item {
          Layout.fillWidth: true
        }

        NetworkWidget {}

        BatteryWidget {}

        ClockWidget {
          Layout.alignment: Qt.AlignRight
        }
      }
    }
  }
}
