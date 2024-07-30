import { type Application } from "types/service/applications"
import { type Stream } from "types/service/audio"
import icons, { substitutes } from "./icons"
import GLib from "gi://GLib?version=2.0"
import Gtk from "gi://Gtk?version=3.0"
import Gdk from "gi://Gdk?version=3.0"

export type Binding<T> = import("types/service").Binding<any, any, T>

/**
 * Retrieves icon path given the icon name, with optional fallback icon
 * @param name Name of the icon to retrieve
 * @param [fallback=icons.missing] Fallback icon name or path
 * @return Name/path of the icon found
 */
export function get_icon(
  name: string | null,
  fallback = icons.missing,
): string {
  if (!name) {
    return fallback || ""
  }

  if (GLib.file_test(name, GLib.FileTest.EXISTS)) {
    return name
  }

  const icon = substitutes[name] || name
  if (Utils.lookUpIcon(icon)) {
    return icon
  }

  console.debug(
    `no icon substitute "${icon}" for "${name}", using fallback: "${fallback}"`,
  )
  return fallback
}

/**
 * Retrieves an icon path based on the volume level of the provided audio stream.
 *
 * @param stream The audio stream object for which to retrieve the icon.
 * @param audio_icon_group The group of icons representing different audio levels, including muted.
 * @returns The path of the icon corresponding to the volume level of the stream,
 * or the muted icon if the stream is muted.
 */
export function get_stream_icon(
  stream: Stream,
  audio_icon_group: typeof icons.audio.speaker,
): string {
  const { muted, low, medium, high, overamplified } = audio_icon_group
  const cons = [
    [101, overamplified],
    [67, high],
    [34, medium],
    [1, low],
    [0, muted],
  ] as const
  const icon = cons.find(([n]) => n <= stream.volume * 100)?.[1] || ""
  return stream.is_muted ? muted : icon
}

/**
 * Executes a Zsh command asynchronously with optional interpolated values.
 *
 * @param strings A template string array or a single string containing the Zsh command with
 * placeholders for interpolation.
 * @param values Values to be interpolated into the Zsh command string. Can be omitted if `strings`
 * is a single string.
 * @returns A promise that resolves with the output of the executed Zsh command, or an empty string
 * if an error occurs.
 */
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

/**
 * Launches an application asynchronously in the background.
 *
 * @param app The application to launch.
 */
export function launchApp(app: Application) {
  const executable = app.executable
    .split(/\s+/)
    .filter((str: string) => !str.startsWith("%") && !str.startsWith("@"))
    .join(" ")

  zsh(`${executable} &`)
  app.frequency += 1
}

/**
 * Generates an array of Gtk.Windows for each monitor.
 *
 * @param widget A function that generates a Gtk.Window for a given monitor index.
 * @returns An array of Gtk.Windows for each monitor.
 */
export function forMonitors(
  widget: (monitor: number) => Gtk.Window,
): Gtk.Window[] {
  const n = Gdk.Display.get_default()?.get_n_monitors() || 1
  return range(n, 0).map(widget).flat(1)
}

/**
 * Generates a range of numbers.
 *
 * @param length The length of the range.
 * @param start The starting value of the range. Defaults to 1.
 * @returns An array containing a range of numbers.
 */
export function range(length: number, start = 1): number[] {
  return Array.from({ length }, (_, i) => i + start)
}

/**
 * Creates a Cairo surface from a Gtk.Widget.
 *
 * @param widget The Gtk.Widget to create a surface from.
 * @returns A Cairo surface representing the Gtk.Widget.
 */
export function createSurfaceFromWidget(widget: Gtk.Widget) {
  const cairo = imports.gi.cairo as any
  const alloc = widget.get_allocation()
  const surface = new cairo.ImageSurface(
    cairo.Format.ARGB32,
    alloc.width,
    alloc.height,
  )
  const cr = new cairo.Context(surface)
  cr.setSourceRGBA(255, 255, 255, 0)
  cr.rectangle(0, 0, alloc.width, alloc.height)
  cr.fill()
  widget.draw(cr)
  return surface
}

/**
 * Creates a debounced version of the provided function.
 *
 * @param func The function to debounce.
 * @param waitFor The debounce duration in milliseconds.
 * @returns A debounced version of the provided function.
 */
export const debounce = <F extends (...args: any[]) => any>(
  func: F,
  waitFor: number,
) => {
  let timeout: ReturnType<typeof setTimeout>

  return (...args: Parameters<F>): Promise<ReturnType<F>> =>
    new Promise((resolve) => {
      if (timeout) {
        clearTimeout(timeout)
      }

      timeout = setTimeout(() => resolve(func(...args)), waitFor)
    })
}

/**
 * Checks for the presence of required system binaries.
 *
 * This function takes a list of binary names and checks if they are available in the system's PATH.
 * If any of the binaries are missing, it logs an error message and sends a notification.
 *
 * @param bins - A list of binary names to check for.
 * @returns A boolean indicating whether all specified binaries
 * are present (`true`) or not (`false`).
 */ export function dependencies(...bins: string[]) {
  const missing = bins.filter((bin) =>
    Utils.exec({
      cmd: `which ${bin}`,
      out: () => false,
      err: () => true,
    }),
  )

  if (missing.length > 0) {
    console.error(Error(`missing dependencies: ${missing.join(", ")}`))
    Utils.notify(`missing dependencies: ${missing.join(", ")}`)
  }

  return missing.length === 0
}
