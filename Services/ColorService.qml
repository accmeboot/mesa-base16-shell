pragma Singleton

import QtQuick
import Quickshell

import qs.Services

Singleton {
  function threshold(value: real, warning: real, critical: real): color {
    const colors = ConfigService.colors;

    if (critical >= warning) {
      if (value > critical) return colors.base08;
      if (value > warning) return colors.base0A;
    } else {
      if (value < critical) return colors.base08;
      if (value < warning) return colors.base0A;
    }

    return colors.base0B;
  }

  function status(ok: bool): color {
    return ok ? ConfigService.colors.base0B : ConfigService.colors.base08;
  }
}
