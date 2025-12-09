cd C:\Programowanie\vibe\briefings-public

python sync_surfer.py        # skopiuj nowe md z news_feed_analyzer
python generate_indexes.py   # zaktualizuj index.json

git status
git add .
git commit -m "Update briefings for <data>"
git push