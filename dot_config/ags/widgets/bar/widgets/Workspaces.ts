import { range, zsh } from "lib/utils"
import PanelWidget from "../PanelWidget"
import options from "options"

const hyprland = await Service.import("hyprland")
const min_workspaces = options.bar.workspaces

const dispatch = (arg: string | number) => {
  zsh(`hyprctl dispatch workspace ${arg}`)
}

const Workspace = (i: number) =>
  Widget.Button({
    attribute: i,
    vpack: "center",
    label: `${i}`,
    on_clicked: () => {
      if (i !== hyprland.active.workspace.id) dispatch(i)
    },
    setup: (self) =>
      self.hook(hyprland, () => {
        self.toggleClassName("active", hyprland.active.workspace.id === i)
        self.toggleClassName(
          "occupied",
          (hyprland.getWorkspace(i)?.windows || 0) > 0,
        )
      }),
  })

export default () =>
  PanelWidget({
    class_name: "workspaces",
    window_class: "workspaces",
    on_scroll_up: () => dispatch("m+1"),
    on_scroll_down: () => dispatch("m-1"),
    child: hyprland.bind("workspaces").as((w) => {
      const workspace_ids = [
        ...new Set([...range(min_workspaces.value), ...w.map((x) => x.id)]),
      ].sort()
      return Widget.Box(workspace_ids.map(Workspace))
    }),
  })
