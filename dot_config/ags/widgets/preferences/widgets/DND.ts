import icons from "lib/icons"
import { ToggleButton } from "./ToggleButton"

const notifications = await Service.import("notifications")
const dnd = notifications.bind("dnd")

export const DND = () =>
  ToggleButton({
    icon: dnd.as((dnd) => icons.notifications[dnd ? "silent" : "noisy"]),
    label: dnd.as((dnd) => (dnd ? "DND On" : "DND Off")),
    toggle_action: () => (notifications.dnd = !notifications.dnd),
    connection: [notifications, () => notifications.dnd],
  })
