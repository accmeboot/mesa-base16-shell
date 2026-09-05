import QtQuick

import qs.Services

MesaIcon {
  id: root

  property bool checked: false
  property bool radio: false

  name: {
    if (root.radio) return root.checked ? "radio-button" : "radio-button-off";
    return root.checked ? "checkbox-on" : "checkbox-off";
  }
  size: Math.round(ConfigService.font.size * (root.radio ? 1.35 : 1.5))
}
