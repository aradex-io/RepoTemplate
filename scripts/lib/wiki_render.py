#!/usr/bin/env python3
"""Render docs/ into GitHub-wiki pages.

Reads env: REPO (owner/repo), BRANCH (for blob links), OUT (wiki checkout dir).
Used by scripts/publish-wiki.sh. Single source of truth is docs/; nothing here
is committed to the code repo.
"""
import os
import re
import sys

REPO = os.environ["REPO"]
BRANCH = os.environ.get("BRANCH", "main")
OUT = os.environ["OUT"]
BLOB = f"https://github.com/{REPO}/blob/{BRANCH}"

# docs path (relative to repo root) -> wiki page slug (page title)
PAGES = {
    "docs/README.md": "Home",
    "docs/guide/plan-review.md": "Plan-Review",
    "docs/guide/version-control-and-changelog.md": "Version-Control-and-Changelog",
    "docs/guide/ci-cd-and-releases.md": "CI-CD-and-Releases",
    "docs/guide/branch-protection.md": "Branch-Protection",
    "docs/guide/scripts-reference.md": "Scripts-Reference",
    "docs/guide/agents-and-commands.md": "Agents-and-Commands",
    "docs/architecture/overview.md": "Architecture-Overview",
}

# Match the "](url)" target only, so link text containing brackets (e.g.
# `[`/release [bump]`](...)`) is handled correctly.
LINK = re.compile(r"\]\(([^)]+)\)")


def rewrite_url(src_path, url):
    if re.match(r"^[a-z]+://", url) or url.startswith(("mailto:", "#")):
        return url
    anchor = ""
    if "#" in url:
        url, anchor = url.split("#", 1)
        anchor = "#" + anchor
    if not url:  # pure anchor
        return anchor
    target = os.path.normpath(os.path.join(os.path.dirname(src_path), url))
    if target in PAGES:                       # another wiki page
        return PAGES[target] + anchor
    if os.path.exists(target):                # a repo file -> absolute blob link
        return f"{BLOB}/{target}{anchor}"
    return url + anchor                        # leave unknown links untouched


def render(src_path):
    text = open(src_path, encoding="utf-8").read()
    return LINK.sub(lambda m: f"]({rewrite_url(src_path, m.group(1))})", text)


SIDEBAR = """\
### 📖 RepoTemplate wiki

- [Home](Home)

**Guides**
- [Plan Review](Plan-Review)
- [Version Control & Changelog](Version-Control-and-Changelog)
- [CI/CD & Releases](CI-CD-and-Releases)
- [Branch Protection](Branch-Protection)
- [Scripts Reference](Scripts-Reference)
- [Agents & Commands](Agents-and-Commands)

- [Architecture Overview](Architecture-Overview)

---
_Generated from `docs/` — edit there, then run `scripts/publish-wiki.sh`._
"""

FOOTER = f"_Source of truth: [`docs/`]({BLOB}/docs) in [{REPO}](https://github.com/{REPO}). Do not edit wiki pages directly._\n"


def main():
    missing = [p for p in PAGES if not os.path.exists(p)]
    if missing:
        print(f"error: missing source docs: {missing}", file=sys.stderr)
        sys.exit(1)
    for src, slug in PAGES.items():
        open(os.path.join(OUT, f"{slug}.md"), "w", encoding="utf-8").write(render(src))
    open(os.path.join(OUT, "_Sidebar.md"), "w", encoding="utf-8").write(SIDEBAR)
    open(os.path.join(OUT, "_Footer.md"), "w", encoding="utf-8").write(FOOTER)
    print(f">> wrote {len(PAGES)} pages + _Sidebar + _Footer to {OUT}")


if __name__ == "__main__":
    main()
