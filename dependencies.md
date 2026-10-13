# Dependencies
Packages, themes, fonts, and services used in my **Arch Linux** Niri setup.
Use this file as a reference for your Linux distribution and package manager.

## Core System
- `niri` — Wayland compositor.
- `xwayland-satellite` — X11 application support.
- `wl-clipboard` — Wayland clipboard tools.
- `brightnessctl` — Brightness control.
- `playerctl` — Media player controls.
- `swayidle` — Idle management for Wayland.
- `wlsunset` — Night light and color temperature adjustment.
- `awww` — Wallpaper daemon and transition effects.

## Desktop Integration
- `xdg-utils` — File opening, MIME associations, and default application management.
- `xdg-desktop-portal` — Desktop integration for applications.
- `xdg-desktop-portal-gtk` — GTK portal backend.
- `xdg-desktop-portal-gnome` — GNOME portal backend, including screencast support.
- `polkit-gnome` — Graphical authentication for privileged actions.
- `nautilus` — GNOME file manager.
- `tuned` — System performance tuning and power profiles.

## Theming and Appearance
- `matugen-git` — Generates colors from wallpapers.
- `python-materialyoucolor3` — Converts Matugen colors to terminal ANSI colors.
- `darkly-bin` — Qt application theme.
- `adw-gtk-theme` — GTK application theme.
- [Colloid icon theme](https://github.com/vinceliuice/Colloid-icon-theme) — Application icons.
- `bibata-cursor-theme-bin` — Cursor theme.

## Fonts
- `noto-fonts` — General text fonts.
- `noto-fonts-cjk` — Chinese, Japanese, and Korean fonts.
- `noto-fonts-emoji` — Emoji fonts.
- `ttf-ibm-plex` — IBM Plex fonts.
- `ttf-google-sans-flex-variable` — Google Sans Flex font.
- `ttf-nerd-fonts-symbols-mono` — Terminal and prompt symbols.

## Terminal and Cli tools
- `kitty` — Terminal emulator.
- `fish` — Shell.
- `starship` — Shell prompt.
- `neovim` — Text editor.
- `yazi` — Terminal file manager.
- `fzf` — Fuzzy finder.
- `zoxide` — Directory navigation.
- `jq` — JSON processing.
- `ripgrep` — Fast text search.
- `fd` — Fast file search.
- `unzip` — ZIP extraction.
- `7zip` — Archive support.
- `imagemagick` — Image processing.
- `icoutils` — Icon file support.
- `libappimage` — AppImage support.
- `ffmpeg` — Media processing and format support.
- `resvg` — SVG rendering.
- `taglib` — Audio metadata support.
- `poppler` — PDF rendering and support.

## Images, Video, and Media
- `loupe` — GNOME image viewer.
- `showtime` — GNOME video player.
- `gst-plugins-base` — Basic GStreamer playback support.
- `gst-plugins-good` — Common media formats.
- `gst-plugins-bad` — Additional codecs and media features.
- `gst-plugins-ugly` — Additional codecs.
- `gst-libav` — FFmpeg-based media format support.

## Audio, Networking, and Bluetooth
- `pipewire` — Audio and multimedia server.
- `pipewire-pulse` — PulseAudio compatibility.
- `wireplumber` — PipeWire session manager.
- `networkmanager` — Network management.
- `bluez` — Bluetooth protocol stack.
- `bluez-utils` — Bluetooth command-line tools.


## Services and Setup
Enable the services you use.
- **PipeWire:** Enable `pipewire`, `pipewire-pulse`, and `wireplumber` as user services.
- **NetworkManager:** Enable the `NetworkManager` system service.
- **Bluetooth:** Enable the `bluetooth` system service if needed.
- **Tuned:** Use `tuned-adm list` to view profiles, `tuned-adm active` to check the active profile, and `sudo tuned-adm profile <profile>` to select one. Use `throughput-performance` for performance-focused workloads.
Refresh the font cache if needed: `fc-cache -fv`
