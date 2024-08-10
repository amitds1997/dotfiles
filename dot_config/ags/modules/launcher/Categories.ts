import { WindowNames } from "modules/Bar"
import { Application } from "types/service/applications"
import { AppIcon } from "./utils"

const apps = await Service.import("applications")

const mainCategories = [
  "AudioVideo",
  "Audio",
  "Video",
  "Development",
  "Games",
  "Graphics",
  "Office",
  "Network",
  "Settings",
  "System",
  "Utility",
]

const getCategories = (app: Application) => {
  const substitute = (cat: string) => {
    const map = {
      Audio: "Multimedia",
      AudioVideo: "Multimedia",
      Video: "Multimedia",
      Graphics: "Multimedia",
      Science: "Education",
      Settings: "System",
    }
    return map[cat] ?? cat
  }
  return (
    app.app
      .get_categories()
      ?.split(";")
      .filter((c) => mainCategories.includes(c))
      .map(substitute)
      .filter((c, i, arr) => i === arr.indexOf(c)) ?? []
  )
}

const categoryList = () => {
  const categoryMap = new Map()

  apps.list.forEach((app) => {
    const cats = getCategories(app)
    cats.forEach((cat) => {
      if (!categoryMap.has(cat)) {
        categoryMap.set(cat, [])
      }
      categoryMap.get(cat).push(app)
    })
  })

  return categoryMap
}

const AppButton = (app: Application) =>
  Widget.Button({
    on_clicked: () => {
      app.launch()
      App.closeWindow(WindowNames.Launcher)
    },
    tooltip_text: app.description,
    class_name: "app-button",
    child: Widget.Box({
      vertical: true,
      children: [
        AppIcon(app),
        Widget.Label({
          max_width_chars: 8,
          truncate: "end",
          label: app.name,
          vpack: "center",
          class_name: "app-name",
        }),
      ],
    }),
  })
    .on("focus-in-event", (self) => {
      self.toggleClassName("focused", true)
    })
    .on("focus-out-event", (self) => {
      self.toggleClassName("focused", false)
    })

const CategoryListWidget = (key: string, list: Application[]) => {
  const flowBox = Widget.FlowBox({})
  list.forEach((app) => {
    flowBox.add(AppButton(app))
  })
  return Widget.Box({
    class_name: "launcher-category",
    children: [
      Widget.Scrollable({
        hscroll: "never",
        vscroll: "automatic",
        hexpand: true,
        child: Widget.Box({
          vertical: true,
          children: [
            Widget.Label({ class_name: "launcher-header", label: key }),
            flowBox,
            Widget.Box({ vexpand: true }),
          ],
        }),
      }),
    ],
  })
}

export const Categories = () =>
  Object.fromEntries(
    [...categoryList()].map(([key, val]) => [
      key,
      CategoryListWidget(key, val),
    ]),
  )
