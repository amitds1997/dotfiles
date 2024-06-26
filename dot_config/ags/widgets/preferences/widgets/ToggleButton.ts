import GObject from "types/@girs/gobject-2.0/gobject-2.0"
import { ButtonProps } from "types/widgets/button"
import { IconProps } from "types/widgets/icon"
import { LabelProps } from "types/widgets/label"

type ToggleButtonProps = {
  icon: IconProps["icon"]
  label?: LabelProps["label"]
  toggle_action: () => void
  connection: [GObject.Object, () => boolean]
}

export const ToggleButton = ({
  icon,
  label,
  toggle_action,
  connection: [service, is_active],
  ...rest
}: ToggleButtonProps & ButtonProps) =>
  Widget.Button({
    on_clicked: toggle_action,
    class_name: "toggle-button",
    setup: (self) =>
      self.hook(service, () => {
        self.toggleClassName("active", is_active())
      }),
    child: Widget.Box({
      children: [
        Widget.Icon({
          icon: icon,
        }),
        Widget.Label({
          visible: label != null,
          max_width_chars: 10,
          truncate: "end",
          label,
        }),
      ],
    }),
    ...rest,
  })
