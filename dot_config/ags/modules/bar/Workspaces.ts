import { throttle } from "lib/utils"
import options from "options"

const hyprland = await Service.import("hyprland")

const {
  workspaces,
  reverse_scroll,
  monitorSpecific,
  spacing,
  icons,
  show_icons,
  show_numbered,
  numbered_active_indicator,
  scroll_speed,
} = options.car.workspaces

type WorkspaceRule = {
  workspaceString: string
  monitor: string
}

type WorkspaceMap = {
  [key: string]: number[]
}

function range(length: number, start = 1) {
  return Array.from({ length }, (_, i) => i + start)
}

export const Workspaces = (monitor: number = -1, ws: number = 8) => {
  const getWorkspacesForMonitor = (curWs: number, wsRules: WorkspaceMap) => {
    if (!wsRules || !Object.keys(wsRules).length) {
      return true
    }

    const monitorMap = {}
    hyprland.monitors.forEach((m) => {
      monitorMap[m.id] = m.name
    })

    const currentMonitorName = monitorMap[monitor]
    return wsRules[currentMonitorName].includes(curWs)
  }

  const getWorkspaceRules = (): WorkspaceMap => {
    try {
      const rules = Utils.exec("hyprctl workspacerules -j")
      const workspaceRules = {}

      JSON.parse(rules).forEach((rule: WorkspaceRule, index: number) => {
        if (Object.hasOwnProperty.call(workspaceRules, rule.monitor)) {
          workspaceRules[rule.monitor].push(index + 1)
        } else {
          workspaceRules[rule.monitor] = [index + 1]
        }
      })

      return workspaceRules
    } catch (e) {
      console.error(e)
      return {}
    }
  }

  const getCurrentMonitorWorkspaces = () => {
    if (hyprland.monitors.length === 1) {
      return range(workspaces.value)
    }

    const monitorWorkspaceRules = getWorkspaceRules()
    const monitorMap = {}
    hyprland.monitors.forEach((m) => (monitorMap[m.id] = m.name))

    return monitorWorkspaceRules[monitorMap[monitor]]
  }

  const currentMonitorWorkspaces = Variable(getCurrentMonitorWorkspaces())

  workspaces.connect("changed", () => {
    currentMonitorWorkspaces.value = getCurrentMonitorWorkspaces()
  })

  const goToNextWS = () => {
    const curWorkspace = hyprland.active.workspace.id
    const indexOfWs = currentMonitorWorkspaces.value.indexOf(curWorkspace)

    let nextIndex = indexOfWs + 1
    if (nextIndex >= currentMonitorWorkspaces.value.length) {
      nextIndex = 0
    }

    hyprland.messageAsync(
      `dispatch workspace ${currentMonitorWorkspaces.value[nextIndex]}`,
    )
  }

  const goToPrevWS = () => {
    const curWorkspace = hyprland.active.workspace.id
    const indexOfWs = currentMonitorWorkspaces.value.indexOf(curWorkspace)

    let prevIndex = indexOfWs - 1
    if (prevIndex < 0) {
      prevIndex = currentMonitorWorkspaces.value.length - 1
    }

    hyprland.messageAsync(
      `dispatch workspace ${currentMonitorWorkspaces.value[prevIndex]}`,
    )
  }

  const createThrottledScrollHandlers = (scrollSpeed: number) => {
    const throttledScrollUp = throttle(() => {
      if (reverse_scroll.value) {
        goToPrevWS()
      } else {
        goToNextWS()
      }
    }, 200 / scrollSpeed)

    const throttledScrollDown = throttle(() => {
      if (reverse_scroll.value) {
        goToNextWS()
      } else {
        goToPrevWS()
      }
    }, 200 / scrollSpeed)

    return { throttledScrollUp, throttledScrollDown }
  }

  return {
    component: Widget.Box({
      class_name: "workspaces",
      children: Utils.merge(
        [workspaces.bind(), monitorSpecific.bind()],
        (workspaces, monitorSpecific) => {
          return range(workspaces || 8)
            .filter((i) => {
              if (!monitorSpecific) {
                return true
              }
              const workspaceRules = getWorkspaceRules()
              return getWorkspacesForMonitor(i, workspaceRules)
            })
            .map((i) => {
              return Widget.Button({
                class_name: "workspace-button",
                on_primary_click: () => {
                  hyprland.messageAsync(`dispatch workspace ${i}`)
                },
                child: Widget.Label({
                  attribute: i,
                  vpack: "center",
                  css: spacing
                    .bind("value")
                    .as((sp) => `margin: 0rem ${0.375 * sp}rem;`),
                  class_name: Utils.merge(
                    [
                      show_icons.bind("value"),
                      show_numbered.bind("value"),
                      numbered_active_indicator.bind("value"),
                      // icons.available.bind("value"),
                      // icons.active.bind("value"),
                      // icons.occupied.bind("value"),
                      // hyprland.active.workspace.bind("id")
                    ],
                    (showIcons, showNumbered, numberedActiveIndicator) => {
                      if (showIcons) {
                        return "workspace-icon"
                      }
                      if (showNumbered) {
                        const numActiveInd =
                          hyprland.active.workspace.id === i
                            ? numberedActiveIndicator
                            : ""

                        return `workspace-number ${numActiveInd}`
                      }
                      return ""
                    },
                  ),
                  label: Utils.merge(
                    [
                      show_icons.bind("value"),
                      icons.available.bind("value"),
                      icons.active.bind("value"),
                      icons.occupied.bind("value"),
                    ],
                    (showIcons, available, active, occupied) => {
                      if (showIcons) {
                        if (hyprland.active.workspace.id === i) {
                          return active
                        }
                        if ((hyprland.getWorkspace(i)?.windows || 0) > 0) {
                          return occupied
                        }
                        if (monitor !== -1) {
                          return available
                        }
                      }
                      return `${i}`
                    },
                  ),
                  setup: (self) => {
                    self.hook(hyprland, () => {
                      self.toggleClassName(
                        "active",
                        hyprland.active.workspace.id === i,
                      )
                      self.toggleClassName(
                        "occupied",
                        (hyprland.getWorkspace(i)?.windows || 0) > 0,
                      )
                    })
                  },
                }),
              })
            })
        },
      ),
      setup: (self) => {
        if (ws === 0) {
          self.hook(hyprland.active.workspace, () => {
            self.children.map((btn) => {
              btn.visible = hyprland.workspaces.some(
                (ws) => ws.id === btn.attribute,
              )
            })
          })
        }
      },
    }),
    isVisible: true,
    boxClass: "workspaces",
    props: {
      setup: (self: any) => {
        self.hook(scroll_speed, () => {
          const { throttledScrollUp, throttledScrollDown } =
            createThrottledScrollHandlers(scroll_speed.value)
          self.on_scroll_up = throttledScrollUp
          self.on_scroll_down = throttledScrollDown
        })
      },
    },
  }
}
