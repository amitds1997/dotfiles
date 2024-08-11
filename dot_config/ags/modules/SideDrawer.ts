import { icons } from "lib/icons"
import { StackState } from "lib/stackState"
import { WindowNames } from "modules/Bar"
import { RoundedCorner } from "modules/RoundedCorner"
import { timeout } from "resource:///com/github/Aylur/ags/utils/timeout.js"

type SideDrawerSide = "left" | "right"

function reverseArr<T>(arr: T[], drawerSide: SideDrawerSide) {
  return drawerSide === "right" ? arr.reverse() : arr
}

const StackSwitcherButton = (
  name: WindowNames,
  item: string,
  state: StackState<string>,
) =>
  Widget.Button({
    class_name: `${name}-switcher-button`,
    tooltip_text: item,
    child: Widget.Icon(icons.launcher[item.toLowerCase()] || "image-missing"),
    on_clicked: () => (state.value = item),
  }).hook(state, (button) => {
    button.toggleClassName("focused", state.value === item)
    const focusedID = state.items.indexOf(state.value)
    button.toggleClassName(
      "before-focused",
      state.items[focusedID - 1] === item,
    )
    button.toggleClassName("after-focused", state.items[focusedID + 1] === item)
  })

const StackSwitcherPadding = (
  name: WindowNames,
  start: boolean,
  state: StackState<string>,
) =>
  Widget.Box({
    class_name: `${name}-switcher-button`,
    vexpand: true,
    children: [Widget.Icon()],
  }).hook(state, (box) => {
    const focusedID = state.items.indexOf(state.value)
    box.toggleClassName("before-focused", start && focusedID === 0)
    box.toggleClassName(
      "after-focused",
      !start && focusedID === state.items.length - 1,
    )
  })

const StackSwitcher = (
  items: string[],
  name: WindowNames,
  state: StackState<string>,
) =>
  Widget.Box({
    vertical: true,
    class_name: `${name}-switcher`,
    children: [
      StackSwitcherPadding(name, true, state),
      ...items.map((i) => StackSwitcherButton(name, i, state)),
      StackSwitcherPadding(name, false, state),
    ],
  })

const SideDrawerStack = async (
  children: any,
  class_name: WindowNames,
  state: StackState<string>,
  transitionSide: SideDrawerSide,
) => {
  const stack = Widget.Stack({
    visible_child_name: state.bind(),
    transition: `over_${transitionSide}`,
    class_name: class_name,
    children,
  })
  return stack
}

export const SideDrawer = async (
  children: any,
  name: WindowNames,
  side: SideDrawerSide,
  state: StackState<string>,
) => {
  const transitionSide = side === "left" ? "right" : "left"
  const stack = await SideDrawerStack(children, name, state, transitionSide)
  state.items = Object.keys(stack.children)
  const stackSwitcher = StackSwitcher(Object.keys(stack.children), name, state)

  const window = Widget.Window({
    keymode: "exclusive",
    visible: false,
    anchor: [side, "top", "bottom"],
    name,
    child: Widget.Box({
      css: `padding-${transitionSide}: 2px`,
      children: reverseArr(
        [
          Widget.Revealer({
            reveal_child: false,
            transition: `slide_${transitionSide}`,
            transition_duration: 350,
            child: stackSwitcher,
          }).hook(App, (revealer, drawer_name, visible) => {
            if (drawer_name === name) {
              if (visible) {
                revealer.reveal_child = visible
              } else {
                timeout(100, () => (revealer.reveal_child = visible))
              }
            }
          }),
          Widget.Box({
            children: reverseArr(
              [
                Widget.Overlay({
                  child: Widget.Box({
                    children: [
                      Widget.Revealer({
                        reveal_child: false,
                        child: stack,
                        transition_duration: 350,
                        transition: `slide_${transitionSide}`,
                      }).hook(App, (revealer, drawer_name, visible) => {
                        if (drawer_name === name) {
                          if (visible) {
                            timeout(
                              100,
                              () => (revealer.reveal_child = visible),
                            )
                          } else {
                            revealer.reveal_child = visible
                          }
                        }
                      }),
                    ],
                  }),
                  overlays: [
                    RoundedCorner(`top${side}`, {
                      class_name: "corner",
                    }),
                    RoundedCorner(`bottom${side}`, {
                      class_name: "corner",
                    }),
                  ],
                }),
              ],
              side,
            ),
          }),
        ],
        side,
      ),
    }),
  })
  const addKeyBinds = (mods: any) => {
    window.keybind(mods, "Tab", () => state.next())
    for (let i = 0; i < 10; i++) {
      // @ts-expect-error Known issue
      window.keybind(mods, `${i}`, () => state.setIndex(i))
      // @ts-expect-error Known issue
      window.keybind(mods, `KP_${i}`, () => state.setIndex(i))
    }
  }
  window.keybind("Escape", () => App.closeWindow(name))
  addKeyBinds(["MOD1"])
  addKeyBinds(["MOD1", "MOD2"])
  return window
}
