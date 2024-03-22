import { type Application } from "types/service/applications"
import icons, { substitues } from "./icons"
import GLib from "gi://GLib?version=2.0"
import Gtk from "gi://Gtk?version=3.0"
import Gdk from "gi://Gdk?version=3.0"

export type Binding<T> = import("types/service").Binding<any, any, T>

export function icon(name: string | null, fallback = icons.missing) {
  if (!name) return fallback || ""

  if (GLib.file_test(name, GLib.FileTest.EXISTS)) return name

  const icon = substitues[name] || name
  if (Utils.lookUpIcon(icon)) return icon

  console.debug(
    `no icon substitute "${icon}" for "${name}", using fallback: "${fallback}"`,
  )
  return fallback
}

export async function zsh(
  strings: TemplateStringsArray | string,
  ...values: unknown[]
) {
  const cmd =
    typeof strings === "string"
      ? strings
      : strings.flatMap((str, i) => str + `${values[i] ?? ""}`).join("")

  return Utils.execAsync(["zsh", "-c", cmd]).catch((err) => {
    console.error(cmd, err)
    return ""
  })
}

export function launchApp(app: Application) {
  const executable = app.executable
    .split(/\s+/)
    .filter((str: string) => !str.startsWith("%") && !str.startsWith("@"))
    .join(" ")

  zsh(`${executable} &`)
  app.frequency += 1
}

export function forMonitors(widget: (monitor: number) => Gtk.Window) {
  const n = Gdk.Display.get_default()?.get_n_monitors() || 1
  return range(n, 0).map(widget).flat(1)
}

export function range(length: number, start = 1) {
  return Array.from({ length }, (_, i) => i + start)
}
