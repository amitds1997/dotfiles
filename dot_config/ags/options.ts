import { mkOptions, opt } from "lib/options";

const options = mkOptions(OPTIONS, {
  transition: opt(200),

  powermenu: {
    lock: opt("hyprlock"),
    logout: opt(`loginctl terminate-user ${USER_NAME}`),
    shutdown: opt("systemctl poweroff"),
    reboot: opt("systemctl reboot"),
    suspend: opt("systemctl suspend"),
    hibernate: opt("systemctl hibernate"),
    layout: opt<"line" | "box">("box"),
    labels: opt(true),
  },
});

globalThis["options"] = options;
export default options;
