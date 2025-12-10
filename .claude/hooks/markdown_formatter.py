#!/usr/bin/env python3
"""
Markdown formatter for Claude Code output.
Fixes missing language tags and spacing issues while preserving code content.
"""
import json
import sys
import re
import os


def detect_language(code: str) -> str:
    """Best-effort language detection from code content."""
    s = code.strip()

    # JSON detection
    if re.search(r"^\s*[{\[]", s):
        try:
            json.loads(s)
            return "json"
        except Exception:
            pass

    # Python detection
    if re.search(r"^\s*def\s+\w+\s*\(", s, re.M) or re.search(
        r"^\s*(import|from)\s+\w+", s, re.M
    ):
        return "python"

    # JavaScript detection
    if re.search(r"\b(function\s+\w+\s*\(|const\s+\w+\s*=)", s) or re.search(
        r"=>|console\.(log|error)", s
    ):
        return "javascript"

    # Bash detection
    if re.search(r"^#!.*\b(bash|sh)\b", s, re.M) or re.search(
        r"\b(if|then|fi|for|in|do|done)\b", s
    ):
        return "bash"

    # SQL detection
    if re.search(r"\b(SELECT|INSERT|UPDATE|DELETE|CREATE)\s+", s, re.I):
        return "sql"

    return "text"


def format_markdown(content: str) -> str:
    """Format markdown content with language detection."""

    def add_lang_to_fence(match):
        indent, info, body, closing = match.groups()
        if not info.strip():
            lang = detect_language(body)
            return f"{indent}```{lang}\n{body}{closing}\n"
        return match.group(0)

    fence_pattern = r"(?ms)^([ \t]{0,3})```([^\n]*)\n(.*?)(\n\1```)\s*$"
    content = re.sub(fence_pattern, add_lang_to_fence, content)

    # Fix excessive blank lines (outside code fences)
    content = re.sub(r"\n{3,}", "\n\n", content)

    return content.rstrip() + "\n"


def main():
    input_data = None
    try:
        raw_input = sys.stdin.read()
        if not raw_input.strip():
            return  # No input, exit gracefully

        input_data = json.loads(raw_input)

        # Handle both possible input structures
        tool_input = input_data.get("tool_input", {})
        file_path = tool_input.get("file_path", "") or tool_input.get("path", "")

        if not file_path or not file_path.endswith((".md", ".mdx")):
            return

        if os.path.exists(file_path):
            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read()

            formatted = format_markdown(content)

            if formatted != content:
                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(formatted)
                print(f"✓ Fixed markdown formatting in {file_path}")

    except json.JSONDecodeError as e:
        # Silently ignore JSON errors - might be empty input
        pass
    except Exception as e:  # pragma: no cover - hook fallback
        # Don't exit with error code - just log and continue
        print(f"markdown_formatter warning: {e}", file=sys.stderr)


if __name__ == "__main__":
    main()

