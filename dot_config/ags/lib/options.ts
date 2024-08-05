import { Variable } from "resource:///com/github/Aylur/ags/variable.js"

type OptProps = {
  persistent?: boolean
}

export class Opt<T = unknown> extends Variable<T> {
  static {
    Service.register(this)
  }

  id = ""
  initial: T
  persistent: boolean

  constructor(initial: T, { persistent = false }: OptProps = {}) {
    super(initial)
    this.initial = initial
    this.persistent = persistent
  }

  init(cacheFile: string) {
    const cachedValue = JSON.parse(Utils.readFile(cacheFile) || "{}")[this.id]
    if (cachedValue !== undefined) {
      this.value = cachedValue
    }

    this.connect("changed", () => {
      const cache = JSON.parse(Utils.readFile(cacheFile) || "{}")
      cache[this.id] = this.value
      Utils.writeFileSync(JSON.stringify(cache, null, 2), cacheFile)
    })
  }

  reset() {
    if (this.persistent) {
      return
    }

    if (JSON.stringify(this.value) !== JSON.stringify(this.initial)) {
      this.value = this.initial
      return this.id
    }
  }

  toString() {
    return `${this.value}`
  }

  toJSON() {
    return `opt:${this.value}`
  }
}

function getOptions(object: object, path = ""): Opt[] {
  return Object.keys(object).flatMap((key) => {
    const obj: Opt = object[key]
    const id = path ? path + "." + key : key

    if (obj instanceof Variable) {
      obj.id = id
      return obj
    }

    if (typeof obj === "object") {
      return getOptions(obj, id)
    }

    return []
  })
}

export const opt = <T>(initial: T, opts?: OptProps) => new Opt(initial, opts)

export function mkOptions<T extends object>(cacheFile: string, object: T) {
  for (const opt of getOptions(object)) {
    opt.init(cacheFile)
  }

  // Ensure that directory for cacheFile does exist
  Utils.ensureDirectory(cacheFile.split("/").slice(0, -1).join("/"))

  const configFilePath = OPTIONS_FILE_PATH
  const values = getOptions(object).reduce(
    (obj, { id, value }) => ({ [id]: value, ...obj }),
    {},
  )
  Utils.writeFileSync(JSON.stringify(values, null, 2), configFilePath)
  Utils.monitorFile(configFilePath, () => {
    const cache = JSON.parse(Utils.readFile(configFilePath) || "{}")
    for (const opt of getOptions(object)) {
      if (JSON.stringify(cache[opt.id]) !== JSON.stringify(opt.value)) {
        opt.value = cache[opt.id]
      }
    }
  })

  function sleep(ms = 0) {
    return new Promise((r) => setTimeout(r, ms))
  }

  async function reset(
    [opt, ...list] = getOptions(object),
    id = opt?.reset(),
  ): Promise<Array<string>> {
    if (!opt) {
      return sleep().then(() => [])
    }

    return id
      ? [id, ...(await sleep(50).then(() => reset(list)))]
      : await sleep().then(() => reset(list))
  }

  return Object.assign(object, {
    configFile: configFilePath,
    array: () => getOptions(object),
    async reset() {
      return (await reset()).join("\n")
    },
    handler(deps: string[], callback: () => void) {
      for (const opt of getOptions(object)) {
        if (deps.some((i) => opt.id.startsWith(i))) {
          opt.connect("changed", callback)
        }
      }
    },
  })
}
