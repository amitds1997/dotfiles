import GLib from "gi://GLib?version=2.0"
import { Stream } from "types/service/audio"

/**
 * Retrieves an icon name based on the volume level of the provided audio stream.
 *
 * @param stream The audio stream object for which to retrieve the icon.
 * @param isMicrophone Is the audio stream a microphone stream
 * @returns The path of the icon corresponding to the volume level of the stream,
 * or the muted icon if the stream is muted.
 */
export function getStreamIcon(stream: Stream, isMicrophone: boolean) {
  const { muted, low, medium, high, overamplified } = isMicrophone
    ? icons.audio.microphone
    : icons.audio.speaker
  const cons = [
    [101, overamplified],
    [67, high],
    [34, medium],
    [1, low],
    [0, muted],
  ] as const
  const icon = cons.find(([n]) => n <= stream.volume * 100)?.[1] || ""
  return stream.is_muted ? muted : icon
}

/**
 * Retrieves icon path given the icon name, with optional fallback icon
 * @param name Name of the icon to retrieve
 * @param [fallback=icons.missing] Fallback icon name or path
 * @return Name/path of the icon found
 */
export function getIcon(name: string | null, fallback = icons.missing): string {
  if (!name) {
    return fallback || ""
  }

  if (GLib.file_test(name, GLib.FileTest.EXISTS)) {
    return name
  }

  const icon = substituteIcons[name] || name
  if (Utils.lookUpIcon(icon)) {
    return icon
  }

  console.debug(
    `no icon substitute "${icon}" for "${name}", using fallback: "${fallback}"`,
  )
  return fallback
}

export const substituteIcons = {
  microphone: {
    "audio-headset-analog-usb": "audio-headset-symbolic",
    "audio-headset-bluetooth": "audio-headphones-symbolic",
    "audio-card-analog-usb": "audio-input-microphone-symbolic",
    "audio-card-analog-pci": "audio-input-microphone-symbolic",
    "audio-card-analog": "audio-input-microphone-symbolic",
    "camera-web-analog-usb": "camera-web-symbolic",
  },
  speaker: {
    "audio-headset-bluetooth": "audio-headphones-symbolic",
    "audio-card-analog-usb": "audio-speakers-symbolic",
    "audio-card-analog-pci": "audio-speakers-symbolic",
    "audio-card-analog": "audio-speakers-symbolic",
    "audio-headset-analog-usb": "audio-headset-symbolic",
  },
}

export const icons = {
  launcher: {
    search: "system-search-symbolic",
    utility: "applications-utilities-symbolic",
    system: "emblem-system-symbolic",
    education: "applications-science-symbolic",
    development: "applications-engineering-symbolic",
    network: "network-wired-symbolic",
    office: "x-office-document-symbolic",
    game: "applications-games-symbolic",
    multimedia: "applications-multimedia-symbolic",
  },
  trash: {
    full: "user-trash-full-symbolic",
    empty: "user-trash-symbolic",
  },
  ui: {
    search: "system-search-symbolic",
    colorpicker: "color-select-symbolic",
    settings: "emblem-system-symbolic",
    arrow: {
      right: "pan-end-symbolic",
      left: "pan-start-symbolic",
      down: "pan-down-symbolic",
      up: "pan-up-symbolic",
    },
    tick: "object-select-symbolic",
  },
  notifications: {
    noisy: "user-available-symbolic",
    silent: "notifications-disabled-symbolic",
    critical: "messagebox_critical-symbolic",
    chat: "user-available-symbolic",
    close: "window-close-symbolic",
  },
  missing: "image-missing-symbolic",
  brightness: {
    indicator: "display-brightness-symbolic",
    keyboard: "keyboard-brightness-symbolic",
    screen: "display-brightness-symbolic",
  },
  fallback: {
    executable: "application-x-executable-symbolic",
    notification: "dialog-information-symbolic",
    audio: "audio-x-generic-symbolic",
    video: "video-x-generic-symbolic",
    network: "network-transmit-receive-symbolic",
  },
  mpris: {
    fallback: "audio-x-generic-symbolic",
    shuffle: {
      enabled: "media-playlist-shuffle-symbolic",
      disabled: "media-playlist-no-shuffle-symbolic",
    },
    loop: {
      none: "media-playlist-no-repeat-symbolic",
      track: "media-playlist-repeat-song-symbolic",
      playlist: "media-playlist-repeat-symbolic",
    },
    playing: "media-playback-pause-symbolic",
    paused: "media-playback-start-symbolic",
    stopped: "media-playback-stop-symbolic",
    prev: "media-skip-backward-symbolic",
    next: "media-skip-forward-symbolic",
  },
  audio: {
    microphone: {
      muted: "microphone-sensitivity-muted-symbolic",
      unmuted: "audio-input-microphone-symbolic",
      low: "microphone-sensitivity-low-symbolic",
      medium: "microphone-sensitivity-medium-symbolic",
      high: "microphone-sensitivity-high-symbolic",
      overamplified: "microphone-sensitivity-high-symbolic",
    },
    speaker: {
      muted: "audio-volume-muted-symbolic",
      unmuted: "audio-speakers-symbolic",
      low: "audio-volume-low-symbolic",
      medium: "audio-volume-medium-symbolic",
      high: "audio-volume-high-symbolic",
      overamplified: "audio-volume-overamplified-symbolic",
    },
    type: {
      headset: "audio-headphones-symbolic",
      speaker: "audio-speakers-symbolic",
      card: "audio-card-symbolic",
    },
    mixer: "sound-mixer",
  },
  bluetooth: {
    enabled: "bluetooth-active-symbolic",
    disabled: "bluetooth-disabled-symbolic",
    scan: "view-refresh-symbolic",
  },
  powermenu: {
    hibernate: "night-light-symbolic",
    lock: "system-lock-screen-symbolic",
    logout: "system-log-out-symbolic",
    reboot: "system-reboot-symbolic",
    shutdown: "system-shutdown-symbolic",
    suspend: "media-playback-pause-symbolic",
    sleep: "weather-clear-night-symbolic",
  },
  screenshot: "applets-screenshooter-symbolic",
  recorder: {
    recording: "media-record-symbolic",
    stop: "media-playback-stop-symbolic",
  },
  theme: {
    dark: "dark-mode-symbolic",
    light: "light-mode-symbolic",
  },
  network: {
    error: "network-offline-symbolic",
    ap: "network-wireless-no-route-symbolic",
    selected: "object-select-symbolic",
    scan: "view-refresh-symbolic",
  },
}
