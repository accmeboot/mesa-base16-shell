import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.Services
import qs.Components
import qs.Modules.Settings.Audio
import qs.Modules.Settings.Network
import qs.Modules.Settings.Bluetooth
import qs.Modules.Settings.About

ColumnLayout {
  id: root

  readonly property var sections: ["Audio", "Network", "Bluetooth", "About"]

  property string activeSection: root.sections[0]

  spacing: 0

  Component {
    id: audio

    AudioSection {}
  }

  Component {
    id: network

    NetworkSection {}
  }

  Component {
    id: bluetooth

    BluetoothSection {}
  }

  Component {
    id: about

    AboutSection {}
  }

  ScrollView {
    id: scroll

    Layout.fillWidth: true
    Layout.fillHeight: true

    clip: true
    padding: ConfigService.spacing.horizontal / 2
    contentWidth: scroll.availableWidth
    contentHeight: section.implicitHeight

    Loader {
      id: section

      width: scroll.availableWidth

      sourceComponent: {
        switch (root.activeSection) {
        case "Network": return network;
        case "Bluetooth": return bluetooth;
        case "About": return about;
        default: return audio;
        }
      }

      onLoaded: scroll.contentItem.contentY = 0
    }
  }

  Rectangle {
    Layout.fillWidth: true

    implicitHeight: tabs.implicitHeight
    color: ConfigService.colors.base01

    RowLayout {
      id: tabs

      anchors.centerIn: parent

      spacing: 0

      Repeater {
        model: root.sections

        Rectangle {
          id: tab

          required property string modelData

          readonly property bool active: root.activeSection === tab.modelData

          implicitWidth: label.implicitWidth + ConfigService.spacing.horizontal
          implicitHeight: label.implicitHeight + ConfigService.spacing.vertical

          color: tab.active ? ConfigService.colors.base0D : "transparent"

          MesaText {
            id: label

            anchors.centerIn: parent

            text: tab.modelData
            color: tab.active ? ConfigService.colors.base00 : ConfigService.colors.base05
          }

          MouseArea {
            anchors.fill: parent

            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: root.activeSection = tab.modelData
          }
        }
      }
    }
  }
}
