import { Variable } from "resource:///com/github/Aylur/ags/variable.js";
import { waitAndExecute } from "./utils";
import options from "options";
import GLib from "types/@girs/glib-2.0/glib-2.0";

type OptProps = {
  persistent?: boolean;
};

/**
 * Represents an option variable that extends the Variable class.
 * @template T - The type of the option variable.
 */
export class Opt<T = unknown> extends Variable<T> {
  /**
   * Register the Opt class with the Service.
   */
  static {
    Service.register(this);
  }

  /**
   * Constructor for the Opt class.
   * @param initial - The initial value of the option.
   * @param {OptProps} options - Optional properties for the option.
   */
  constructor(initial: T, { persistent = false }: OptProps = {}) {
    super(initial);
    this.initial = initial;
    this.persistent = persistent;
  }

  // Properties of the Opt class
  initial: T;
  id = "";
  persistent: boolean;

  /**
   * Converts the option value to a string.
   * @returns The string representation of the option value.
   */
  toString() {
    return `${this.value}`;
  }

  /**
   * Converts the option value to JSON format.
   * @returns The JSON representation of the option value.
   */
  toJSON() {
    return `opt:${this.value}`;
  }

  /**
   * Initializes the option with a cached value if available and sets up a change listener to update the cache.
   * @param cacheFile - The file path for the cache.
   */
  init(cacheFile: string) {
    const cacheV = JSON.parse(Utils.readFile(cacheFile) || "{}")[this.id];
    if (cacheV !== undefined) this.value = cacheV;

    this.connect("changed", () => {
      const cache = JSON.parse(Utils.readFile(cacheFile) || "{}");
      cache[this.id] = this.value;
      Utils.writeFileSync(JSON.stringify(cache, null, 2), cacheFile);
    });
  }

  /**
   * Resets the option to its initial value if it is not persistent.
   * @returns The ID of the option if reset, otherwise undefined.
   */
  reset() {
    if (this.persistent) return;

    if (JSON.stringify(this.value) !== JSON.stringify(this.initial)) {
      this.value = this.initial;
      return this.id;
    }
  }
}

/**
 * Creates a new instance of the Opt class.
 * @template T - The type of the option variable.
 * @param initial - The initial value of the option.
 * @param options - Optional properties for the option.
 * @returns A new instance of the Opt class.
 */
export const opt = <T>(initial: T, opts?: OptProps) => new Opt(initial, opts);

/**
 * Retrieves all options from the given object recursively.
 * @param object - The object containing options.
 * @param path - The current path in the object hierarchy (used internally).
 * @returns An array of option instances.
 */
function getOptions(object: object, path = ""): Opt[] {
  return Object.keys(object).flatMap((key) => {
    const obj: Opt = object[key];
    const id = path ? path + "." + key : key;

    if (obj instanceof Variable) {
      obj.id = id;
      return obj;
    }

    if (typeof obj === "object") return getOptions(obj, id);

    return [];
  });
}

/**
 * Initializes and monitors options from an object, and provides a reset function.
 * @template T - The type of the object containing options.
 * @param cacheFile - The file path for the cache.
 * @param object - The object containing options.
 * @returns The object with additional properties (configFile, array, reset, handler).
 */
export function mkOptions<T extends object>(cacheFile: string, object: T) {
  // Initialize options and write initial values to the config file
  for (const opt of getOptions(object)) opt.init(cacheFile);

  const configFile = `${GLib.get_tmp_dir()}/ags/config.json`;

  // Write the initial values to the config file
  const values = getOptions(object).reduce(
    (obj, { id, value }) => ({ [id]: value, ...obj }),
    {},
  );
  Utils.writeFileSync(JSON.stringify(values, null, 2), configFile);

  // Monitor changes to the config file and update option values accordingly
  Utils.monitorFile(configFile, () => {
    const cache = JSON.parse(Utils.readFile(configFile) || "{}");
    for (const opt of getOptions(object)) {
      if (JSON.stringify(cache[opt.id]) !== JSON.stringify(opt.value))
        opt.value = cache[opt.id];
    }
  });

  /**
   * Resets options to their initial values and returns a promise with the list of reset IDs.
   * @param list - The list of options to reset (used internally).
   * @param id - The ID of the option to reset (used internally).
   * @returns A promise with an array of reset IDs.
   */
  async function reset(
    [opt, ...list] = getOptions(object),
    id = opt?.reset(),
  ): Promise<Array<string>> {
    if (!opt) return waitAndExecute(0, () => []);

    return id
      ? [id, ...(await waitAndExecute(50, () => reset(list)))]
      : await waitAndExecute(0, () => reset(list));
  }

  // Additional properties for the returned object
  return Object.assign(object, {
    configFile,
    /**
     * Retrieves an array of all options.
     * @returns An array of option instances.
     */
    array: () => getOptions(object),
    /**
     * Resets all options to their initial values.
     * @returns A promise with a string containing the IDs of reset options.
     */
    async reset() {
      return (await reset()).join("\n");
    },
    /**
     * Registers a callback to be executed when specified options change.
     * @param deps - The dependencies for the handler.
     * @param callback - The callback function to execute when options change.
     */
    handler(deps: string[], callback: () => void) {
      for (const opt of getOptions(options)) {
        if (deps.some((i) => opt.id.startsWith(i)))
          opt.connect("changed", callback);
      }
    },
  });
}
