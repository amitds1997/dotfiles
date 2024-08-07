import GLib from "gi://GLib?version=2.0"

declare global {
  const OPTIONS_FILE_PATH: string
  const TMP_DIR: string
  const USER_NAME: string
}

Object.assign(globalThis, {
  OPTIONS_FILE_PATH: `${GLib.get_user_cache_dir()}/ags/options.json`,
  TMP_DIR: `${GLib.get_tmp_dir()}/ags/`,
  USER_NAME: GLib.get_user_name(),
})

Utils.ensureDirectory(TMP_DIR)
