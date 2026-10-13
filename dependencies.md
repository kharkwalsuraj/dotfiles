# Dependencies
Packages, themes, fonts, and services used in my **Arch Linux Btw**. Use this list as a reference for your distribution and package manager.

## Core System
- `niri` — Wayland compositor.
- `xwayland-satellite` — X11 application compatibility.
- `wl-clipboard` — Wayland clipboard utilities.
- `brightnessctl` — Screen brightness control.
- `playerctl` — Media playback control.
- `swayidle` — Idle and timeout management.
- `wlsunset` — Night light and color temperature adjustment.
- `awww` — Wallpaper management.

## Desktop Integration
- `xdg-utils` — Default applications and file associations.
- `xdg-desktop-portal` — Desktop portal interface for applications.
- `xdg-desktop-portal-gtk` — Provides basic desktop portal functionality.
- `xdg-desktop-portal-gnome` — Provides screencasting and Nautilus file picker integration.
- `phylax-git` — Graphical authentication prompts.
- `nautilus` — GNOME file manager.
- `tuned` — System performance tuning and power profiles.

## Theming and Appearance
- `matugen-git` — Generates color schemes from wallpapers.
- `python-materialyoucolor3` — Converts Matugen colors into terminal ANSI colors.
- `darkly-bin` — Qt application theme.
- `adw-gtk-theme` — GTK application theme.
- [Colloid icon theme](https://github.com/vinceliuice/Colloid-icon-theme) — Application icons.
- `bibata-cursor-theme-bin` — Mouse cursor theme.

## Fonts
- `noto-fonts` — General text font coverage.
- `noto-fonts-cjk` — Chinese, Japanese, and Korean fonts.
- `noto-fonts-emoji` — Emoji support.
- `ttf-ibm-plex` — IBM Plex font family.
- `ttf-google-sans-flex-variable` — Google Sans Flex font.
- `ttf-nerd-fonts-symbols-mono` — Terminal and prompt symbols.

## Terminal and CLI Tools
- `kitty` — Terminal emulator.
- `fish` — Interactive shell.
- `starship` — Customizable shell prompt.
- `neovim` — Text editor.
- `fzf` — Fuzzy finder used for Kitty tab switching.
- `unzip` — Extracts ZIP archives.
- `imagemagick` — Image processing and backdrop blur generation.

<details>
<summary>Optional Dependencies</summary>

## Images, Video, and Media
- `loupe` — Image viewer.
- `showtime` — Video player.
- `gst-plugins-base` — Required by Showtime for basic media playback.
- `gst-plugins-good` — Provides common media formats for Showtime.
- `gst-plugins-bad` — Provides additional media formats and features for Showtime.
- `gst-plugins-ugly` — Provides additional codecs for Showtime.
- `gst-libav` — Provides FFmpeg-based codec support for Showtime.

## Audio, Networking, and Bluetooth
- `pipewire` — Audio and multimedia server.
- `pipewire-pulse` — PulseAudio compatibility layer for PipeWire.
- `wireplumber` — PipeWire session and device manager.
- `networkmanager` — Network connection management.
- `bluez` — Bluetooth protocol stack.
- `bluez-utils` — Bluetooth command-line utilities.

## Services and Setup

Enable only the services you need.

- **PipeWire:** Enable `pipewire`, `pipewire-pulse`, and `wireplumber` as user services.
- **NetworkManager:** Enable the `NetworkManager` system service.
- **Bluetooth:** Enable the `bluetooth` system service if needed.
- **Tuned:** Use `tuned-adm list` to list profiles, `tuned-adm active` to check the active profile, and `sudo tuned-adm profile <profile>` to select one. Use `throughput-performance` for performance-focused workloads.
- **Font cache:** Refresh installed fonts with `fc-cache -fv` if needed.

</details>
