# GeraKStore Welcome

<p align="center">
  <strong>Universal Welcome Screens for GeraKStore</strong><br>
  <sub>Native iOS welcome experiences for injected IPA applications</sub>
</p>

<p align="center">
  <a href="https://github.com/gkuhtov/GeraKStore-Welcome/actions/workflows/build-dylib.yml"><img src="https://github.com/gkuhtov/GeraKStore-Welcome/actions/workflows/build-dylib.yml/badge.svg" alt="WelcomeToSpace Build"></a>
  <a href="https://github.com/gkuhtov/GeraKStore-Welcome/actions/workflows/build-welcome-to-japan.yml"><img src="https://github.com/gkuhtov/GeraKStore-Welcome/actions/workflows/build-welcome-to-japan.yml/badge.svg" alt="WelcomeToJapan Build"></a>
  <a href="https://github.com/gkuhtov/GeraKStore-Welcome/actions/workflows/inject-welcome-to-space.yml"><img src="https://github.com/gkuhtov/GeraKStore-Welcome/actions/workflows/inject-welcome-to-space.yml/badge.svg" alt="Space Injection"></a>
</p>

<p align="center">
  <a href="#overview">Overview</a> ·
  <a href="#welcome-to-space">Space</a> ·
  <a href="#welcome-to-japan">Japan</a> ·
  <a href="#configuration">Configuration</a> ·
  <a href="#build--injection">Build</a> ·
  <a href="#project-structure">Structure</a>
</p>

---

## Overview

**GeraKStore Welcome** is a collection of lightweight Objective-C welcome screens designed for iOS applications distributed through GeraKStore.

The repository brings together two independent visual implementations with a shared goal: create a recognizable, polished and reusable welcome experience that feels like part of the application rather than an external installer screen.

### Included

| Component | Style | Purpose |
|---|---|---|
| **WelcomeToSpace** | Dark · Liquid Glass · Glow | Modern universal welcome screen |
| **WelcomeToJapan** | Japanese · Illustrated · Parallax | Decorative alternative welcome screen |

Both implementations are built as dynamic libraries and are intended for injection into compatible IPA applications.

---

## WelcomeToSpace

A modern GeraKStore welcome screen focused on Apple's Liquid Glass visual language.

### Highlights

- iOS-style Liquid Glass interface
- Dark graphite visual language
- Pink and cyan accent lighting
- Animated background glow
- Configurable title and subtitle
- Telegram, GitHub and Continue actions
- Optional **Don't show again** behavior
- Configurable appearance, layout and animation parameters
- JSON configuration with embedded-resource fallback
- Dedicated GitHub Actions build workflow
- Separate IPA injection workflow for testing

The universal UI does not depend on a specific application name or version, allowing the same welcome implementation to be reused across compatible applications.

---

## WelcomeToJapan

A Japanese-inspired alternative built around illustration, layered artwork and decorative elements.

### Highlights

- Custom Japanese-style background artwork
- Decorative side plaques
- GeraKStore branding
- Configurable texts and links
- Configurable visual parameters
- Dedicated dynamic-library build
- Independent GitHub Actions workflow

The implementation is kept independent from `WelcomeToSpace`, so the two visual directions can evolve separately without unnecessary coupling.

---

## Configuration

`WelcomeToSpace` keeps user-facing settings separated from the main UI implementation.

### Configuration files

| File | Controls |
|---|---|
| `config.json` | General behavior and feature flags |
| `texts.json` | Visible interface text |
| `links.json` | Telegram and GitHub links |
| `appearance.json` | Colors, glass, layout and animation |

Configuration is handled through `WelcomeConfig` and `EmbeddedResourceLoader`.

When an external configuration is unavailable, resources can be loaded from embedded Mach-O sections inside the dylib. This provides a self-contained fallback while keeping customization separate from the UI code.

---

## Build & Injection

All primary builds are performed through **GitHub Actions** on macOS runners.

### WelcomeToSpace

`build-dylib.yml` builds the `GeraKStoreWelcome.dylib` and packages the required configuration and logo resources as an artifact.

`inject-welcome-to-space.yml` uses the repository test IPA, builds the current welcome dylib, injects it into the application and produces a test IPA artifact.

### WelcomeToJapan

`build-welcome-to-japan.yml` builds the Japanese implementation independently and publishes its dynamic-library build as a workflow artifact.

The repository workflow does not require a local macOS development environment on the Windows development PC.

---

## Test IPA

The repository contains a minimal test target used by the Space injection workflow:

```text
 test-ipa/
 └── GeraKMusic-original.ipa
```

The test IPA is used only as the injection target for validating the `WelcomeToSpace` workflow.

---

## Project Structure

```text
GeraKStore-Welcome/
│
├── .github/
│   └── workflows/
│       ├── build-dylib.yml
│       ├── build-welcome-to-japan.yml
│       └── inject-welcome-to-space.yml
│
├── WelcomeToSpace/
│   ├── Configuration/
│   │   ├── Models/
│   │   └── *.json
│   ├── Core/
│   └── Resources/
│
├── WelcomeToJapan/
│   ├── src/
│   ├── Resources/
│   ├── Makefile
│   └── control
│
├── test-ipa/
│   └── GeraKMusic-original.ipa
│
├── .gitignore
└── README.md
```

---

## Design Philosophy

> **The welcome screen should feel like part of the application, not an external installer window.**

`WelcomeToSpace` achieves this through depth, translucency, blur, restrained animation and subtle pink/cyan lighting.

`WelcomeToJapan` takes a different direction, using illustration, layered artwork and Japanese-inspired decorative elements.

Different styles, same purpose: a compact and recognizable **GeraKStore Welcome Experience**.

---

## Status

### Implemented

- [x] WelcomeToSpace
- [x] WelcomeToJapan
- [x] Configurable UI settings
- [x] Embedded resource support
- [x] GitHub Actions build pipelines
- [x] WelcomeToSpace IPA injection workflow
- [x] Repository cleanup and documentation

### Next

- [ ] Further visual polish
- [ ] Deeper GeraStoreManager integration

---

## Repository

<p align="center">
  <strong>GeraKStore Welcome</strong><br>
  Universal welcome experience for GeraKStore
</p>

<p align="center">
  Maintained by <strong>GeraK</strong>
</p>

---

<p align="center">
  <sub>GeraKStore · Welcome Experience</sub>
</p>
