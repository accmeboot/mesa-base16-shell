import QtQuick
import Quickshell
import QtQuick.Layouts

import qs.Services

Rectangle {
  implicitWidth: 2
  Layout.fillHeight: true

  Layout.leftMargin: SettingsService.spacing.horizontal / 2
  Layout.rightMargin: SettingsService.spacing.horizontal / 2

  color: SettingsService.colors.base01
}
