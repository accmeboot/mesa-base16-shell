import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth

import qs.Services
import qs.Components
import qs.Modules.Settings.Common

ColumnLayout {
  id: root

  readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
  readonly property var devices: Bluetooth.devices.values
  readonly property var paired: root.devices.filter(device => device.paired).sort((a, b) => {
    if (a.connected !== b.connected) return a.connected ? -1 : 1;

    return a.name.localeCompare(b.name);
  })
  readonly property var available: root.devices.filter(device => !device.paired && device.deviceName !== "")
  readonly property var listed: root.scanning ? root.paired.concat(root.available) : root.paired
  readonly property bool scanning: root.adapter !== null && root.adapter.discovering
  readonly property alias count: repeater.count

  property BluetoothDevice selectedDevice: null
  property BluetoothDevice pairingDevice: null

  Layout.fillWidth: true

  spacing: 0

  Component.onDestruction: if (root.adapter) root.adapter.discovering = false

  Binding {
    target: root.adapter
    property: "discovering"
    value: root.adapter?.enabled ?? false
  }

  BluetoothAgent {
    id: pairingAgent
  }

  Connections {
    target: root.pairingDevice

    function onPairedChanged(): void {
      const device = root.pairingDevice;

      if (!device || !device.paired) return;

      device.trusted = true;
      root.pairingDevice = null;
    }
  }

  Repeater {
    id: repeater

    model: root.listed

    SettingsCard {
      id: card

      required property BluetoothDevice modelData

      readonly property bool selected: root.selectedDevice === card.modelData

      RowLayout {
        Layout.fillWidth: true

        spacing: ConfigService.spacing.horizontal / 2

        HoverHandler {
          cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
          onTapped: root.selectedDevice = card.selected ? null : card.modelData
        }

        MesaIcon {
          Layout.alignment: Qt.AlignVCenter

          visible: card.modelData.connected
          name: "dot"
          color: ConfigService.colors.base0B
          size: ConfigService.font.size * 0.5
        }

        InfoValue {
          text: card.modelData.name
        }

        MesaText {
          Layout.alignment: Qt.AlignVCenter

          visible: card.modelData.connected && card.modelData.batteryAvailable
          text: `${Math.round(card.modelData.battery * 100)}%`
          color: ColorService.threshold(card.modelData.battery * 100, 30, 15)
        }

        MesaText {
          Layout.alignment: Qt.AlignVCenter

          text: {
            if (card.modelData.pairing) return "Pairing";
            if (!card.modelData.paired) return "Not paired";

            switch (card.modelData.state) {
            case BluetoothDeviceState.Connected: return "Connected";
            case BluetoothDeviceState.Connecting: return "Connecting";
            case BluetoothDeviceState.Disconnecting: return "Disconnecting";
            default: return "Disconnected";
            }
          }
          color: {
            const colors = ConfigService.colors;

            if (card.modelData.pairing) return colors.base0A;
            if (!card.modelData.paired) return colors.base03;

            switch (card.modelData.state) {
            case BluetoothDeviceState.Connected: return colors.base0B;
            case BluetoothDeviceState.Connecting:
            case BluetoothDeviceState.Disconnecting:
              return colors.base0A;
            default: return colors.base03;
            }
          }
        }
      }

      InfoGrid {
        visible: card.selected

        InfoLabel {
          text: "Address"
        }

        InfoValue {
          text: card.modelData.address
        }

        InfoLabel {
          visible: card.modelData.paired

          text: "Connect automatically"
        }

        MesaButton {
          Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

          visible: card.modelData.paired
          text: card.modelData.trusted ? "on" : "off"
          contentColor: card.modelData.trusted ? ConfigService.colors.base0B : ConfigService.colors.base04

          onClicked: card.modelData.trusted = !card.modelData.trusted
        }

        InfoLabel {
          visible: card.modelData.paired

          text: "Wake from sleep"
        }

        MesaButton {
          Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

          visible: card.modelData.paired
          text: card.modelData.wakeAllowed ? "on" : "off"
          contentColor: card.modelData.wakeAllowed ? ConfigService.colors.base0B : ConfigService.colors.base04

          onClicked: card.modelData.wakeAllowed = !card.modelData.wakeAllowed
        }
      }

      RowLayout {
        Layout.fillWidth: true

        visible: card.selected
        spacing: ConfigService.spacing.horizontal / 2

        MesaButton {
          Layout.alignment: Qt.AlignVCenter

          visible: card.modelData.paired
          enabled: card.modelData.state === BluetoothDeviceState.Connected || card.modelData.state === BluetoothDeviceState.Disconnected
          text: card.modelData.connected ? "Disconnect" : "Connect"

          onClicked: {
            if (card.modelData.connected) card.modelData.disconnect();
            else card.modelData.connect();
          }
        }

        MesaButton {
          Layout.alignment: Qt.AlignVCenter

          visible: card.modelData.paired
          text: "Forget"

          onClicked: {
            if (card.selected) root.selectedDevice = null;
            card.modelData.forget();
          }
        }

        MesaButton {
          Layout.alignment: Qt.AlignVCenter

          visible: !card.modelData.paired
          enabled: pairingAgent.registered
          text: card.modelData.pairing ? "Cancel" : "Pair"
          contentColor: {
            const colors = ConfigService.colors;

            if (!pairingAgent.registered) return colors.base03;
            return card.modelData.pairing ? colors.base0A : colors.base05;
          }

          onClicked: {
            if (card.modelData.pairing) {
              card.modelData.cancelPair();
              root.pairingDevice = null;
              return;
            }

            root.pairingDevice = card.modelData;
            card.modelData.pair();
          }
        }
      }
    }
  }
}
