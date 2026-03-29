---
name: agent-browser
description: Browser automation for agents via the `agent-browser` CLI (Playwright-backed). Navigate URLs, snapshot page elements, click, fill, scroll, and extract content. Use when: visiting web pages, filling forms, scraping dynamic content, or any browser interaction task. NOT for: static HTML fetching (use web_fetch instead).
metadata:
  {
    "openclaw":
      {
        "emoji": "🌐",
        "requires": { "bins": ["agent-browser"] },
        "binPaths": ["~/.local/bin"],
      },
  }
---

# agent-browser

Browser automation via the `agent-browser` CLI (Playwright + Chrome).

## Prerequisites

Installed at `~/.local/bin/agent-browser` (v0.21.0). Chrome at `~/.agent-browser/browsers/`.

Add to PATH if needed:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Core workflow

```bash
# 1. Navigate
agent-browser open https://example.com

# 2. Snapshot interactive elements (use this to find refs like @e1, @e2)
agent-browser snapshot -i

# 3. Interact using refs
agent-browser click @e1
agent-browser fill @e2 "search text"
agent-browser press Enter

# 4. Re-snapshot after navigation
agent-browser snapshot -i

# 5. Close when done
agent-browser close
```

## Common commands

### Navigation
```bash
agent-browser open <url>     # Navigate to URL
agent-browser back           # Go back
agent-browser reload         # Reload page
agent-browser close          # Close browser
```

### Snapshot (page analysis)
```bash
agent-browser snapshot -i    # Interactive elements only (recommended)
agent-browser snapshot       # Full accessibility tree
agent-browser snapshot -c    # Compact output
agent-browser snapshot -s "#main"  # Scope to CSS selector
```

### Interactions (use @refs from snapshot)
```bash
agent-browser click @e1           # Click element
agent-browser fill @e2 "text"     # Type in field
agent-browser press Enter         # Press key
agent-browser scroll down 500     # Scroll page
agent-browser get text @e1        # Get element text
agent-browser screenshot          # Take screenshot
```

## For Ford (image/design research)

Useful for:
- Visiting design reference sites (Dribbble, Behance, Figma community)
- Scraping color palettes or design tokens from live sites
- Navigating Google AI Studio to manage API keys

```bash
agent-browser open https://aistudio.google.com
agent-browser snapshot -i
```
