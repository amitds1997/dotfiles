const network = await Service.import("network")

export const Network = () =>
  Widget.EventBox({
    child: Widget.Box({
      class_name: "network-container",
      tooltip_text: network
        .bind("primary")
        .as((p) =>
          p === "wired"
            ? "Wired"
            : network.wifi.ssid || "Unknown wireless network",
        ),
      child: Widget.Icon({
        class_name: "network-icon",
        icon: network.bind("primary").as((p) => {
          return p === "wired"
            ? network.wired.icon_name
            : network.wifi.icon_name
        }),
      }),
    }),
  })
