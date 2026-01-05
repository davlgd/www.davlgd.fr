#!/usr/bin/env python3
"""Génère la liste des billets pour index.html"""

import os
import re
import json
from pathlib import Path
from datetime import datetime

SCRIPT_DIR = Path(__file__).parent
SRC_DIR = SCRIPT_DIR.parent / "src"
TEMPLATE_FILE = SRC_DIR / "index.template.html"
OUTPUT_FILE = SRC_DIR / "index.html"

MONTHS_FR = [
    "", "janvier", "février", "mars", "avril", "mai", "juin",
    "juillet", "août", "septembre", "octobre", "novembre", "décembre"
]

def extract_post_data(filepath):
    """Extrait titre et date d'un fichier HTML"""
    filename = filepath.name

    if filename in ("index.html", "index.template.html"):
        return None

    content = filepath.read_text(encoding="utf-8")

    # Titre depuis <title>
    title_match = re.search(r"<title>([^<]+)</title>", content)
    title = title_match.group(1) if title_match else None

    # Date depuis JSON-LD datePublished
    date_match = re.search(r'"datePublished":\s*"([^"]+)"', content)
    date_str = None
    if date_match:
        date_str = date_match.group(1).split("T")[0]

    if not title or not date_str:
        return None

    # Décoder les entités HTML
    title = title.replace("&#x27;", "'").replace("&#39;", "'").replace("&quot;", '"').replace("&amp;", "&")

    return {
        "filename": filename,
        "title": title,
        "date": date_str
    }

def format_date_fr(date_str):
    """Formate une date ISO en français"""
    date = datetime.strptime(date_str, "%Y-%m-%d")
    return f"{date.day} {MONTHS_FR[date.month]} {date.year}"

def generate_post_html(post):
    """Génère le HTML pour un billet"""
    formatted_date = format_date_fr(post["date"])
    return f'''                    <li class="post-item">
                        <a href="{post['filename']}" class="post-link">
                            <span class="post-title">{post['title']}</span>
                            <span class="post-date">{formatted_date}</span>
                        </a>
                    </li>'''

def main():
    print("Extraction des billets...")

    # Collecter les billets
    posts = []
    for filepath in SRC_DIR.glob("*.html"):
        post = extract_post_data(filepath)
        if post:
            posts.append(post)

    # Trier par date décroissante
    posts.sort(key=lambda p: p["date"], reverse=True)

    print(f"Nombre de billets trouvés: {len(posts)}")

    # Générer le HTML
    posts_html = "\n".join(generate_post_html(post) for post in posts)

    for post in posts:
        print(f"  - {post['title']} ({format_date_fr(post['date'])})")

    # Lire le template et injecter
    template = TEMPLATE_FILE.read_text(encoding="utf-8")
    output = template.replace("<!-- POSTS_PLACEHOLDER -->", posts_html)

    # Écrire le fichier
    OUTPUT_FILE.write_text(output, encoding="utf-8")
    print(f"Index généré: {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
