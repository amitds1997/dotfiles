import Gdk from "gi://Gdk?version=3.0"
import Gtk from "gi://Gtk?version=3.0"

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
