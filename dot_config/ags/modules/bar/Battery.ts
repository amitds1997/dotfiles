import options from "options"

const battery = await Service.import("battery")

const { label: show_label } = options.car.battery

const BatteryLabel = () => {
  const isVisible = battery.bind("available")

  const icon = () => battery.bind("percent").as((p) => )
}
