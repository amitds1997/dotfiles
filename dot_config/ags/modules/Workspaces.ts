import { range } from "lib/utils"
import options from "options"

const { hideEmpty } = options.bar.workspaces
const hyprland = await Service.import("hyprland")

const dispatch = (ws_number: number) => {
  hyprland.messageAsync(`dispatch workspace ${ws_number}`).catch(logError)
}

function shouldHideWs(hideEmpty: boolean, ws_number: number) {
  // We should hide WS:
  // 1. (hideEmpty is True and there are no windows on
  // the workspace)
  // 2. BUT not if it is active
  if (hyprland.active.workspace.id === ws_number) {
    return false
  }

  const shouldHide =
    hideEmpty && (hyprland.getWorkspace(ws_number)?.windows || 0) <= 0

  return shouldHide
}

const WorkspaceButton = (ws_number: number) =>
  Widget.EventBox({
    class_name: "ws-button",
    on_primary_click_release: () => dispatch(ws_number),
    child: Widget.Label({
      label: `${ws_number}`,
      class_name: "ws-button-label",
    }),
  })

export const Workspaces = () =>
  Widget.EventBox({
    child: Widget.Box({
      class_name: "ws-container",
      children: range(10).map((i) => WorkspaceButton(i)),
    })
      .hook(hyprland, (self) => {
        self.children.forEach((btn, idx) => {
          btn.visible = !shouldHideWs(hideEmpty.value, idx + 1)
        })
      })
      .hook(hideEmpty, (self) => {
        self.children.forEach((btn, idx) => {
          btn.visible = !shouldHideWs(hideEmpty.value, idx + 1)
        })
      }),
  })
