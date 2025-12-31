import os
import shutil
from datetime import datetime

SOURCE_ROOT = r"C:\Programowanie\vibe\news_feed_analyzer"
TARGET_ROOT = r"C:\Programowanie\vibe\briefings-public"

PROFILES = ["general", "professional", "ksiegowy", "professional_tech_leadership"]

def sync_surfer():
    for profile in PROFILES:
        src_dir = os.path.join(SOURCE_ROOT, profile, "Briefings")
        if not os.path.isdir(src_dir):
            continue
        for fname in os.listdir(src_dir):
            if not fname.startswith("briefing_") or not fname.endswith(".md"):
                continue
            # Wyciągamy rok/miesiąc z nazwy lub z mtime pliku
            # Przyjmijmy, że format to briefing_YYYYMMDD_HHMMSS.md
            date_str = fname.split("_")[1]
            year = date_str[0:4]
            month = date_str[4:6]

            dst_dir = os.path.join(TARGET_ROOT, "surfer", profile, year, month)
            os.makedirs(dst_dir, exist_ok=True)

            src_path = os.path.join(src_dir, fname)
            dst_path = os.path.join(dst_dir, fname)

            if not os.path.exists(dst_path):
                shutil.copy2(src_path, dst_path)
                print(f"Skopiowano {src_path} -> {dst_path}")

if __name__ == "__main__":
    sync_surfer()