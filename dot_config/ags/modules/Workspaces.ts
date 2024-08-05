import { range } from "lib/utils"
import options from "options"

const { hideEmpty } = options.bar.workspaces
const hyprland = await Service.import("hyprland")

const dispatch = (ws_number: number) => {
  hyprland.messageAsync(`dispatch workspace ${ws_number}`).catch(logError)
}

function applyCssToWorkspaces(box: any) {
  box.children.forEach((button: any, i: number) => {
    const ws = hyprland.getWorkspace(i + 1)
    const ws_before = hyprland.getWorkspace(i)
    const ws_after = hyprland.getWorkspace(i + 2)

    button.toggleClassName("occupied", (ws?.windows || 0) > 0)

    const occLeft = !ws_before || ws_before?.windows <= 0
    const occRight = !ws_after || ws_after?.windows <= 0

    button.toggleClassName("occupied-left", occLeft)
    button.toggleClassName("occupied-right", occRight)
  })
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
    class_name: "ws-button active-left active-right",
    on_primary_click_release: () => dispatch(ws_number),
    child: Widget.Label({
      label: `${ws_number}`,
      class_name: "ws-button-label",
    }),
  }).hook(hyprland.active.workspace, (btn) => {
    btn.toggleClassName("active", hyprland.active.workspace.id === ws_number)
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
        applyCssToWorkspaces(self)
      })
      .hook(hideEmpty, (self) => {
        self.children.forEach((btn, idx) => {
          btn.visible = !shouldHideWs(hideEmpty.value, idx + 1)
        })
        applyCssToWorkspaces(self)
      }),
  })
