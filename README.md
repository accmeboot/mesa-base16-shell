# Quickshell Configuration

A minimal and customizable status bar configuration for [Quickshell](https://github.com/outfoxxed/quickshell), designed for i3/Sway window managers.

## Features

- **Workspace Widget** - Visual workspace indicators with:
  - Active workspace highlighting

  - Urgent workspace notifications
  - Click-to-switch functionality
  
- **Clock Widget** - Simple date and time display with minute precision

- **Gruvbox Theme** - Default color scheme based on Gruvbox Dark with full customization support

- **Multi-Monitor Support** - Automatically creates bars on all connected displays

- **Dynamic Updates** - Automatically refreshes workspace states when windows are opened, closed, or moved

## Requirements

- [Quickshell](https://github.com/outfoxxed/quickshell)
- Sway or i3 window manager
- `swaymsg` (for workspace monitoring)

## Installation

1. Clone or copy this repository to `~/.config/quickshell/`:
   ```bash
   git clone <repository-url> ~/.config/quickshell
   ```

2. Start Quickshell:
   ```bash
   quickshell
   ```

## Configuration

### Colors, Font & Spacing

Copy `config.example.json` to `config.json` in the same directory to customize:

```json
{
  "colors": {
    "background": "#1d2021",
    "surface": "#3c3836",
    "on_surface": "#504945",
    "foreground": "#d5c4a1",
    "highlight": "#83a598",
    "attention": "#fabd2f",
    "ok": "#b8bb26",
    "critical": "#fb4934"
  },
  "font": {
    "name": "JetBrainsMono Nerd Font",
    "size": 12
  },
  "spacing": 10
}
```

`spacing` is a single base unit in pixels; widgets derive their padding and gaps
from it (`spacing`, `spacing / 2`, `spacing * 2`, ...).

The config file supports hot-reloading, so changes will be applied automatically.

## File Structure

```
.
├── shell.qml                    # Entry point
├── Bar.qml                      # Main bar component
├── Settings.qml                 # Configuration singleton
├── MesaText.qml                 # Styled text component
├── ClockWidget.qml              # Clock/date display
├── WorkspacesWidget.qml         # Workspace indicator
└── services/
    └── WorkspacesService.qml    # Workspace state management
```

## Customization

### Adding Widgets

Edit `Bar.qml` and add components to the `RowLayout`:

```qml
RowLayout {
  WorkspacesWidget {
    Layout.alignment: Qt.AlignLeft
  }
  
  // Add your widget here
  
  ClockWidget {
    Layout.alignment: Qt.AlignRight
  }
}
```

### Changing Bar Position

Modify the `anchors` in `Bar.qml`:

```qml
anchors {
  bottom: true  // Change from top to bottom
  left: true
  right: true
}
```

## Color Scheme

The palette is eight semantic colors, defaulting to Gruvbox Dark:

- `background`: Window and widget background
- `surface`: Raised surfaces - cards, menus, separators
- `on_surface`: Borders, button fills, muted and disabled text
- `foreground`: Primary text
- `highlight`: Accent - focused workspace, active tab, selection
- `ok`: Healthy state - connected, paired, enabled, normal thresholds
- `attention`: Transitional or warning state - connecting, pairing, scanning
- `critical`: Failure or urgent state - disconnected, errors, urgent notifications

## License

This configuration is provided as-is for personal use and modification.

## Contributing

Feel free to fork and customize this configuration to suit your needs!
