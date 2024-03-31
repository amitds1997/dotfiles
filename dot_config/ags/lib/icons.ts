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
    video: "video-x-generic-symbolic",
  },
  mpris: {
    playing: "media-playback-pause-symbolic",
    stopped: "media-playback-start-symbolic",
    prev: "media-skip-backward-symbolic",
    next: "media-skip-forward-symbolic",
  },
  audio: {
    mixer: "",
    mic: {
      muted: "microphone-sensitivity-muted-symbolic",
      high: "microphone-sensitivity-high-symbolic",
      low: "microphone-sensitivity-low-symbolic",
      medium: "microphone-sensitivity-medium-symbolic",
    },
    volume: {
      muted: "audio-volume-muted-symbolic",
      low: "audio-volume-low-symbolic",
      medium: "audio-volume-medium-symbolic",
      high: "audio-volume-high-symbolic",
      overamplified: "audio-volume-overamplified-symbolic",
    },
    type: {
      speaker: "audio-speakers-symbolic",
      headset: "",
    },
  },
  bluetooth: {
    enabled: "bluetooth-active-symbolic",
    disabled: "bluetooth-disabled-symbolic",
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
    colorpicker: "color-select-symbolic",
    arrow: {
      right: "pan-end-symbolic",
    },
    tick: "object-select-symbolic",
    settings: "emblem-system-symbolic",
  },
  battery: {
    charging: "battery-good-charging-symbolic",
    warning: "battery-empty-symbolic",
  },
  notifications: {
    silent: "notifications-disabled-symbolic",
    message: "chat-message-new-symbolic",
    noisy: "preferences-system-notifications-symbolic",
  },
  trash: {
    full: "user-trash-full-symbolic",
    empty: "user-trash-symbolic",
  },
  recorder: {
    recording: "media-record-symbolic",
  },
}
