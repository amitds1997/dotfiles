import { range } from "lib/utils"
import options from "options"

const { hideEmpty } = options.bar.workspaces
const hyprland = await Service.import("hyprland")

const dispatch = (i: string | number) => {
  hyprland.messageAsync(`dispatch workspace ${i}`).catch(logError)
}

function applyCssToWs(box: any) {
  box.children.forEach((button: any, i: number) => {
    const ws = hyprland.getWorkspace(i + 1)
    const ws_before = hyprland.getWorkspace(i)
    const ws_after = hyprland.getWorkspace(i + 2)

    button.toggleClassName(
      "occupied",
      (ws?.windows || 0) > 0 || hideEmpty.value,
    )

    const occLeft = hideEmpty.value
      ? box.children.findIndex((btn: any) => btn.visible) === i
      : !ws_before || ws_before?.windows <= 0

    const occRight = hideEmpty.value
      ? box.children.reverse().findIndex((btn: any) => btn.visible) ===
        box.children.length - i - 1
      : !ws_after || ws_after?.windows <= 0

    button.toggleClassName("occupied-left", occLeft)
    button.toggleClassName("occupied-right", occRight)
  })
}

const WorkspaceButton = (i: number) =>
  Widget.EventBox({
    class_name: "ws-button active-left active-right",
    on_primary_click_release: () => dispatch(i),
    child: Widget.Label({
      label: `${i}`,
      class_name: "ws-button-label",
    }),
  })
    .hook(hideEmpty, (self) => {
      self.visible =
        !hideEmpty.value || (hyprland.getWorkspace(i)?.windows || 0) > 0
    })
    .hook(hyprland.active.workspace, (btn) => {
      const active = hyprland.monitors
        .map((mon) => mon.activeWorkspace.id)
        .includes(i)
      btn.toggleClassName("active", active)
      // if (!btn.visible) {
      //   btn.visible = active
      // }
    })

export const Workspaces = () =>
  Widget.EventBox({
    child: Widget.Box({
      class_name: "ws-container",
      children: range(10).map((i) => WorkspaceButton(i)),
    })
      .hook(hyprland, applyCssToWs, "notify::workspaces")
      .hook(hideEmpty, applyCssToWs),
  })
