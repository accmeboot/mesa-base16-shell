import Quickshell
import QtQuick
import QtQuick.Layouts

import Quickshell.Services.Notifications

import qs.Services
import qs.Components

Rectangle {
  required property var modelData
  readonly property int padding: SettingsService.spacing.vertical
  readonly property int inset: root.border.width + root.padding

  id: root

  implicitWidth: 400
  implicitHeight: notificationMainRow.implicitHeight + 2 * root.inset

  clip: true

  color: SettingsService.colors.base00

  border.color: SettingsService.colors.base02
  border.width: 2

  Rectangle {
    id: closeButton

    anchors.top: parent.top
    anchors.left: parent.left

    z: 1

    implicitWidth: closeText.implicitWidth + root.padding * 2
    implicitHeight: closeText.implicitHeight

    color: SettingsService.colors.base08

    MesaText {
      id: closeText
      anchors.centerIn: parent
      text: "X"
      color: SettingsService.colors.base00
    }

    MouseArea {
      id: closeMouseArea
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      hoverEnabled: true

      onClicked: {
        NotificationsService.dismissOrExpireNotification(modelData.id);
      }
    }
  }

  RowLayout {
    id: notificationMainRow

    anchors.fill: parent
    anchors.margins: root.inset

    spacing: root.padding

    NotificationIcon {
      id: notificationIcon

      Layout.alignment: Qt.AlignVCenter
    }

    ColumnLayout {
      id: notificationMainColumn

      Layout.fillWidth: true
      Layout.alignment: Qt.AlignVCenter

      spacing: SettingsService.spacing.vertical / 2

      RowLayout {
        id: notificationHeader

        Layout.fillWidth: true

        spacing: SettingsService.spacing.horizontal

        MesaText {
          Layout.fillWidth: true
          Layout.maximumWidth: Math.ceil(implicitWidth)

          text: modelData.appName
          color: {
            switch (modelData.urgency) {
              case NotificationUrgency.Critical:
              return SettingsService.colors.base08;
              case NotificationUrgency.Normal:
              return SettingsService.colors.base05;
              default:
              return SettingsService.colors.base05;
            }
          }
          font.bold: true
          textFormat: Text.StyledText
          elide: Text.ElideRight
          maximumLineCount: 1
        }
        Item {
          Layout.fillWidth: true
        }
        MesaText {
          id: notificationTime
          text: getTime(modelData.timestamp)
        }
      }

      MesaText {
        Layout.fillWidth: true

        text: modelData.title
        font.bold: true
        elide: Text.ElideRight
        maximumLineCount: 1
      }
      MesaText {
        Layout.fillWidth: true

        text: modelData.body
        wrapMode: Text.Wrap
        maximumLineCount: 2
        elide: Text.ElideRight
        textFormat: Text.StyledText
      }


      Flow {
        id: actionsFlow

        Layout.fillWidth: true
        Layout.topMargin: SettingsService.spacing.vertical

        spacing: SettingsService.spacing.vertical

        visible: Boolean(modelData.actions.count)

        Repeater {
          model: modelData.actions

          Rectangle {
            id: action

            required property var modelData

            color: SettingsService.colors.base0D

            implicitWidth: actionText.width + SettingsService.spacing.horizontal
            implicitHeight: actionText.implicitHeight + SettingsService.spacing.vertical

            MesaText {
              id: actionText

              anchors.centerIn: parent

              width: Math.min(implicitWidth, actionsFlow.width - SettingsService.spacing.horizontal)

              color: SettingsService.colors.base00
              text: action.modelData.text
              elide: Text.ElideRight
              textFormat: Text.StyledText
            }

            MouseArea {
              anchors.fill: parent
              cursorShape: Qt.PointingHandCursor
              hoverEnabled: true

              onClicked: {
                NotificationsService.invokeAction(root.modelData.id, action.modelData.id);
              }
            }
          }
        }
      }
    }
  }


  function getTime(timestamp) {
    var date = new Date(timestamp);
    var hours = String(date.getHours()).padStart(2, '0');
    var minutes = String(date.getMinutes()).padStart(2, '0');

    return hours + ":" + minutes;
  }
}
