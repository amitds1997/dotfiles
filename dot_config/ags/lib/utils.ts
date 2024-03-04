import Gdk from "gi://Gdk"
import GLib from "gi://GLib?version=2.0"
import Gtk from "gi://Gtk?version=3.0"
import icons, { substitutes } from "./icons"

/**
 * Creates an array of Gtk.Window instances by applying the specified widget function
 * for each monitor available on the default Gdk.Display.
 *
 * @param widget - A function that takes a monitor index (number) and returns a Gtk.Window instance.
 * @returns An array of Gtk.Window instances created by applying the widget function for each monitor.
 *
 * @remarks
 * This function retrieves the number of monitors from the default Gdk.Display and applies the specified widget
 * function to create Gtk.Window instances for each monitor.
 *
 * @example
 * // Create an array of Gtk.Window instances for each monitor using a custom widget function
 * const monitorWindows = forMonitors((monitorIndex) => {
 *   const window = new Gtk.Window();
 *   // Configure window properties based on the monitor index
 *   // ...
 *   return window;
 * });
 * console.log(monitorWindows); // Array of Gtk.Window instances
 */
export function forMonitors(
  widget: (monitor: number) => Gtk.Window,
): Gtk.Window[] {
  const n = Gdk.Display.get_default()?.get_n_monitors() || 1
  return range(n, 0).map(widget).flat(1)
}

/**
 * Generates an array of numbers within a specified range.
 *
 * @param length - The number of elements to generate in the array.
 * @param start - The starting value of the range. Default is 1.
 * @returns An array of numbers within the specified range.
 */
export function range(length: number, start = 1): number[] {
  return Array.from({ length }, (_, i) => i + start)
}

/**
 * Delays execution by the specified duration and resolves a Promise with the result of the provided callback.
 *
 * @template T - The type of the result returned by the callback.
 * @param {number} ms - The duration to wait in milliseconds before executing the callback.
 * @param {() => T} callback - The callback function to be executed after the delay.
 * @returns {Promise<T>} A Promise that resolves with the result of the callback after the specified delay.
 * @throws {Error} If `ms` is a negative value.
 *
 * @example
 * // Delay for 1000 milliseconds and then execute the callback returning the number 42
 * waitAndExecute<number>(1000, () => 42).then((result) => {
 *   console.log(result); // Output: 42
 * });
 */
export function waitAndExecute<T>(ms: number, callback: () => T): Promise<T> {
  return new Promise((resolve) =>
    Utils.timeout(ms, () => {
      resolve(callback())
    }),
  )
}

/**
 * Resolves the icon path based on the provided name or returns a fallback icon path if no match is found.
 *
 * @param name - The name of the icon to resolve. If undefined or an empty string, the fallback icon will be used.
 * @param [fallback=icons.missing] - The default fallback icon path to use if no match is found. Defaults to 'icons.missing'.
 * @returns The resolved icon path or the fallback icon path if no match is found.
 *
 * @remarks
 * This function looks for the specified icon in the following order:
 * 1. If the provided 'name' is falsy, the 'fallback' icon is returned.
 * 2. If the file specified by 'name' exists, 'name' is returned as the icon path.
 * 3. If a substitute for the 'name' is defined in 'substitutes', that substitute is used as the icon path.
 * 4. If the 'name' is a valid icon path, it is used as the icon path.
 * 5. If none of the above conditions are met, the 'fallback' icon is returned, and a warning message is printed.
 *
 * @example
 * // Get the icon path for "folder" or use the fallback if not found
 * const folderIcon = getGTKIcon("folder", "icons.defaultFolder");
 * console.log(folderIcon); // Output: "/path/to/folder/icon.png" or "icons.defaultFolder" if not found
 */
export function getGTKIcon(name?: string, fallback = icons.missing): string {
  if (!name) return fallback || ""

  if (GLib.file_test(name, GLib.FileTest.EXISTS)) return name

  const icon = substitutes[name] || name
  if (Utils.lookUpIcon(icon)) return icon

  print(`no icon substitute "${icon}" for "${name}", fallback: "${fallback}"`)
  return fallback
}

/**
 * Executes a Bash command asynchronously.
 *
 * @param strings - Either a TemplateStringsArray or a string representing the Bash command with placeholders.
 * @param values - Values to substitute in the placeholders of the Bash command.
 * @returns A promise that resolves with the result of the Bash command or an empty string if there is an error.
 */
export async function bash(
  strings: TemplateStringsArray | string,
  ...values: unknown[]
): Promise<string> {
  const cmd =
    typeof strings === "string"
      ? strings
      : strings.flatMap((str, i) => str + `${values[i] ?? ""}`).join("")

  return Utils.execAsync(["bash", "-c", cmd]).catch((err) => {
    console.error(cmd, err)
    return ""
  })
}

/**
 * Executes a Shell command asynchronously.
 *
 * @param cmd - Either a string representing the Shell command or an array of strings representing the command and its arguments.
 * @returns A promise that resolves with the result of the Shell command or an empty string if there is an error.
 */
export async function sh(cmd: string | string[]): Promise<string> {
  return Utils.execAsync(cmd).catch((err) => {
    console.error(typeof cmd === "string" ? cmd : cmd.join(" "), err)
    return ""
  })
}

/**
 * Checks for the existence of specified dependencies.
 *
 * @param bins - Names of the binaries (dependencies) to check for.
 * @returns True if all dependencies exist, false otherwise.
 */
export function dependencies(...bins: string[]): boolean {
  const missing = bins.filter((bin) => {
    return !Utils.exec(`which ${bin}`)
  })

  if (missing.length > 0)
    console.warn("missing dependencies:", missing.join(", "))

  return missing.length === 0
}
