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


  Rectangle {
    id: rail

    Layout.fillWidth: true

    implicitHeight: tabs.implicitHeight
    color: ConfigService.colors.surface

    clip: true

    RowLayout {
      id: tabs

      spacing: 0

      Repeater {
        model: root.sections

        MesaButton {
          id: tab

          required property string modelData

          readonly property bool active: root.activeSection === tab.modelData

          text: modelData

          color: tab.active ? ConfigService.colors.highlight : ConfigService.colors.surface
          contentColor: tab.active ? ConfigService.colors.background : ConfigService.colors.foreground

          onClicked: root.activeSection = tab.modelData
        }
      }
    }
  }

  ScrollView {
    id: scroll

    Layout.fillWidth: true
    Layout.fillHeight: true

    clip: true
    padding: ConfigService.spacing
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
}
