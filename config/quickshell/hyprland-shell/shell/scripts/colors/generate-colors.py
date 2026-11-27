#!/usr/bin/env python3
"""Generate Material, ANSI16 and Base16 colors from an image."""

import argparse
import importlib
import json
import os
from pathlib import Path

from materialyoucolor.dynamiccolor.material_dynamic_colors import COLOR_NAMES, MaterialDynamicColors
from materialyoucolor.hct.hct import Hct
from materialyoucolor.quantize import QuantizeCelebi
from materialyoucolor.score.score import Score, ScoreOptions
from materialyoucolor.utils.math_utils import difference_degrees, rotation_direction, sanitize_degrees_double
from PIL import Image

# scheme name -> (module, class)
SCHEMES = {
    "tonal_spot": ("scheme_tonal_spot", "SchemeTonalSpot"),
    "vibrant": ("scheme_vibrant", "SchemeVibrant"),
    "expressive": ("scheme_expressive", "SchemeExpressive"),
    "neutral": ("scheme_neutral", "SchemeNeutral"),
    "monochrome": ("scheme_monochrome", "SchemeMonochrome"),
    "fidelity": ("scheme_fidelity", "SchemeFidelity"),
    "content": ("scheme_content", "SchemeContent"),
    "rainbow": ("scheme_rainbow", "SchemeRainbow"),
    "fruit_salad": ("scheme_fruit_salad", "SchemeFruitSalad"),
}

# chroma of the ANSI colors per scheme (default 48)
ANSI_CHROMA = {"monochrome": 0, "neutral": 28, "vibrant": 64}


def to_hex(hct: Hct) -> str:
    return f"#{hct.to_int() & 0xFFFFFF:06x}"


def harmonize(design_hue: float, source_hue: float) -> float:
    rotation = min(difference_degrees(design_hue, source_hue) * 0.6, 100)
    return sanitize_degrees_double(design_hue + rotation * rotation_direction(design_hue, source_hue))


def print_table(title: str, colors: dict[str, Hct]) -> None:
    width = max(len(name) for name in colors)
    print(f"\n== {title} ==")

    for name, hct in colors.items():
        argb = hct.to_int()
        swatch = f"\x1b[48;2;{(argb >> 16) & 255};{(argb >> 8) & 255};{argb & 255}m    \x1b[0m"
        print(f"{swatch} {name:<{width}}  {to_hex(hct)}  H{hct.hue:6.1f}  C{hct.chroma:6.1f}  T{hct.tone:6.1f}")


def extract_source(image_path: Path, scheme_name: str) -> Hct:
    with Image.open(image_path) as image:
        if image.format == "JPEG":
            image.draft("RGB", (256, 256))
        if image.format in ("GIF", "PNG", "WEBP") and getattr(image, "n_frames", 1) > 1:
            image.seek(1)
        thumb = image.convert("RGBA")

    thumb.thumbnail((128, 128), Image.Resampling.BICUBIC)
    raw = thumb.tobytes()
    pixels = [(r, g, b) for r, g, b, a in zip(raw[0::4], raw[1::4], raw[2::4], raw[3::4]) if a >= 128]

    if not pixels:
        raise SystemExit("image has no visible pixels")

    quantized = QuantizeCelebi(pixels, 128)
    options = ScoreOptions(desired=1, filter=False) if scheme_name in ("monochrome", "neutral") else None
    return Hct.from_int(Score.score(quantized, options)[0])


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("image", type=Path, help="image to take the colors from")
    parser.add_argument("--mode", choices=["dark", "light"], default="dark")
    parser.add_argument("--scheme", choices=list(SCHEMES), default="neutral")
    parser.add_argument("-o", "--output", type=Path, help="output JSON file (required unless --dry-run)")
    parser.add_argument("--dry-run", action="store_true", help="print the colors, write nothing")
    args = parser.parse_args()

    if not args.image.is_file():
        parser.error(f"image not found: {args.image}")
    if not args.dry_run and args.output is None:
        parser.error("-o/--output is required unless --dry-run is used")

    dark = args.mode == "dark"
    source = extract_source(args.image, args.scheme)

    module, cls = SCHEMES[args.scheme]
    Scheme = getattr(importlib.import_module(f"materialyoucolor.scheme.{module}"), cls)
    scheme = Scheme(source, dark, 0.0)
    material = {name: getattr(MaterialDynamicColors, name).get_hct(scheme) for name in COLOR_NAMES}

    chroma = ANSI_CHROMA.get(args.scheme, 48)
    normal_tone, bright_tone = (67, 77) if dark else (46, 36)
    hues = {"red": 25, "green": 145, "yellow": 90, "blue": 265, "magenta": 325, "cyan": 210}

    def accent(hue: float, tone: float, c: float = chroma) -> Hct:
        return Hct.from_hct(harmonize(hue, source.hue), c, tone)

    ansi = {"black": material["surfaceContainer"]}
    ansi.update({name: accent(hue, normal_tone) for name, hue in hues.items()})
    ansi["white"] = material["onSurface"]
    ansi["brightBlack"] = material["outline"]
    ansi.update({f"bright{name.capitalize()}": accent(hue, bright_tone) for name, hue in hues.items()})
    ansi["brightWhite"] = material["inverseSurface"]

    on_surface = material["onSurface"]
    base16 = {
        "base00": material["surfaceContainer"],
        "base01": material["surfaceContainerHigh"],
        "base02": material["surfaceContainerHighest"],
        "base03": material["outline"],
        "base04": material["onSurfaceVariant"],
        "base05": on_surface,
        "base06": Hct.from_hct(on_surface.hue, on_surface.chroma, 94 if dark else 14),
        "base07": Hct.from_hct(on_surface.hue, on_surface.chroma, 98 if dark else 10),
        "base08": ansi["red"],
        "base09": accent(55, normal_tone),
        "base0A": ansi["yellow"],
        "base0B": ansi["green"],
        "base0C": ansi["cyan"],
        "base0D": ansi["blue"],
        "base0E": ansi["magenta"],
        "base0F": accent(40, normal_tone, chroma * 0.5),
    }

    if args.dry_run:
        print(f"image : {args.image.resolve()}")
        print(f"mode  : {args.mode}")
        print(f"scheme: {args.scheme}")
        print(f"source: {to_hex(source)}")
        print_table("Material colors", material)
        print_table("ANSI colors", ansi)
        print_table("Base16 colors", base16)
        return

    colors = {
        "material_colors": {k: to_hex(v) for k, v in material.items()},
        "ansi_colors": {k: to_hex(v) for k, v in ansi.items()},
        "base16_colors": {k: to_hex(v) for k, v in base16.items()},
        "mode": args.mode,
        "scheme": args.scheme,
    }

    args.output.parent.mkdir(parents=True, exist_ok=True)
    tmp = args.output.with_suffix(args.output.suffix + ".tmp")
    tmp.write_text(json.dumps(colors, indent=4))
    os.replace(tmp, args.output)


if __name__ == "__main__":
    main()
