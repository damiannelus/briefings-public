import os
import json
from datetime import datetime

ROOT = r"C:\Programowanie\vibe\briefings-public"

SURFER_PROFILES = ["general", "professional", "ksiegowy", "professional_tech_leadership", "fintech", "KSA_venture_building"]
NUREK_PROFILES = ["general", "professional", "ksiegowy", "professional_tech_leadership", "fintech", "KSA_venture_building"]  # na razie pusta/dummy

def parse_created_at_from_filename(fname: str) -> str | None:
    # briefing_YYYYMMDD_HHMMSS.md -> "YYYY-MM-DD HH:MM:SS"
    try:
        base = os.path.splitext(fname)[0]
        _, ts = base.split("_", 1)
        dt = datetime.strptime(ts, "%Y%m%d_%H%M%S")
        return dt.strftime("%Y-%m-%d %H:%M:%S")
    except Exception:
        return None

def build_index(content_type: str, profile: str):
    base_dir = os.path.join(ROOT, content_type, profile)
    items = []
    if not os.path.isdir(base_dir):
        return

    for year in sorted(os.listdir(base_dir)):
        year_dir = os.path.join(base_dir, year)
        if not os.path.isdir(year_dir):
            continue
        for month in sorted(os.listdir(year_dir)):
            month_dir = os.path.join(year_dir, month)
            if not os.path.isdir(month_dir):
                continue
            for fname in sorted(os.listdir(month_dir)):
                if not fname.endswith(".md"):
                    continue
                rel_path = f"{year}/{month}/{fname}"
                created_at = parse_created_at_from_filename(fname)
                title = None
                # opcjonalnie: wczytaj pierwszą linię z pliku i użyj jako tytuł
                try:
                    with open(os.path.join(month_dir, fname), "r", encoding="utf-8") as f:
                        first_line = f.readline().strip()
                        if first_line.startswith("#"):
                            title = first_line.lstrip("#").strip()
                except Exception:
                    pass

                items.append({
                    "filename": rel_path,
                    "created_at": created_at,
                    "title": title or fname,
                    "slug": os.path.splitext(fname)[0].replace("_", "-")
                })

    items.sort(key=lambda x: (x["created_at"] or "", x["filename"]))
    index = {
        "profile": profile,
        "content_type": content_type,
        "items": items
    }

    index_path = os.path.join(base_dir, "index.json")
    with open(index_path, "w", encoding="utf-8") as f:
        json.dump(index, f, ensure_ascii=False, indent=2)
    print(f"Zapisano {index_path} ({len(items)} pozycji)")

def main():
    for p in SURFER_PROFILES:
        build_index("surfer", p)
    for p in NUREK_PROFILES:
        build_index("nurek", p)  # na razie zignoruje, jeśli brak katalogu

if __name__ == "__main__":
    main()