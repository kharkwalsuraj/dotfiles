#!/usr/bin/env python3

import argparse
import json
import math
import os
from pathlib import Path

from materialyoucolor.hct import Hct
from materialyoucolor.utils.color_utils import argb_from_rgb, rgba_from_argb
from materialyoucolor.utils.math_utils import sanitize_degrees_double, difference_degrees, rotation_direction


HOME = Path.home()
XDG_CONFIG_HOME = Path(os.environ.get("XDG_CONFIG_HOME", HOME / ".config")).expanduser()
XDG_STATE_HOME = Path(os.environ.get("XDG_STATE_HOME", HOME / ".local/state")).expanduser()

MATERIAL_COLORS_PATH = XDG_STATE_HOME / "matugen/colors.json"
ANSI_OUTPUT_PATH = XDG_STATE_HOME / "matugen/ansi.json"
ANSI_OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)

BASE_ANSI_PALETTES = {
    "dark": {"term0": "#282828", "term1": "#CC241D", "term2": "#98971A", "term3": "#D79921", "term4": "#458588", "term5": "#B16286", "term6": "#689D6A", "term7": "#A89984", "term8": "#928374", "term9": "#FB4934", "term10": "#B8BB26", "term11": "#FABD2F", "term12": "#83A598", "term13": "#D3869B", "term14": "#8EC07C", "term15": "#EBDBB2"},
    "light": {"term0": "#FDF9F3", "term1": "#FF6188", "term2": "#A9DC76", "term3": "#FC9867", "term4": "#FFD866", "term5": "#F47FD4", "term6": "#78DCE8", "term7": "#333034", "term8": "#121212", "term9": "#FF6188", "term10": "#A9DC76", "term11": "#FC9867", "term12": "#FFD866", "term13": "#F47FD4", "term14": "#78DCE8", "term15": "#333034"},
}


MONOCHROME_PALETTES = {
    "dark": {"term0": "#181818", "term1": "#3A3A3A", "term2": "#4A4A4A", "term3": "#5A5A5A", "term4": "#6A6A6A", "term5": "#7A7A7A", "term6": "#8A8A8A", "term7": "#B0B0B0", "term8": "#303030", "term9": "#4A4A4A", "term10": "#5A5A5A", "term11": "#6A6A6A", "term12": "#7A7A7A", "term13": "#8A8A8A", "term14": "#9A9A9A", "term15": "#E0E0E0"},
    "light": {"term0": "#F2F2F2", "term1": "#D0D0D0", "term2": "#C0C0C0", "term3": "#B0B0B0", "term4": "#A0A0A0", "term5": "#909090", "term6": "#808080", "term7": "#505050", "term8": "#E0E0E0", "term9": "#C0C0C0", "term10": "#B0B0B0", "term11": "#A0A0A0", "term12": "#909090", "term13": "#808080", "term14": "#707070", "term15": "#202020"},
}


parser = argparse.ArgumentParser(
    description="Generate ANSI terminal colors from Matugen Material colors.",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)
parser.add_argument("--mode", choices=["dark", "light"], default="dark", help="Terminal color mode.")
parser.add_argument("--harmony", type=float, default=0.6, help="Amount of hue shift toward the source color (0-1).")
parser.add_argument("--harmonize_threshold", type=float, default=100.0, help="Maximum hue rotation in degrees (0-180).")
parser.add_argument("--term_fg_boost", type=float, default=0.35, help="Foreground tone adjustment relative to the background.")
parser.add_argument("--blend_bg_fg", action="store_true", help="Blend terminal background and foreground toward Material surface colors.")
parser.add_argument("--scheme", choices=["SchemeTonalSpot", "SchemeNeutral", "SchemeVibrant", "SchemeExpressive", "SchemeFidelity", "SchemeContent", "SchemeRainbow", "SchemeFruitSalad", "SchemeMonochrome", "SchemeSmart"], default="SchemeNeutral", help="Material color scheme to use.")
args = parser.parse_args()


def argb_to_hex(argb_color: int) -> str:
    red, green, blue, _ = rgba_from_argb(argb_color)
    return f"#{round(red):02X}{round(green):02X}{round(blue):02X}"


def hex_to_argb(hex_color: str) -> int:
    hex_color = hex_color.lstrip("#")
    if len(hex_color) != 6:
        raise ValueError(f"Invalid hex color: #{hex_color}")
    return argb_from_rgb(int(hex_color[0:2], 16), int(hex_color[2:4], 16), int(hex_color[4:6], 16))


def harmonize(design_color: int, source_color: int, threshold: float = 35.0, harmony: float = 0.5) -> int:
    design_hct = Hct.from_int(design_color)
    source_hct = Hct.from_int(source_color)
    hue_difference = difference_degrees(design_hct.hue, source_hct.hue)
    hue_rotation = min(hue_difference * harmony, threshold)
    harmonized_hue = sanitize_degrees_double(design_hct.hue + hue_rotation * rotation_direction(design_hct.hue, source_hct.hue))
    return Hct.from_hct(harmonized_hue, design_hct.chroma, design_hct.tone).to_int()


def boost_chroma_tone(argb_color: int, chroma_multiplier: float = 1.0, tone_multiplier: float = 1.0) -> int:
    color_hct = Hct.from_int(argb_color)
    return Hct.from_hct(color_hct.hue, color_hct.chroma * chroma_multiplier, color_hct.tone * tone_multiplier).to_int()


if args.scheme == "SchemeMonochrome":
    ansi_colors = MONOCHROME_PALETTES[args.mode]

else:

    with MATERIAL_COLORS_PATH.open("r", encoding="utf-8") as file:
        material_colors = json.load(file)

    terminal_palette = BASE_ANSI_PALETTES[args.mode]
    source_color = hex_to_argb(material_colors["source_color"])
    ansi_colors = {}

    for terminal_name, base_hex_color in terminal_palette.items():
        if args.blend_bg_fg and terminal_name == "term0":
            generated_color = boost_chroma_tone(hex_to_argb(material_colors["surface_container_low"]), 1.2, 0.95)

        elif args.blend_bg_fg and terminal_name == "term15":
            generated_color = boost_chroma_tone(hex_to_argb(material_colors["on_surface"]), 3.0, 1.0)

        else:
            generated_color = harmonize(hex_to_argb(base_hex_color), source_color, args.harmonize_threshold, args.harmony)
            generated_color = boost_chroma_tone(generated_color, 1.0, 1.0 + args.term_fg_boost * (1.0 if args.mode == "dark" else -1.0))

        ansi_colors[terminal_name] = argb_to_hex(generated_color)


with ANSI_OUTPUT_PATH.open("w", encoding="utf-8") as file:
    json.dump(ansi_colors, file, indent=4)
    file.write("\n")
