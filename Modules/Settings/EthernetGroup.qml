import QtQuick
import QtQuick.Layouts
import Quickshell.Networking

import qs.Services
import qs.Components

ColumnLayout {
  id: root

  readonly property var devices: Networking.devices.values.filter(device => device.type === DeviceType.Wired)
  Layout.fillWidth: true
  spacing: ConfigService.spacing.vertical

  component InfoRow: MesaText {
    Layout.fillWidth: true
    elide: Text.ElideRight
  }

  Repeater {
    model: root.devices

    Rectangle {
      id: card
      required property WiredDevice modelData
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
          text: card.modelData.name
          font.bold: true
        }

        RowLayout {
          Layout.fillWidth: true
          spacing: ConfigService.spacing.horizontal / 2

          InfoRow {
            Layout.alignment: Qt.AlignVCenter
            text: {
              if (!card.modelData.hasLink) return "No cable";

              switch (card.modelData.state) {
              case ConnectionState.Connected: return "Connected";
              case ConnectionState.Connecting: return "Connecting";
              case ConnectionState.Disconnecting: return "Disconnecting";
              case ConnectionState.Disconnected: return "Disconnected";
              default: return "Unknown";
              }
            }
            color: {
              const colors = ConfigService.colors;

              if (!card.modelData.hasLink) return colors.base03;

              switch (card.modelData.state) {
              case ConnectionState.Connecting:
              case ConnectionState.Disconnecting:
                return colors.base0A;
              default:
                return ColorService.status(card.modelData.connected);
              }
            }
          }

          MesaButton {
            id: connectButton
            readonly property Network network: card.modelData.network
            visible: card.modelData.connected || connectButton.network !== null
            enabled: !(connectButton.network && connectButton.network.stateChanging)
            text: card.modelData.connected ? "Disconnect" : "Connect"
            onClicked: {
              if (card.modelData.connected) card.modelData.disconnect();
              else connectButton.network.connect();
            }
          }
        }

        MesaText {
          visible: macAddress.visible
          text: "MAC"
          color: ConfigService.colors.base04
        }

        InfoRow {
          id: macAddress
          visible: card.modelData.address !== ""
          text: card.modelData.address
        }

        MesaText {
          visible: link.visible
          text: "Link"
          color: ConfigService.colors.base04
        }

        InfoRow {
          id: link
          visible: card.modelData.hasLink && card.modelData.linkSpeed > 0
          text: `${card.modelData.linkSpeed} Mbps`
        }

        MesaText {
          Layout.alignment: Qt.AlignVCenter
          Layout.topMargin: ConfigService.spacing.vertical
          text: "Autoconnect"
          color: ConfigService.colors.base04
        }

        MesaButton {
          Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
          Layout.topMargin: ConfigService.spacing.vertical
          text: card.modelData.autoconnect ? "on" : "off"
          contentColor: card.modelData.autoconnect ? ConfigService.colors.base0B : ConfigService.colors.base04
          onClicked: card.modelData.autoconnect = !card.modelData.autoconnect
        }
      }
    }
  }
}
