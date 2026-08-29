import Quickshell
import QtQuick
import QtQuick.Layouts

import Quickshell.Wayland

import qs.Services
import qs.Components

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData

      screen: modelData

      color: "transparent"

      WlrLayershell.layer: WlrLayer.Top

      property int count: NotificationsService.activeList.count ?? 0

      visible: Boolean(count)

      implicitWidth: notificationsColumn.implicitWidth
      implicitHeight: notificationsColumn.implicitHeight

      anchors {
        top: true
        right: true
      }

      margins {
        top: SettingsService.spacing.vertical
        right: SettingsService.spacing.vertical
      }

      ColumnLayout {
        id: notificationsColumn

        Repeater {
          model: NotificationsService.activeList

          Notification {}
        }
      }
    }
  }
}
