export const substitues = {
  "transmission-gtk": "transmission",
  "com.github.Aylur.ags": "controls-symbolic",
  "com.github.Aylur.ags-symbolic": "controls-symbolic",
}

export default {
  missing: "image-missing-symbolic",
  fallback: {
    executable: "application-x-executable-symbolic",
    notification: "dialog-information-symbolic",
    audio: "audio-x-generic-symbolic",
  },
  audio: {
    mic: {
      muted: "microphone-disabled-symbolic",
      high: "microphone-sensitivity-high-symbolic",
    },
    type: {
      speaker: "audio-speakers-symbolic",
    },
  },
  powermenu: {
    hibernate: "night-light-symbolic",
    reboot: "system-reboot-symbolic",
    logout: "system-log-out-symbolic",
    shutdown: "system-shutdown-symbolic",
    lock: "system-lock-screen-symbolic",
    suspend: "media-playback-pause-symbolic",
  },
  ui: {
    search: "search-system-symbolic",
  },
  battery: {
    charging: "battery-good-charging-symbolic",
    warning: "battery-empty-symbolic",
  },
  notifications: {
    silent: "notifications-disabled-symbolic",
  },
  trash: {
    full: "user-trash-full-symbolic",
    empty: "user-trash-symbolic",
  },
}
