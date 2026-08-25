# Quickshell Configuration

A minimal and customizable status bar configuration for [Quickshell](https://github.com/outfoxxed/quickshell), designed for i3/Sway window managers.

## Features

- **Workspace Widget** - Visual workspace indicators with:
  - Active workspace highlighting
  - Occupied workspace indicators
  - Urgent workspace notifications
  - Click-to-switch functionality
  - Support for persistent workspaces (1-10)
  
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

### Colors & Font

Edit `Settings.qml` or create a `settings.json` file in the same directory to customize:

```json
{
  "colors": {
    "base00": "#1d2021",
    "base01": "#3c3836",
    "base05": "#d5c4a1",
    ...
  },
  "font": {
    "name": "JetBrainsMono Nerd Font",
    "size": 12
  },
  "workspaces": {
    "persistent": true
  }
}
```

The settings file supports hot-reloading, so changes will be applied automatically.

### Persistent Workspaces

By default, workspaces 1-10 are always visible. To show only active workspaces:

```json
{
  "workspaces": {
    "persistent": false
  }
}
```

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

The default Gruvbox Dark palette includes:

- `base00-03`: Background shades (darkest to dark)
- `base04-07`: Foreground shades (light to lightest)
- `base08`: Red (urgent notifications)
- `base09`: Orange
- `base0A`: Yellow
- `base0B`: Green
- `base0C`: Cyan
- `base0D`: Blue
- `base0E`: Purple
- `base0F`: Brown

## License

This configuration is provided as-is for personal use and modification.

## Contributing

Feel free to fork and customize this configuration to suit your needs!
