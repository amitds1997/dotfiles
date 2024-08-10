// import { icons } from "lib/icons"
import { StackState } from "lib/stackState"
import { SearchBox } from "./Search"
import { Categories } from "./Categories"
import { WindowNames } from "modules/Bar"
// import { RoundedCorner } from "modules/RoundedCorner"
// import { timeout } from "resource:///com/github/Aylur/ags/utils/timeout.js"
import { SideDrawer } from "modules/Launcher"

const LauncherState = new StackState("Search")

// const StackSwitcherButton = (item: string) =>
//   Widget.Button({
//     class_name: "launcher-switcher-button",
//     tooltip_text: item,
//     child: Widget.Icon(icons.launcher[item.toLowerCase()] || "image-missing"),
//     on_clicked: () => (LauncherState.value = item),
//   }).hook(LauncherState, (button) => {
//     button.toggleClassName("focused", LauncherState.value === item)
//     const focusedID = LauncherState.items.indexOf(LauncherState.value)
//     button.toggleClassName(
//       "before-focused",
//       LauncherState.items[focusedID - 1] === item,
//     )
//     button.toggleClassName(
//       "after-focused",
//       LauncherState.items[focusedID + 1] === item,
//     )
//   })

// const StackSwitcherPadding = (start: boolean) =>
//   Widget.Box({
//     class_name: "launcher-switcher-button",
//     vexpand: true,
//     children: [Widget.Icon()],
//   }).hook(LauncherState, (box) => {
//     const focusedID = LauncherState.items.indexOf(LauncherState.value)
//     box.toggleClassName("before-focused", start && focusedID === 0)
//     box.toggleClassName(
//       "after-focused",
//       !start && focusedID === LauncherState.items.length - 1,
//     )
//   })

// const StackSwitcher = (items: string[]) =>
//   Widget.Box({
//     vertical: true,
//     class_name: "launcher-switcher",
//     children: [
//       StackSwitcherPadding(true),
//       ...items.map((i) => StackSwitcherButton(i)),
//       StackSwitcherPadding(false),
//     ],
//   })

// const LauncherStack = async () => {
//   const children = {
//     Search: SearchBox(LauncherState),
//     ...Categories(),
//   }
//   const stack = Widget.Stack({
//     visible_child_name: LauncherState.bind(),
//     transition: "over_right",
//     class_name: WindowNames.Launcher,
//     children,
//   })
//   return stack
// }

// function toggle(value: string) {
//   const current = LauncherState.value
//   if (current === value && App.getWindow(WindowNames.Launcher)?.visible) {
//     App.closeWindow(WindowNames.Launcher)
//   } else {
//     App.openWindow(WindowNames.Launcher)
//     LauncherState.value = value
//   }
// }

// globalThis.toggleLauncher = () => toggle("Search")
// globalThis.toggleHyprlandSwitcher = () => toggle("Hyprland")
// globalThis.toggleFirefoxSwitcher = () => toggle("Firefox")

// export const Launcher = async () => {
//   const stack = await LauncherStack()
//   LauncherState.items = Object.keys(stack.children)
//   const stackSwitcher = StackSwitcher(Object.keys(stack.children))
//   const window = Widget.Window({
//     keymode: "exclusive",
//     visible: false,
//     anchor: ["left", "top", "bottom"],
//     name: WindowNames.Launcher,
//     child: Widget.Box({
//       css: "padding-right: 2px",
//       children: [
//         Widget.Revealer({
//           reveal_child: false,
//           transition: "slide_right",
//           transition_duration: 350,
//           child: stackSwitcher,
//         }).hook(App, (revealer, name, visible) => {
//           if (name === WindowNames.Launcher) {
//             if (visible) {
//               revealer.reveal_child = visible
//             } else {
//               timeout(100, () => (revealer.reveal_child = visible))
//             }
//           }
//         }),
//         Widget.Box({
//           children: [
//             Widget.Overlay({
//               child: Widget.Box({
//                 children: [
//                   Widget.Revealer({
//                     reveal_child: false,
//                     child: stack,
//                     transition_duration: 350,
//                     transition: "slide_right",
//                   }).hook(App, (revealer, name, visible) => {
//                     if (name === WindowNames.Launcher) {
//                       if (visible) {
//                         timeout(100, () => (revealer.reveal_child = visible))
//                       } else {
//                         revealer.reveal_child = visible
//                       }
//                     }
//                   }),
//                   Widget.Box({ css: "min-width: 1rem" }),
//                 ],
//               }),
//               overlays: [
//                 RoundedCorner("topleft", { class_name: "corner" }),
//                 RoundedCorner("bottomleft", { class_name: "corner" }),
//               ],
//             }),
//           ],
//         }),
//       ],
//     }),
//   })
//   const addKeyBinds = (mods: any) => {
//     window.keybind(mods, "Tab", () => LauncherState.next())
//     for (let i = 0; i < 10; i++) {
//       // @ts-expect-error Known issue
//       window.keybind(mods, `${i}`, () => LauncherState.setIndex(i))
//       // @ts-expect-error Known issue
//       window.keybind(mods, `KP_${i}`, () => LauncherState.setIndex(i))
//     }
//   }
//   window.keybind("Escape", () => App.closeWindow(WindowNames.Launcher))
//   addKeyBinds(["MOD1"])
//   addKeyBinds(["MOD1", "MOD2"])
//   return window
// }
export const Launcher = async () => {
  const children = {
    Search: SearchBox(LauncherState),
    ...Categories(),
  }
  return SideDrawer(children, WindowNames.Launcher, "left", LauncherState)
}
