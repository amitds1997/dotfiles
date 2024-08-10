import Gtk from "gi://Gtk?version=3.0"
import { icons } from "lib/icons"
import { WindowNames } from "modules/Bar"
import { Application } from "types/service/applications"
import { LauncherState } from "./AppLaunchers"
import { AppIcon } from "./utils"
// @ts-expect-error We want to do imports like this here. Deal with it
import { Fzf, FzfResultItem } from "fzf"
import Box from "types/widgets/box"

const applications = await Service.import("applications")

const AppButton = (app: Application) =>
  Widget.Button({
    on_clicked: () => {
      app.launch()
      App.closeWindow(WindowNames.Launcher)
    },
    attribute: { app: app },
    tooltip_text: app.description,
    class_name: "app-button",
    child: Widget.Box({
      children: [
        AppIcon(app),
        Widget.Box({
          vertical: true,
          children: [
            Widget.Label({
              xalign: 0,
              max_width_chars: 28,
              truncate: "end",
              use_markup: true,
              label: app.name,
              class_name: "app-name",
            }),
            Widget.Label({
              xalign: 0,
              max_width_chars: 40,
              truncate: "end",
              label: app.description,
              class_name: "app-description",
            }),
          ],
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

type AppButtonType = ReturnType<typeof AppButton>

const fzf = new Fzf(applications.list.map(AppButton), {
  selector: (item: AppButtonType) => item.attribute.app.name,
  tiebreakers: [
    (a: FzfResultItem<AppButtonType>, b: FzfResultItem<AppButtonType>) =>
      b.item.attribute.app.frequency - a.item.attribute.app.frequency,
  ],
})

function searchApps(text: string, results: Box<Gtk.Widget, unknown>) {
  results.children.forEach((c) => results.remove(c))
  const fzfResults = fzf.find(text)

  const context = results.get_style_context()
  const color = context.get_color(Gtk.StateFlags.NORMAL)
  const hexcolor =
    "#" +
    (color.red * 0xff).toString(16).padStart(2, "0") +
    (color.green * 0xff).toString(16).padStart(2, "0") +
    (color.blue * 0xff).toString(16).padStart(2, "0")
  fzfResults.forEach((entry: FzfResultItem<AppButtonType>) => {
    const nameChars = entry.item.attribute.app.name.normalize().split("")
    entry.item.child.children[1].children[0].label = nameChars
      .map((char: string, i: number) => {
        if (entry.positions.has(i)) {
          return `<span foreground="${hexcolor}">${char}</span>`
        } else {
          return char
        }
      })
      .join("")
  })

  results.children = fzfResults.map((e: FzfResultItem<AppButtonType>) => e.item)
}

export const SearchBox = (launcherState: typeof LauncherState) => {
  const results = Widget.Box({
    vertical: true,
    vexpand: true,
    class_name: "search-results",
  })

  const entry = Widget.Entry({
    class_name: "search-entry",
    placeholder_text: "search",
    primary_icon_name: icons.launcher.search,
    on_change: ({ text }) => {
      searchApps(text || "", results)
      results.children.forEach((w, index) =>
        w.toggleClassName("focused", index === 0),
      )
    },
    on_accept: () => {
      if (results.children.length > 0) {
        results.children[0].activate()
      }
    },
  })
    .hook(launcherState, () => {
      if (launcherState.value !== "Search") {
        return
      }
      entry.text = "-"
      entry.text = ""
      entry.grab_focus()
    })
    .hook(
      App,
      (_, name, visible) => {
        if (name !== WindowNames.Launcher || !visible) {
          return
        }
        if (launcherState.value === "Search") {
          // This is to make sure that the appList gets pre-populated
          entry.text = "-"
          entry.text = ""
          entry.grab_focus()
        }
      },
      "window-toggled",
    )

  return Widget.Box({
    vertical: true,
    class_name: "launcher-search",
    children: [
      Widget.Label({ class_name: "launcher-header", label: "App search" }),
      entry,
      Widget.Scrollable({
        class_name: "search-scroll",
        child: results,
      }),
    ],
  })
}
