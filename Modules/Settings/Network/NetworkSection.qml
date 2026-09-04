import QtQuick.Layouts

import qs.Services
import qs.Modules.Settings.Common

ColumnLayout {
  id: root

  spacing: ConfigService.spacing.vertical * 3

  SettingsGroup {
    title: "Ethernet"
    emptyText: "No wired devices"
    empty: ethernet.count === 0

    EthernetGroup {
      id: ethernet
    }
  }

  SettingsGroup {
    title: "Wifi"
    emptyText: "No networks"
    empty: wifi.count === 0

    WifiGroup {
      id: wifi
    }
  }
}
