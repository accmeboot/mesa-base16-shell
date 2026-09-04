pragma Singleton

import QtQuick
import Quickshell

import qs.Services

Singleton {
  function threshold(value: real, warning: real, critical: real): color {
    const colors = ConfigService.colors;

    if (critical >= warning) {
      if (value > critical) return colors.critical;
      if (value > warning) return colors.attention;
    } else {
      if (value < critical) return colors.critical;
      if (value < warning) return colors.attention;
    }

    return colors.ok;
  }

  function status(ok: bool): color {
    return ok ? ConfigService.colors.ok : ConfigService.colors.critical;
  }
}
