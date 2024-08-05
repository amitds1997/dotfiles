import { mkOptions, opt } from "lib/options"

const options = mkOptions(OPTIONS_FILE_PATH, {
  bar: {
    position: opt<"top" | "bottom">("top"),
    workspaces: {
      hideEmpty: opt(false),
    },
  },
})

globalThis["options"] = options
export default options
