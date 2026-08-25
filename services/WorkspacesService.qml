pragma Singleton

import Quickshell
import Quickshell.I3
import Quickshell.Io

import ".."

Singleton {
  id: root

  readonly property bool persistent: Settings.workspaces.persistent
  readonly property int count: 10

  function getWorkspacesForMonitor(monitor: string): var {
    let existingWorkspaces = I3.workspaces.values
    .filter((ws) => ws.monitor?.name === monitor)
    .map((ws) => ({
      name: ws.name,
      focused: ws.focused,
      active: ws.active,
      monitor: ws.monitor.name,
      number: ws.number,
      urgent: ws.urgent,
      occupied: (ws.lastIpcObject.focus?.length ?? 0) > 0,
      activate: () => I3.dispatch(`workspace ${ws.name}`),
    }))

    if (persistent) {
      const takenWorkspaces = new Set(existingWorkspaces.map(ws => ws.number));

      for (let index = 1; index <= count; index++) {
        if (takenWorkspaces.has(index)) continue;

        existingWorkspaces.push({
          name: index,
          focused: false,
          active: false,
          monitor: monitor,
          number: index,
          urgent: false,
          occupied: false,
          activate: () => I3.dispatch(`workspace ${index}`),
        })
      }
    }

    return existingWorkspaces.sort((a, b) => a.number - b.number)
  }


  Process {
    running: true
    command: ["swaymsg", "-r", "-m", "-t", "subscribe", '["window"]']

    stdout: SplitParser {
      onRead: data => {
        const change = JSON.parse(data).change;

        if (["new", "close", "move", "floating"].includes(change))
          I3.refreshWorkspaces();
      }
    }
  }
}
