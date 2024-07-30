import Gdk from "gi://Gdk?version=3.0"
import options from "options"

const systemTray = await Service.import("systemtray")

const { ignore } = options.car.systray

export const SysTray = () => {
  const isVis = Variable(false)

  const items = Utils.merge(
    [systemTray.bind("items"), ignore.bind("value")],
    (items, ignored_items) => {
      const filteredTray = items.filter(({ id }) => !ignored_items.includes(id))
      isVis.value = filteredTray.length > 0

      return filteredTray.map((item) => {
        if (item.menu !== undefined) {
          item.menu["class_name"] = "systray-menu"
        }

        return Widget.Button({
          cursor: "pointer",
          child: Widget.Icon({
            class_name: "systray-icon",
            icon: item.bind("icon"),
          }),
          on_primary_click: (_: any, event: Gdk.Event) => item.activate(event),
          on_secondary_click: (_, event) => item.openMenu(event),
          tooltip_markup: item.bind("tooltip_markup"),
        })
      })
    },
  )

  return {
    component: Widget.Box({
      class_name: "systray",
      children: items,
    }),
    isVisible: true,
    boxClass: "systray",
    isVis,
  }
}
