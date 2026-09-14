# Unknown Horizons (Godot) — translations layout

This tree mirrors the **gettext** organization used in the original **Fife** translation tree (`po/`), under Godot’s usual **`locale/`** root:

| Directory       | Purpose (same idea as Fife `po/…`)                          |
|----------------|----------------------------------------------------------------|
| `uh/`          | Main game UI and core strings                                  |
| `voices/`      | Voice / VO-related catalogs                                    |
| `uh-server/`   | Multiplayer server strings (if/when used by this port)         |
| `scenarios/`   | Scenario / mission / tutorial copy                             |
| `terminology/` | Translator glossary (often Weblate-only; may not load in-game) |

## Files

- **`.pot`** — message templates (generated or maintained; not loaded as translations).
- **`.po`** — per-language catalogs; registered in Godot under **Project → Project Settings → Localization → Translations** when you are ready.

## Weblate

The classic Unknown Horizons project publishes translator-facing info from its Fife-era **`po/README.md`**. This Godot port will likely use a **separate Weblate component** (or project) pointing at **`locale/`** in this repository once catalogs exist.

## Contributing

Until Weblate is wired for this repo, edit **`locale/*/\*.po`** via merge request or coordinate with maintainers. After **`messages.pot`** (or per-domain `.pot`) files are committed, use standard **gettext** workflows (`msgmerge`, etc.) or Godot’s template generation to update languages.

## Domain migration matrix

- **Now:** `locale/uh/` (main game/client UI)
- **Next:** `locale/scenarios/`, `locale/voices/`
- **Later:** `locale/uh-server/` (when dedicated Godot server/admin text surface exists)
- **Defer:** `locale/terminology/` (translator glossary; often not runtime-loaded)

Regards, the Unknown Horizons community  
https://www.unknown-horizons.org
