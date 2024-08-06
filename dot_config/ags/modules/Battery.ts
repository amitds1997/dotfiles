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
          let tooltip_text = `${minutes} minutes`
          if (hours > 0) {
            tooltip_text = `${hours} hours and ${tooltip_text}`
          }
          if (isCharging) {
            tooltip_text = `${tooltip_text} until full`
          } else {
            tooltip_text = `${tooltip_text} left`
          }
          return tooltip_text
        },
      ),
      children: [
        Widget.Icon({
          class_name: "battery-icon",
          icon: Utils.merge(
            [battery.bind("percent"), battery.bind("charging")],
            (percent, isCharging) => {
              let pctLabel = `${Math.floor(percent / 10) * 10}`
              if (isCharging) {
                pctLabel += "-charging"
              }
              return `battery-level-${pctLabel}-symbolic`
            },
          ),
        }),
        Widget.Label({
          class_name: "battery-label",
          label: battery.bind("percent").as((p) => `${p}%`),
        }),
      ],
    }),
  })
