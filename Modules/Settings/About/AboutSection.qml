import QtQuick.Layouts

import qs.Services
import qs.Modules.Settings.Common

ColumnLayout {
  id: root

  spacing: ConfigService.spacing * 3

  SettingsGroup {
    title: "System"

    SystemGroup {}
  }

  SettingsGroup {
    title: "Battery"
    visible: battery.available

    BatteryGroup {
      id: battery
    }
  }
}
