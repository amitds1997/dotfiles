import powermenu from "services/powermenu"
import { PopupNames, PopupWindow } from "../PopupWindow"

export const PowerMenuVerificationPopup = () =>
  PopupWindow({
    name: PopupNames.PowerMenuVerification,
    transition: "crossfade",
    child: Widget.Box({
      class_name: "verification",
      child: Widget.Box({
        class_name: "verification-content",
        expand: true,
        vertical: true,
        children: [
          Widget.Box({
            class_name: "text-box",
            vertical: true,
            children: [
              Widget.Label({
                class_name: "title",
                label: powermenu.bind("title").as((t) => t.toUpperCase()),
              }),
              Widget.Label({
                class_name: "desc",
                label: powermenu
                  .bind("title")
                  .as((p) => `Are you sure you want to ${p.toLowerCase()}?`),
              }),
            ],
          }),
          Widget.Box({
            class_name: "buttons horizontal",
            vexpand: true,
            vpack: "end",
            homogeneous: true,
            children: [
              Widget.Button({
                class_name: "verification-button bar-verification_yes",
                child: Widget.Label("Yes"),
                on_clicked: powermenu.exec,
              }),
              Widget.Button({
                class_name: "verification-button bar-verification_no",
                child: Widget.Label("No"),
                on_clicked: () =>
                  App.toggleWindow(PopupNames.PowerMenuVerification),
              }),
            ],
          }),
        ],
      }),
    }),
  })
