import QtQuick.Layouts

import qs.Services
import qs.Components
import qs.Modules.Settings.Common

ColumnLayout {
  id: root

  spacing: ConfigService.spacing.vertical * 3

  SettingsGroup {
    title: "Adapter"
    emptyText: "No bluetooth adapters"
    empty: adapters.count === 0

    BluetoothAdapterGroup {
      id: adapters
    }
  }

  SettingsGroup {
    title: "Devices"
    emptyText: devices.scanning ? "Searching" : "No devices"
    empty: devices.count === 0

    headerContent: MesaText {
      visible: devices.scanning
      text: "Scanning"
      color: ConfigService.colors.base0A
    }

    BluetoothDeviceGroup {
      id: devices
    }
  }
}
