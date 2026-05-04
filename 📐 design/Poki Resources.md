---
type: reference
tags: [poki, sdk, monetization, tech]
---

# Poki Resources

Quick-reference for Poki integration. SDK + monetization are the critical path.

Source: [sdk.poki.com/new-requirements.html](https://sdk.poki.com/new-requirements.html)

---

## Hard Requirements

> [!WARNING] These are submission blockers — get them wrong and the game won't be accepted.

**Resolution & Display**
- Aspect ratio must be **16:9**. Target resolutions: `640×360`, `836×470`, or `1031×580`
- Must fill the entire screen on desktop, mobile, and tablet — no black bars
- Must support both landscape and portrait where applicable

**File Size**
- Initial download **under 8MB** — see [[export-size-optimization]]

**Browser**
- Must work in **incognito mode** — wrap all `localStorage` calls in try/catch
- No external requests (Google Fonts, CDNs, third-party analytics) — all assets must be bundled
- Must remain fully playable with **ad blockers enabled**

**Content**
- No splash screens, studio branding, or external ad links
- Remove all debug code, dev tools, and test artifacts before submission

**Save Data**
- Implement progress persistence, or explicitly tell the player their data won't be saved

---

## Setup

**Requirements:** Godot 4.3+, game approved through Poki for Developers before production SDK use.

Install via Asset Library (search "poki") or clone [godot-poki-sdk](https://github.com/vkbsb/godot-poki-sdk) into `addons/`. Enable in Project Settings → Plugins.

The plugin auto-creates:
- A `Poki` HTML5 export preset
- An autoloaded `PokiSDK` singleton

> [!NOTE]
> Use the [Poki Inspector](https://inspector.poki.dev/) for local testing — it simulates the full ad environment.

---

## SDK Lifecycle

These calls tell Poki when the game is active. **Getting these wrong breaks ad timing and revenue.**

```gdscript
PokiSDK.gameLoadingFinished()   # once, when all assets are done loading
PokiSDK.gameplayStart()         # on first player interaction only — NOT on load
PokiSDK.gameplayStop()          # on pause, menu, level end, cutscene
```

> [!WARNING] Strict rules from Poki
> - `gameplayStart()` fires **only on first player interaction**, never automatically on load
> - `gameplayStop()` must fire during any pause, menu, level completion, or cutscene
> - **No consecutive duplicate calls** — don't call `gameplayStart()` twice in a row
> - SDK events must **not fire during** an active ad (commercial or rewarded)
> - `commercialBreak()` fires **only when resuming gameplay after a pause** — not at arbitrary points

---

## Monetization

### Commercial Break (Interstitial)

Trigger when resuming gameplay after a natural pause — run end, death, returning from menu.

```gdscript
func trigger_commercial_break() -> void:
	PokiSDK.gameplayStop()
	PokiSDK.commercialBreak(Callable(self, "_on_commercial_break_done"))

func _on_commercial_break_done(_response) -> void:
	PokiSDK.gameplayStart()
```

> [!NOTE]
> Not every call triggers an ad — Poki controls frequency. Always resume gameplay in the callback regardless.

### Rewarded Break

User-initiated. Must clearly communicate the reward before triggering. Mute audio and disable input for the duration.

```gdscript
func trigger_rewarded_break() -> void:
	PokiSDK.gameplayStop()
	# mute audio, disable input here
	PokiSDK.rewardedBreak()

func _on_rewarded_break_done(rewarded: bool) -> void:
	# re-enable audio, input here
	if rewarded:
		grant_reward()
	PokiSDK.gameplayStart()
```

Connect the signal in `_ready()`:
```gdscript
PokiSDK.connect("rewarded_break_done", Callable(self, "_on_rewarded_break_done"))
```

> [!WARNING]
> A rewarded break **resets the commercial break timer**. Don't trigger both in the same session transition.

Rewarded break options (optional dict):
```gdscript
PokiSDK.rewardedBreak({"size": "medium"})  # "small" / "medium" / "large"
```

---

## Shareable URLs

Encode game state (level, score, character) into a shareable link. Useful for runs and leaderboards.

```gdscript
PokiSDK.connect("shareable_url_ready", Callable(self, "_on_url_ready"))
PokiSDK.shareableURL({"id": "run_01", "type": "score", "score": 4200})

func _on_url_ready(url: String) -> void:
	pass # display or copy url

# Read params on load:
var score := PokiSDK.getURLParam("score")
```

---

## User Auth

Optional — enables usernames and avatars (relevant for leaderboards, name entry).

```gdscript
PokiSDK.connect("user_ready", Callable(self, "_on_user_ready"))
PokiSDK.connect("user_failed", Callable(self, "_on_user_failed"))
PokiSDK.getUser()

func _on_user_ready(user: Dictionary) -> void:
	var username: String = user["username"]
	var avatar_url: String = user["avatarUrl"]
```

To prompt login:
```gdscript
PokiSDK.login()
# resolves via login_done() or login_failed()
```

---

## Analytics & Diagnostics

```gdscript
PokiSDK.measure("ui", "shop", "double_gold_purchased")
PokiSDK.measure("gameplay", "run", "completed")
PokiSDK.captureError("wave_spawner: null enemy reference")
PokiSDK.enableEventTracking(123)  # Poki-assigned numeric ID
```

---

## UI & Debug

```gdscript
PokiSDK.movePill(x, y)      # reposition the Poki badge (default: bottom-right)
PokiSDK.setDebug(false)     # auto-enabled on localhost — disable for production flow testing
PokiSDK.setLogging(false)
```

---

## Thumbnail

> [!TODO]
> Fetch specs from [developers.poki.com/guide/thumbnail](https://developers.poki.com/guide/thumbnail) — page wasn't accessible during doc setup. Verify dimensions, format, and any animated/static requirements before submission.

---

## Localization

Poki exposes the player's locale via the SDK. Implement with Godot's built-in `TranslationServer` when the time comes.

```gdscript
var lang: String = PokiSDK.getLanguage()  # e.g. "en", "es", "pt", "fr"
TranslationServer.set_locale(lang)
```

Full guide: [developers.poki.com/guide/localization](https://developers.poki.com/guide/localization)

---

## Signals Reference

| Signal | Args | When |
|---|---|---|
| `commercial_break_done` | `response` | Ad finished (or skipped) |
| `commercial_break_failed` | `error` | Ad failed |
| `rewarded_break_done` | `rewarded: bool` | Rewarded ad resolved |
| `rewarded_break_failed` | `error` | Rewarded ad failed |
| `shareable_url_ready` | `url: String` | URL encoded |
| `shareable_url_failed` | `error` | URL encoding failed |
| `user_ready` | `user: Dictionary` | User data loaded |
| `user_failed` | `error` | User load failed |
| `login_done` | — | Login succeeded |
| `login_failed` | `error` | Login failed |

---

## Links

- [New Requirements](https://sdk.poki.com/new-requirements.html) · [SDK Docs](https://sdk.poki.com/godot.html) · [GitHub](https://github.com/vkbsb/godot-poki-sdk) · [Poki Inspector](https://inspector.poki.dev/)
- [Poki for Developers](https://developers.poki.com) · [Godot Engine Guide](https://developers.poki.com/guide/web-game-engines)
- [[coffee-milestone]] · [[📐 design/systems/poki-manager]] · [[export-size-optimization]]
