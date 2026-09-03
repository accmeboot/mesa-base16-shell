import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth

import qs.Services
import qs.Components

ColumnLayout {
  id: root

  readonly property var adapters: Bluetooth.adapters.values
  Layout.fillWidth: true
  spacing: ConfigService.spacing.vertical

  component InfoRow: MesaText {
    Layout.fillWidth: true
    elide: Text.ElideRight
  }

  component ToggleRow: RowLayout {
    id: toggle
    property bool active: false
    property bool available: true
    property int timeout: 0
    signal toggled

    Layout.fillWidth: true
    spacing: ConfigService.spacing.horizontal / 2

    MesaButton {
      Layout.alignment: Qt.AlignVCenter
      enabled: toggle.available
      text: toggle.active ? "on" : "off"
      contentColor: {
        const colors = ConfigService.colors;

        if (!toggle.available) return colors.base03;
        return toggle.active ? colors.base0B : colors.base04;
      }
      onClicked: toggle.toggled()
    }

    InfoRow {
      Layout.alignment: Qt.AlignVCenter
      visible: toggle.active && toggle.timeout > 0
      text: `resets after ${root.formatTimeout(toggle.timeout)}`
      color: ConfigService.colors.base03
    }
  }

  function formatTimeout(seconds: int): string {
    if (seconds === 0) return "never";
    if (seconds % 60 === 0) return `${seconds / 60} min`;

    return `${seconds}s`;
  }

  Repeater {
    model: root.adapters

    Rectangle {
      id: card
      required property BluetoothAdapter modelData
      readonly property bool busy: card.modelData.state === BluetoothAdapterState.Enabling || card.modelData.state === BluetoothAdapterState.Disabling
      readonly property bool blocked: card.modelData.state === BluetoothAdapterState.Blocked

      Layout.fillWidth: true
      implicitHeight: content.implicitHeight + ConfigService.spacing.vertical * 2
      color: ConfigService.colors.base01

      GridLayout {
        id: content
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: ConfigService.spacing.horizontal / 2
        anchors.rightMargin: ConfigService.spacing.horizontal / 2
        columns: 2
        columnSpacing: ConfigService.spacing.horizontal
        rowSpacing: ConfigService.spacing.vertical / 2

        MesaText {
          Layout.alignment: Qt.AlignVCenter
          text: card.modelData.name || card.modelData.adapterId
          font.bold: true
        }

        RowLayout {
          Layout.fillWidth: true
          spacing: ConfigService.spacing.horizontal / 2

          InfoRow {
            Layout.alignment: Qt.AlignVCenter
            text: {
              switch (card.modelData.state) {
              case BluetoothAdapterState.Enabled: return "Enabled";
              case BluetoothAdapterState.Disabled: return "Disabled";
              case BluetoothAdapterState.Enabling: return "Enabling";
              case BluetoothAdapterState.Disabling: return "Disabling";
              case BluetoothAdapterState.Blocked: return "Blocked by rfkill";
              default: return "Unknown";
              }
            }
            color: {
              const colors = ConfigService.colors;

              switch (card.modelData.state) {
              case BluetoothAdapterState.Enabled: return colors.base0B;
              case BluetoothAdapterState.Enabling:
              case BluetoothAdapterState.Disabling:
                return colors.base0A;
              case BluetoothAdapterState.Blocked: return colors.base08;
              default: return colors.base03;
              }
            }
          }

          MesaButton {
            Layout.alignment: Qt.AlignVCenter
            enabled: !card.busy && !card.blocked
            text: card.modelData.enabled ? "Turn off" : "Turn on"
            contentColor: card.busy || card.blocked ? ConfigService.colors.base03 : ConfigService.colors.base05
            onClicked: card.modelData.enabled = !card.modelData.enabled
          }
        }

        MesaText {
          text: "Adapter"
          color: ConfigService.colors.base04
        }

        InfoRow {
          text: card.modelData.adapterId
        }

        MesaText {
          Layout.alignment: Qt.AlignVCenter
          Layout.topMargin: ConfigService.spacing.vertical
          text: "Discoverable"
          color: ConfigService.colors.base04
        }

        ToggleRow {
          Layout.topMargin: ConfigService.spacing.vertical
          active: card.modelData.discoverable
          available: card.modelData.enabled
          timeout: card.modelData.discoverableTimeout
          onToggled: card.modelData.discoverable = !card.modelData.discoverable
        }

        MesaText {
          Layout.alignment: Qt.AlignVCenter
          text: "Pairable"
          color: ConfigService.colors.base04
        }

        ToggleRow {
          active: card.modelData.pairable
          available: card.modelData.enabled
          timeout: card.modelData.pairableTimeout
          onToggled: card.modelData.pairable = !card.modelData.pairable
        }
      }
    }
  }
}
