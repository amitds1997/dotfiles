import options from "options"
import { RoundedAngleEnd } from "./RoundedCorner"
import { Workspaces } from "./Workspaces"
import { WindowTitle } from "./WindowTitle"
import { Clock } from "./Clock"
import { Battery } from "./Battery"
import { Audio } from "./Audio"
import { Network } from "./Network"
import { SystemTray } from "./SystemTray"
import { MusicBarContainerRevealer } from "./Music"

const { position } = options.bar
const { hideEmpty } = options.bar.workspaces

const Right = () =>
  Widget.EventBox({
    hpack: "end",
    child: Widget.Box({
      children: [SystemTray(), Audio(), Battery(), Network(), Clock()],
    }),
  })

const Center = () =>
  Widget.Box({
    children: [Widget.Label("p"), MusicBarContainerRevealer()],
  })

const Left = () =>
  Widget.EventBox({
    hpack: "start",
    on_secondary_click_release: () => (hideEmpty.value = !hideEmpty.value),
    child: Widget.Box({
      children: [Workspaces(), WindowTitle()],
    }),
  })

const Bar = () => {
  const left = Left()
  const center = Center()
  const right = Right()

  const bar = Widget.CenterBox({
    start_widget: Widget.Box({
      children: position
        .bind("value")
        .as((p) => [
          left,
          RoundedAngleEnd(`${p}right`, { class_name: "angle" }),
        ]),
    }),
    center_widget: center,
    end_widget: Widget.Box({
      children: position.bind("value").as((p) => [
        Widget.Box({
          hexpand: true,
        }),
        RoundedAngleEnd(`${p}left`, {
          class_name: "angle",
          click_through: true,
        }),
        right,
      ]),
    }),
  })

  return bar
}

export const BarWindow = (monitor: number) =>
  Widget.Window({
    monitor,
    name: `bar-${monitor}`,
    class_name: "bar",
    anchor: position.bind("value").as((pos) => [pos, "left", "right"]),
    exclusivity: "exclusive",
    child: Bar(),
  })
