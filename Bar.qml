import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      color: Settings.colors.base00

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

        WorkspacesWidget {
          Layout.alignment: Qt.AlignLeft
          screen: modelData
        }

        ModeWidget {
          Layout.alignment: Qt.AlignLeft
        }

        Item {
          Layout.fillWidth: true
        }

        ClockWidget {
          Layout.alignment: Qt.AlignRight
        }
      }
    }
  }
}
