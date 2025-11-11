# Convert exported RocketChat Messages (JSON format)
# into Markdown (suitable for inclusion in e.g. a Git issue)
#

import json
import argparse
from datetime import datetime
from pathlib import Path


def format_message(msg):
    """Format a single Rocket.Chat message as Markdown."""
    user = msg.get("u", {}).get("username", "unknown")
    text = msg.get("msg", "")
    timestamp = msg.get("ts", "")
    try:
        ts = datetime.fromisoformat(timestamp.replace("Z", "+00:00"))
        ts_str = ts.strftime("%Y-%m-%d %H:%M")
    except Exception:
        ts_str = timestamp
    return f"> **{user}** ({ts_str}): {text}"


def main():
    parser = argparse.ArgumentParser(
        description="Convert a Rocket.Chat JSON export to GitLab issue Markdown."
    )
    parser.add_argument(
        "input_file",
        help="Path to the Rocket.Chat JSON export file (e.g., messages.json)"
    )
    parser.add_argument(
        "-o", "--output",
        help="Optional output Markdown file (default: <input_name>.md)"
    )

    args = parser.parse_args()
    input_path = Path(args.input_file)
    output_path = Path(
        args.output) if args.output else input_path.with_suffix(".md")

    # Load the JSON data
    with open(input_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    messages = data.get("messages", [])
    messages.sort(key=lambda x: x.get("ts", ""))  # ensure chronological order

    markdown_lines = [
        "# 💬 Rocket.Chat Discussion Export",
        "",
        f"_Total messages: {len(messages)}_",
        "",
        "---",
        ""
    ]

    for msg in messages:
        markdown_lines.append(format_message(msg))
        markdown_lines.append("")  # blank line between messages

    with open(output_path, "w", encoding="utf-8") as f:
        f.write("\n".join(markdown_lines))

    print(f"✅ Exported {len(messages)} messages to {output_path}")


if __name__ == "__main__":
    main()
