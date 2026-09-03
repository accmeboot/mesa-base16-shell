import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Networking

import qs.Services
import qs.Components

ListView {
  id: root

  readonly property WifiDevice device: Networking.devices.values.find(device => device.type === DeviceType.Wifi) || null
  property WifiNetwork selectedNetwork: null
  property WifiNetwork promptedNetwork: null
  property string password: ""
  Layout.fillWidth: true
  Layout.fillHeight: true
  clip: true
  model: root.device ? root.device.networks.values : []
  boundsBehavior: Flickable.StopAtBounds
  spacing: 0

  ScrollBar.vertical: ScrollBar {}

  onSelectedNetworkChanged: {
    if (root.selectedNetwork !== root.promptedNetwork) root.promptedNetwork = null;
  }

  onPromptedNetworkChanged: root.password = ""

  Binding {
    target: root.device
    property: "scannerEnabled"
    value: root.visible
  }

  delegate: Rectangle {
    id: card
    required property WifiNetwork modelData
    property string error: ""
    readonly property bool selected: root.selectedNetwork === card.modelData
    readonly property bool prompting: root.promptedNetwork === card.modelData

    onSelectedChanged: {
      if (!card.selected) card.error = "";
    }
    readonly property bool needsPassword: !card.modelData.known && card.modelData.security !== WifiSecurityType.Open && card.modelData.security !== WifiSecurityType.Owe

    function activate(): void {
      const network = card.modelData;

      card.error = "";

      if (network.connected) {
        network.disconnect();
        return;
      }

      if (card.prompting) {
        network.connectWithPsk(root.password);
        return;
      }

      if (card.needsPassword) {
        root.promptedNetwork = network;
        return;
      }

      network.connect();
    }

    Connections {
      target: card.modelData

      function onConnectionFailed(reason: int): void {
        switch (reason) {
        case ConnectionFailReason.NoSecrets:
          card.error = "Wrong password";
          break;
        case ConnectionFailReason.WifiAuthTimeout:
          card.error = "Authentication timed out";
          break;
        case ConnectionFailReason.WifiNetworkLost:
          card.error = "Network lost";
          break;
        case ConnectionFailReason.WifiClientDisconnected:
          card.error = "Disconnected";
          break;
        default:
          card.error = "Connection failed";
        }

        if (!card.needsPassword) return;

        root.selectedNetwork = card.modelData;
        root.promptedNetwork = card.modelData;
      }

      function onConnectedChanged(): void {
        if (!card.modelData.connected) return;

        card.error = "";
        if (card.prompting) root.promptedNetwork = null;
      }
    }

    width: ListView.view.width
    implicitHeight: content.implicitHeight + ConfigService.spacing.vertical * 2
    color: ConfigService.colors.base01

    ColumnLayout {
      id: content
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      anchors.leftMargin: ConfigService.spacing.horizontal / 2
      anchors.rightMargin: ConfigService.spacing.horizontal / 2
      spacing: ConfigService.spacing.vertical

      Item {
        Layout.fillWidth: true
        implicitHeight: header.implicitHeight

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: root.selectedNetwork = card.selected ? null : card.modelData
        }

        RowLayout {
          id: header
          anchors.fill: parent
          spacing: ConfigService.spacing.horizontal / 2

          MesaText {
            id: ssid
            Layout.fillWidth: true
            Layout.maximumWidth: Math.ceil(ssid.implicitWidth)
            text: card.modelData.name
            elide: Text.ElideRight
          }

          MesaIcon {
            Layout.alignment: Qt.AlignVCenter
            visible: card.modelData.connected
            name: "dot"
            color: ConfigService.colors.base0B
          }

          Item {
            Layout.fillWidth: true
          }

          MesaIcon {
            Layout.alignment: Qt.AlignVCenter
            name: card.modelData.security === WifiSecurityType.Open || card.modelData.security === WifiSecurityType.Owe ? "lock-open" : "lock"
          }
        }
      }

      RowLayout {
        Layout.fillWidth: true
        visible: card.selected
        spacing: ConfigService.spacing.horizontal / 2

        MesaInput {
          id: passwordInput
          Layout.fillWidth: true
          visible: card.prompting
          echoMode: TextInput.Password
          placeholderText: "Password"
          text: root.password
          onTextEdited: root.password = passwordInput.text
          onAccepted: card.activate()
          Keys.onEscapePressed: root.promptedNetwork = null
          onVisibleChanged: if (passwordInput.visible) passwordInput.restoreFocus()
          Component.onCompleted: Qt.callLater(passwordInput.restoreFocus)

          function restoreFocus(): void {
            if (!passwordInput.visible) return;

            passwordInput.forceActiveFocus();
            passwordInput.cursorPosition = passwordInput.text.length;
          }
        }

        MesaButton {
          Layout.alignment: Qt.AlignVCenter
          enabled: !card.modelData.stateChanging
          text: {
            const network = card.modelData;

            switch (network.state) {
            case ConnectionState.Connecting: return "Connecting";
            case ConnectionState.Disconnecting: return "Disconnecting";
            default: return network.connected ? "Disconnect" : "Connect";
            }
          }
          onClicked: card.activate()
        }

        MesaButton {
          Layout.alignment: Qt.AlignVCenter
          visible: card.modelData.known && !card.prompting
          text: "Forget"
          onClicked: card.modelData.forget()
        }

        MesaButton {
          Layout.alignment: Qt.AlignVCenter
          visible: card.prompting
          text: "Cancel"
          onClicked: root.promptedNetwork = null
        }
      }

      MesaText {
        Layout.fillWidth: true
        visible: card.error !== ""
        text: card.error
        color: ConfigService.colors.base08
        elide: Text.ElideRight
      }
    }
  }
}
