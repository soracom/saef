#!/usr/bin/env python3
"""
Screenshot annotation helper (adapted from soracom/user-doc-generator).
Adds arrows, numbered markers, text, rectangles, highlights, and blur blocks.
"""

import math
from pathlib import Path
from typing import Tuple
from PIL import Image, ImageDraw, ImageFont, ImageFilter


class ScreenshotAnnotator:
    """Annotate screenshots with various visual elements."""

    def __init__(self, image_path: str):
        self.image = Image.open(image_path).convert("RGBA")
        self.overlay = Image.new("RGBA", self.image.size, (255, 255, 255, 0))
        self.draw = ImageDraw.Draw(self.overlay)

    def add_arrow(
        self,
        start: Tuple[int, int],
        end: Tuple[int, int],
        color: str = "red",
        width: int = 3,
        arrow_size: int = 15,
    ):
        self.draw.line([start, end], fill=color, width=width)
        angle = math.atan2(end[1] - start[1], end[0] - start[0])
        arrow_angle = math.pi / 6
        left_x = end[0] - arrow_size * math.cos(angle - arrow_angle)
        left_y = end[1] - arrow_size * math.sin(angle - arrow_angle)
        right_x = end[0] - arrow_size * math.cos(angle + arrow_angle)
        right_y = end[1] - arrow_size * math.sin(angle + arrow_angle)
        self.draw.polygon([(end[0], end[1]), (left_x, left_y), (right_x, right_y)], fill=color)

    def add_numbered_marker(
        self,
        position: Tuple[int, int],
        number: int,
        color: str = "red",
        size: int = 30,
    ):
        left = position[0] - size // 2
        top = position[1] - size // 2
        right = position[0] + size // 2
        bottom = position[1] + size // 2

        self.draw.ellipse([(left, top), (right, bottom)], fill=color, outline=color)
        font = _load_font(size // 2)

        text = str(number)
        bbox = self.draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        text_position = (
            position[0] - text_width // 2,
            position[1] - text_height // 2 - 2,
        )
        self.draw.text(text_position, text, fill="white", font=font)

    def add_text(
        self,
        position: Tuple[int, int],
        text: str,
        color: str = "red",
        font_size: int = 20,
        background: bool = True,
    ):
        font = _load_font(font_size)
        if background:
            bbox = self.draw.textbbox(position, text, font=font)
            padding = 5
            bg_box = [
                bbox[0] - padding,
                bbox[1] - padding,
                bbox[2] + padding,
                bbox[3] + padding,
            ]
            self.draw.rectangle(bg_box, fill=(255, 255, 255, 220))
        self.draw.text(position, text, fill=color, font=font)

    def add_rectangle(
        self,
        top_left: Tuple[int, int],
        bottom_right: Tuple[int, int],
        color: str = "red",
        width: int = 3,
    ):
        self.draw.rectangle([top_left, bottom_right], outline=color, width=width)

    def add_highlight(
        self,
        top_left: Tuple[int, int],
        bottom_right: Tuple[int, int],
        color: str = "yellow",
        opacity: int = 100,
    ):
        color_map = {
            "yellow": (255, 255, 0),
            "red": (255, 0, 0),
            "green": (0, 255, 0),
            "blue": (0, 0, 255),
        }
        rgb = color_map.get(color, (255, 255, 0))
        rgba = rgb + (opacity,)
        self.draw.rectangle([top_left, bottom_right], fill=rgba)

    def blur_area(
        self,
        top_left: Tuple[int, int],
        bottom_right: Tuple[int, int],
        blur_amount: int = 10,
    ):
        box = (top_left[0], top_left[1], bottom_right[0], bottom_right[1])
        region = self.image.crop(box)
        blurred = region.filter(ImageFilter.GaussianBlur(blur_amount))
        self.image.paste(blurred, box)

    def save(self, output_path: str):
        result = Image.alpha_composite(self.image, self.overlay)
        if output_path.lower().endswith((".jpg", ".jpeg")):
            result = result.convert("RGB")
        Path(output_path).parent.mkdir(parents=True, exist_ok=True)
        result.save(output_path)
        print(f"Saved annotated screenshot to: {output_path}")


def _load_font(size: int) -> ImageFont.FreeTypeFont:
    candidates = [
        "/System/Library/Fonts/ヒラギノ角ゴシック W3.ttc",
        "/System/Library/Fonts/Hiragino Sans GB.ttc",
        "/Library/Fonts/Arial Unicode.ttf",
        "/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc",
        "/usr/share/fonts/truetype/takao-gothic/TakaoGothic.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
    ]
    for font_path in candidates:
        try:
            return ImageFont.truetype(font_path, size)
        except (OSError, IOError):
            continue
    return ImageFont.load_default()


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Annotate screenshots.")
    parser.add_argument("input", help="Input image path")
    parser.add_argument(
        "--output",
        help="Output path (default: <input>_annotated.png)",
        default=None,
    )
    parser.add_argument("--marker", type=int, help="Add numbered marker at x,y", nargs=3, metavar=("NUMBER", "X", "Y"))
    args = parser.parse_args()

    annotator = ScreenshotAnnotator(args.input)
    if args.marker:
        number, x, y = args.marker
        annotator.add_numbered_marker((int(x), int(y)), int(number))
    output = args.output or args.input.replace(".png", "_annotated.png")
    annotator.save(output)


if __name__ == "__main__":
    main()

