---
type: adr
tags: [adr, tech, web-export, performance]
status: in-progress
date: 2026-05-03
---

## Export Size Optimization

> [!GOAL] Target
> Poki's stated target is **8–10MB compressed download size**. Poki's CDN applies gzip compression server-side, so the figure refers to what the player actually downloads. Baseline (no assets, minimal code): 36MB uncompressed / 8.9MB gzip. We're already within range — optimization is about staying there as assets are added.

^f77984

## Context

- Engine: Godot 4.6 (GL Compatibility renderer — already set)
- Platform: Web only (no desktop/mobile native builds)
- Profile: Pure 2D, GDScript only, no 3D, no XR, no AR

Most optimization techniques require **custom export templates** (compiling Godot from source). This is a pre-submission task, not a Day 1 task. Today we document the full flag set and set up the Build Configuration Profile in the editor.

## Decisions

### Approved techniques

| Technique                                     | When           | Notes                                  | Status                                                                                            |
| --------------------------------------------- | -------------- | -------------------------------------- | ------------------------------------------------------------------------------------------------- |
| `optimize="size_extra"`   + `lto="full"`      | Pre-submission | Godot 4.5+ flag                        | <select> <option>🚧</option> <option>✅</option> <option>⚠️</option> <option>⛔️</option> </select> |
| `disable_3d="yes"`                            | Pre-submission | No 3D used anywhere                    | <select> <option>🚧</option> <option>✅</option> <option>⚠️</option> <option>⛔️</option> </select> |
| `openxr="no"`                                 | Pre-submission |                                        | <select> <option>🚧</option> <option>✅</option> <option>⚠️</option> <option>⛔️</option> </select> |
| `vulkan="no"`                                 | Pre-submission | Using GL Compatibility                 | <select> <option>🚧</option> <option>✅</option> <option>⚠️</option> <option>⛔️</option> </select> |
| `disable_navigation_3d="yes"`                 | Pre-submission |                                        | <select> <option>🚧</option> <option>✅</option> <option>⚠️</option> <option>⛔️</option> </select> |
| `disable_navigation_2d="yes"`                 | Pre-submission | No nav mesh planned                    | <select> <option>🚧</option> <option>✅</option> <option>⚠️</option> <option>⛔️</option> </select> |
| `modules_enabled_by_default="no"` + allowlist | Pre-submission | See allowlist below                    | <select> <option>🚧</option> <option>✅</option> <option>⚠️</option> <option>⛔️</option> </select> |
| `deprecated="no"`                             | Pre-submission |                                        | <select> <option>🚧</option> <option>✅</option> <option>⚠️</option> <option>⛔️</option> </select> |
| `debug_symbols="no"`                          | Pre-submission |                                        | <select> <option>🚧</option> <option>✅</option> <option>⚠️</option> <option>⛔️</option> </select> |
| `use_volk="no"`                               | Pre-submission |                                        | <select> <option>🚧</option> <option>✅</option> <option>⚠️</option> <option>⛔️</option> </select> |
| `minizip="no"`                                | Pre-submission |                                        | <select> <option>🚧</option> <option>✅</option> <option>⚠️</option> <option>⛔️</option> </select> |
| `graphite="no"`                               | Pre-submission | Godot 4.5+                             | <select> <option>🚧</option> <option>✅</option> <option>⚠️</option> <option>⛔️</option> </select> |
| `disable_xr="yes"`                            | Pre-submission | Godot 4.5+                             | <select> <option>🚧</option> <option>✅</option> <option>⚠️</option> <option>⛔️</option> </select> |
| `accesskit="no"`                              | Pre-submission | Godot 4.5+                             | <select> <option>🚧</option> <option>✅</option> <option>⚠️</option> <option>⛔️</option> </select> |
| `module_text_server_adv_enabled="no"`         | Pre-submission | Use fb (fallback) instead              | <select> <option>🚧</option> <option>✅</option> <option>⚠️</option> <option>⛔️</option> </select> |
| Build Configuration Profile                   | Today          | Editor-only, no custom template needed | <select> <option>🚧</option> <option>✅</option> <option>⚠️</option> <option>⛔️</option> </select> |
| `wasm-opt` post-processing                    | At export      | CLI tool, ~1.4MB savings               | <select> <option>🚧</option> <option>✅</option> <option>⚠️</option> <option>⛔️</option> </select> |

### Rejected / deferred

| Technique                    | Decision     | Reason                                                                                                         |
| ---------------------------- | ------------ | -------------------------------------------------------------------------------------------------------------- |
| `disable_advanced_gui="yes"` | **Rejected** | Need `TextEdit` for name entry; may use `RichTextLabel` for UI. Re-evaluate only if we need to hyper-optimize. |
| Brotli compression           | Deferred     | Depends on Poki server support — verify at submission time                                                     |
| UPX packing                  | N/A          | Desktop only                                                                                                   |

## Module Allowlist

When `modules_enabled_by_default=no`, re-enable only these:

```
module_gdscript_enabled=yes
module_text_server_fb_enabled=yes
module_freetype_enabled=yes
module_webp_enabled=yes
module_vorbis_enabled=yes
module_godot_physics_2d_enabled=yes
```

> [!WARNING] Allowlist maintenance
> Any new format or engine feature added during development may require adding a module here. If something silently breaks in a custom-template build, check this list first.
> Common additions to watch for:
> - `.mp3` audio → `module_minimp3_enabled=yes`
> - `.svg` assets → `module_svg_enabled=yes`
> - JSON parsing (likely needed) → included in core, no module flag needed

## Build Configuration Profile

Set in Godot Editor (4.4+) under **Project → Tools → Engine Compilation Configuration Editor**.

Steps:
1. Click **Autodetect** — Godot scans the project and disables classes not referenced
2. Review and manually restore anything that crashes (common: `MainLoop`, `StyleBox` variants)
3. Save as `initial_trivial.gdbuild` in the project root
4. Pass to scons at compile time: `build_profile=initial_trivial.gdbuild`

This is non-destructive and lives in the project. It previews the final template cuts without a compile.

## Pre-Submission Checklist

- [x] Set up Build Configuration Profile (autodetect → save `initial_trivial.gdbuild`)
- [ ] Compile custom export template: `scons platform=web target=template_release profile=custom.py build_profile=initial_trivial.gdbuild`
- [ ] Run `wasm-opt`: `wasm-opt <original.wasm> -o <optimized.wasm> -all --post-emscripten -Oz`
- [ ] Verify Brotli support on Poki CDN
- [ ] Test full game on web export (audio, input, ads)
- [ ] Confirm compressed size is under 5MB

## References

- [How to Minify Godot's Build Size](https://popcar.bearblog.dev/how-to-minify-godots-build-size/)
- [[design/index]] — systems overview
- [[coffee-milestone]]
