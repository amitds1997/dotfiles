const battery = await Service.import("battery")

const formatTime = (seconds: number) => {
  const hours = Math.floor(seconds / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)
  return { hours, minutes }
}

export const Battery = () =>
  Widget.EventBox({
    visible: battery.bind("available"),
    child: Widget.Box({
      class_name: "battery-container",
      tooltip_text: Utils.merge(
        [
          battery.bind("time_remaining"),
          battery.bind("charging"),
          battery.bind("charged"),
        ],
        (remainingSeconds, isCharging, isCharged) => {
          if (isCharged) {
            return "Fully charged"
          }
          const { hours, minutes } = formatTime(remainingSeconds)
          if (isCharging) {
            return `${hours} hours and ${minutes} minutes until full`
          }
          return `${hours} hours and ${minutes} minutes left`
        },
      ),
      children: [
        Widget.Icon({
          class_name: "battery-icon",
          icon: battery
            .bind("percent")
            .as((p) => `battery-level-${Math.floor(p / 10) * 10}-symbolic`),
        }),
        Widget.Label({
          class_name: "battery-label",
          label: battery.bind("percent").as((p) => `${p}%`),
        }),
      ],
    }),
  })
