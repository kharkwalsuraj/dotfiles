#!/usr/bin/env bash

set -Eeuo pipefail

# Settings
REPO_URL="https://github.com/kharkwalsuraj/dotfiles.git"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config.backup-$(date +%Y%m%d-%H%M%S)-$$"

# Output
info() {
    printf '\033[34m[INFO]\033[0m %s\n' "$*"
}

success() {
    printf '\033[32m[OK]\033[0m %s\n' "$*"
}

warn() {
    printf '\033[33m[WARN]\033[0m %s\n' "$*"
}

die() {
    printf '\033[31m[ERROR]\033[0m %s\n' "$*" >&2
    exit 1
}

confirm() {
    local answer
    read -r -p "$1 [y/N]: " answer
    [[ "$answer" =~ ^[Yy]$ ]]
}

# Check root
if [[ "$EUID" -eq 0 ]]; then
    die "Run this script as your normal user, without sudo."
fi

# Check distro
[[ -r /etc/os-release ]] || die "Cannot read /etc/os-release."

source /etc/os-release

if [[ "${ID:-}" != "arch" ]]; then
    printf '\nThis installer supports Arch Linux only.\n'
    printf 'For other distributions, follow the manual setup in the README.\n'
    exit 1
fi

success "Arch Linux detected."

# Check required commands
command -v sudo >/dev/null 2>&1 || die "sudo is required."
command -v pacman >/dev/null 2>&1 || die "pacman is required."

# Request sudo access
info "Requesting sudo authentication..."
sudo -v || die "Sudo authentication failed."

# Keep sudo access active
(
    while true; do
        sleep 50
        sudo -n -v || exit 1
    done
) &

SUDO_PID=$!

cleanup() {
    kill "$SUDO_PID" 2>/dev/null || true
}

trap cleanup EXIT

# Install Git if needed
if ! command -v git >/dev/null 2>&1; then
    sudo pacman -S --needed git ||
        die "Could not install Git."
fi

success "Git is available."

# Choose an AUR helper
printf '\nChoose an AUR helper:\n'

select choice in paru yay; do
    case "$choice" in
        paru|yay)
            AUR_HELPER="$choice"
            break
            ;;
        *)
            warn "Select 1 or 2."
            ;;
    esac
done

# Install the selected AUR helper
if ! command -v "$AUR_HELPER" >/dev/null 2>&1; then
    sudo pacman -S --needed base-devel ||
        die "Could not install base-devel."

    mkdir -p "$HOME/.cache"
    BUILD_DIR="$(mktemp -d "$HOME/.cache/${AUR_HELPER}-build.XXXXXX")"

    if ! git clone --depth 1 \
        "https://aur.archlinux.org/${AUR_HELPER}.git" \
        "$BUILD_DIR/$AUR_HELPER"; then
        rm -rf "$BUILD_DIR"
        die "Could not clone $AUR_HELPER."
    fi

    if ! (
        cd "$BUILD_DIR/$AUR_HELPER"
        makepkg -si
    ); then
        rm -rf "$BUILD_DIR"
        die "Could not install $AUR_HELPER."
    fi

    rm -rf "$BUILD_DIR"

    command -v "$AUR_HELPER" >/dev/null 2>&1 ||
        die "$AUR_HELPER was not found after installation."
fi

success "Using $AUR_HELPER."

# List dependencies
ITEMS=(
    "package|niri|Wayland compositor|Core"
    "package|xwayland-satellite|X11 application compatibility|Core"
    "package|wl-clipboard|Wayland clipboard utilities|Core"
    "package|brightnessctl|Screen brightness control|Core"
    "package|playerctl|Media playback control|Core"
    "package|swayidle|Idle and timeout management|Core"
    "package|wlsunset|Night light and color temperature|Core"
    "package|awww|Wallpaper management|Core"

    "package|xdg-utils|Default applications and file associations|Desktop"
    "package|xdg-desktop-portal|Desktop portal interface|Desktop"
    "package|xdg-desktop-portal-gtk|Basic desktop portal functionality|Desktop"
    "package|xdg-desktop-portal-gnome|Screencasting and Nautilus file picker|Desktop"
    "package|pantheon-polkit-agent|Graphical authentication prompts|Desktop"
    "package|nautilus|GNOME file manager|Desktop"
    "package|tuned|System performance tuning|Desktop"

    "package|matugen-git|Generate colors from wallpapers|Theming"
    "package|python-materialyoucolor3|Convert Material colors to terminal ANSI colors|Theming"
    "package|darkly-bin|Qt application theme|Theming"
    "package|adw-gtk-theme|GTK application theme|Theming"
    "colloid|Colloid icon theme|Install using the upstream installer|Theming"
    "package|bibata-cursor-theme-bin|Mouse cursor theme|Theming"

    "package|noto-fonts|General text font coverage|Fonts"
    "package|noto-fonts-cjk|Chinese Japanese and Korean fonts|Fonts"
    "package|noto-fonts-emoji|Emoji support|Fonts"
    "package|ttf-ibm-plex|IBM Plex font family|Fonts"
    "google-font|Google Sans Flex|Install from the official release|Fonts"
    "package|ttf-nerd-fonts-symbols-mono|Terminal and prompt symbols|Fonts"

    "package|kitty|Terminal emulator|CLI"
    "package|fish|Interactive shell|CLI"
    "package|starship|Customizable shell prompt|CLI"
    "package|neovim|Text editor|CLI"
    "package|fzf|Fuzzy finder|CLI"
    "package|unzip|ZIP archive extraction|CLI"
    "package|imagemagick|Image processing and backdrop blur|CLI"

    "package|loupe|Image viewer|Media"
    "package|showtime|Video player|Media"
    "package|gst-plugins-base|Basic GStreamer media playback|Media"
    "package|gst-plugins-good|Common media formats|Media"
    "package|gst-plugins-bad|Additional media formats and features|Media"
    "package|gst-plugins-ugly|Additional codecs|Media"
    "package|gst-libav|FFmpeg-based codec support|Media"

    "package|pipewire|Audio and multimedia server|Audio and networking"
    "package|pipewire-pulse|PulseAudio compatibility for PipeWire|Audio and networking"
    "package|wireplumber|PipeWire session and device manager|Audio and networking"
    "package|networkmanager|Network connection management|Audio and networking"
    "package|bluez|Bluetooth support|Audio and networking"
    "package|bluez-utils|Bluetooth command-line tools|Audio and networking"
)

# Show dependencies
printf '\nDependencies:\n\n'

for i in "${!ITEMS[@]}"; do
    IFS='|' read -r kind name description category <<< "${ITEMS[$i]}"

    printf '  %2d. [%-22s] %-34s %s\n' \
        "$((i + 1))" "$category" "$name" "$description"
done

# Ask which items to skip
printf '\nEnter numbers to skip, separated by spaces or commas.\n'
printf 'Ranges are supported, for example: 3-6 12-15\n'
printf 'Press Enter to install everything.\n\n'

read -r -p "Items to skip: " SKIP_INPUT
SKIP_INPUT="${SKIP_INPUT//,/ }"

SKIP_TOKENS=()

if [[ -n "$SKIP_INPUT" ]]; then
    read -r -a SKIP_TOKENS <<< "$SKIP_INPUT"
fi

declare -A SKIP=()

for token in "${SKIP_TOKENS[@]}"; do
    if [[ "$token" =~ ^([0-9]+)-([0-9]+)$ ]]; then
        start=$((10#${BASH_REMATCH[1]}))
        end=$((10#${BASH_REMATCH[2]}))

        (( start >= 1 && end <= ${#ITEMS[@]} && start <= end )) ||
            die "Invalid skip range: $token"

        for ((i = start; i <= end; i++)); do
            SKIP[$i]=1
        done

    elif [[ "$token" =~ ^[0-9]+$ ]]; then
        number=$((10#$token))

        (( number >= 1 && number <= ${#ITEMS[@]} )) ||
            die "Invalid item number: $token"

        SKIP[$number]=1
    else
        die "Invalid selection: $token"
    fi
done

# Prepare selected items
INSTALL_PACKAGES=()
SKIPPED_ITEMS=()
INSTALL_GOOGLE_FONT=false
INSTALL_COLLOID=false

for i in "${!ITEMS[@]}"; do
    number=$((i + 1))
    IFS='|' read -r kind name description category <<< "${ITEMS[$i]}"

    if [[ -n "${SKIP[$number]:-}" ]]; then
        SKIPPED_ITEMS+=("$name")
        continue
    fi

    case "$kind" in
        package)
            INSTALL_PACKAGES+=("$name")
            ;;
        google-font)
            INSTALL_GOOGLE_FONT=true
            ;;
        colloid)
            INSTALL_COLLOID=true
            ;;
    esac
done

# Confirm selection
printf '\nPackages selected: %d\n' "${#INSTALL_PACKAGES[@]}"

if [[ "$INSTALL_GOOGLE_FONT" == true ]]; then
    printf 'Google Sans Flex: selected\n'
fi

if [[ "$INSTALL_COLLOID" == true ]]; then
    printf 'Colloid icon theme: selected\n'
fi

if ((${#SKIPPED_ITEMS[@]})); then
    printf '\nSkipped items:\n'
    printf '  - %s\n' "${SKIPPED_ITEMS[@]}"
fi

confirm "Continue with installation?" ||
    die "Installation cancelled."

# Install packages
FAILED_ITEMS=()

for package in "${INSTALL_PACKAGES[@]}"; do
    printf '\n'
    info "Installing $package..."

    if "$AUR_HELPER" -S --needed "$package"; then
        success "$package is installed."
    else
        warn "Could not install $package."
        FAILED_ITEMS+=("$package")
    fi
done

# Install Google Sans Flex
install_google_sans_flex() {
    local work_dir
    local release_json
    local font_url
    local font_dir
    local font

    local -a font_files=()

    # Check download tools
    if ! command -v curl >/dev/null 2>&1; then
        sudo pacman -S --needed curl || return 1
    fi

    if ! command -v bsdtar >/dev/null 2>&1; then
        sudo pacman -S --needed libarchive || return 1
    fi

    work_dir="$(mktemp -d)"

    # Find the latest stable release
    if ! release_json="$(
        curl -fsSL \
            https://api.github.com/repos/googlefonts/googlesans-flex/releases/latest
    )"; then
        rm -rf "$work_dir"
        return 1
    fi

    font_url="$(
        printf '%s\n' "$release_json" |
            grep '"browser_download_url"' |
            grep -E 'GoogleSansFlex-v[0-9]+(\.[0-9]+)*\.zip"' |
            sed -E 's/.*"browser_download_url": "([^"]+)".*/\1/' |
            head -n 1
    )" || true

    if [[ -z "$font_url" ]]; then
        rm -rf "$work_dir"
        warn "Could not find the font archive in the latest release."
        return 1
    fi

    # Download and extract the font
    info "Downloading Google Sans Flex..."

    if ! curl -fL "$font_url" -o "$work_dir/font.zip"; then
        rm -rf "$work_dir"
        return 1
    fi

    mkdir -p "$work_dir/extracted"

    if ! bsdtar -xf "$work_dir/font.zip" -C "$work_dir/extracted"; then
        rm -rf "$work_dir"
        return 1
    fi

    mapfile -d '' font_files < <(
        find "$work_dir/extracted" -type f \
            \( -iname '*.ttf' -o -iname '*.otf' \) -print0
    )

    if ((${#font_files[@]} == 0)); then
        rm -rf "$work_dir"
        warn "No TTF or OTF font files were found in the archive."
        return 1
    fi

    # Install fonts for the current user
    font_dir="$HOME/.local/share/fonts/GoogleSansFlex"
    mkdir -p "$font_dir"

    for font in "${font_files[@]}"; do
        install -Dm644 "$font" "$font_dir/$(basename "$font")" || {
            rm -rf "$work_dir"
            return 1
        }
    done

    rm -rf "$work_dir"

    if command -v fc-cache >/dev/null 2>&1; then
        fc-cache -f "$font_dir" || warn "Could not refresh the font cache."
    fi

    success "Google Sans Flex installed."
}

if [[ "$INSTALL_GOOGLE_FONT" == true ]]; then
    if ! install_google_sans_flex; then
        warn "Google Sans Flex installation failed."
        FAILED_ITEMS+=("Google Sans Flex")
    fi
fi

# Install Colloid icons
install_colloid_icons() {
    local work_dir

    work_dir="$(mktemp -d)"

    info "Cloning Colloid icon theme..."

    if ! git clone --depth 1 \
        https://github.com/vinceliuice/Colloid-icon-theme.git \
        "$work_dir/Colloid-icon-theme"; then
        rm -rf "$work_dir"
        return 1
    fi

    info "Running the Colloid installer..."

    if ! (
        cd "$work_dir/Colloid-icon-theme"
        bash ./install.sh
    ); then
        rm -rf "$work_dir"
        return 1
    fi

    rm -rf "$work_dir"

    success "Colloid icon theme installed."
}

if [[ "$INSTALL_COLLOID" == true ]]; then
    if ! install_colloid_icons; then
        warn "Colloid icon theme installation failed."
        FAILED_ITEMS+=("Colloid icon theme")
    fi
fi

# Back up existing configuration
if [[ -e "$CONFIG_DIR" || -L "$CONFIG_DIR" ]]; then
    info "Backing up ~/.config..."

    mv "$CONFIG_DIR" "$BACKUP_DIR" ||
        die "Could not back up ~/.config."

    success "Backup created at $BACKUP_DIR"
fi

# Clone dotfiles
info "Cloning dotfiles into ~/.config..."

if git clone --depth 1 "$REPO_URL" "$CONFIG_DIR"; then
    success "Dotfiles cloned into ~/.config."
else
    rm -rf "$CONFIG_DIR"

    if [[ -e "$BACKUP_DIR" || -L "$BACKUP_DIR" ]]; then
        mv "$BACKUP_DIR" "$CONFIG_DIR" ||
            die "Clone failed and the original configuration could not be restored."

        warn "Restored the original ~/.config."
    fi

    die "Could not clone the dotfiles repository."
fi

# Configure optional services
printf '\nOptional services:\n'

if confirm "Enable NetworkManager?"; then
    sudo systemctl enable --now NetworkManager ||
        warn "Could not enable NetworkManager."
fi

if confirm "Enable Bluetooth?"; then
    sudo systemctl enable --now bluetooth ||
        warn "Could not enable Bluetooth."
fi

if confirm "Enable Tuned?"; then
    sudo systemctl enable --now tuned ||
        warn "Could not enable Tuned."

    if systemctl is-active --quiet tuned; then
        if confirm "Use the throughput-performance profile?"; then
            sudo tuned-adm profile throughput-performance ||
                warn "Could not set the Tuned profile."
        fi
    fi
fi

if confirm "Enable PipeWire user services?"; then
    systemctl --user enable --now \
        pipewire pipewire-pulse wireplumber ||
        warn "Could not enable all PipeWire services."
fi

# Refresh font cache
if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f || warn "Could not refresh the font cache."
fi

# Show result
printf '\nInstallation finished.\n'
printf 'Configuration: %s\n' "$CONFIG_DIR"

if [[ -e "$BACKUP_DIR" || -L "$BACKUP_DIR" ]]; then
    printf 'Backup: %s\n' "$BACKUP_DIR"
fi

if ((${#SKIPPED_ITEMS[@]})); then
    printf '\nSkipped items:\n'
    printf '  - %s\n' "${SKIPPED_ITEMS[@]}"
fi

if ((${#FAILED_ITEMS[@]})); then
    printf '\nItems that failed to install:\n'
    printf '  - %s\n' "${FAILED_ITEMS[@]}"
fi

printf '\nCheck the README for any remaining manual setup steps.\n'
