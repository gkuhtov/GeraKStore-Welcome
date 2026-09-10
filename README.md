# GeraKStore Welcome

<p align="center">
  <strong>Universal welcome screens for GeraKStore</strong><br>
  <sub>Native iOS welcome experiences for injected IPA applications</sub>
</p>

<p align="center">
  <a href="https://github.com/gkuhtov/GeraKStore-Welcome/actions">GitHub Actions</a> ·
  <a href="https://github.com/gkuhtov/GeraKStore-Welcome/issues">Issues</a>
</p>

---

## Overview

**GeraKStore Welcome** is a collection of lightweight Objective-C welcome screens designed for use inside iOS applications distributed through GeraKStore.

The project currently contains two independent visual implementations:

- **WelcomeToSpace** - a modern dark welcome screen with Apple-style Liquid Glass, animated glow and configurable content.
- **WelcomeToJapan** - a Japanese-inspired welcome screen with a layered illustrated scene, decorative elements and configurable resources.

Both implementations are built as dynamic libraries and are intended to be injected into compatible IPA applications.

## Features

### WelcomeToSpace

- iOS-style Liquid Glass interface
- Dark graphite visual language
- Pink and cyan accent lighting
- Animated background glow
- Configurable title and subtitle
- Telegram, GitHub and Continue actions
- Optional "Don't show again" behavior
- Configurable appearance and animation parameters
- External JSON configuration with embedded-resource fallback
- GitHub Actions build pipeline

### WelcomeToJapan

- Japanese-inspired visual composition
- Custom background artwork
- Decorative plaques and store branding
- Configurable text, links and visual elements
- Standalone dynamic-library build
- GitHub Actions build pipeline

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
└── README.md
```

## Configuration

`WelcomeToSpace` keeps its user-facing settings separated from the UI implementation.

The configuration includes:

- `config.json` - general behavior and feature flags
- `texts.json` - visible interface text
- `links.json` - Telegram and GitHub links
- `appearance.json` - colors, glass parameters, layout and animation settings

The configuration layer is loaded through `WelcomeConfig` and `EmbeddedResourceLoader`. When an external configuration is unavailable, resources can be read from embedded Mach-O sections inside the dylib.

This makes the welcome screen easier to customize without rewriting the main UI code.

## Build

Builds are performed by **GitHub Actions** on macOS runners.

### WelcomeToSpace

The main workflow builds the `WelcomeToSpace` dylib and packages its required resources as a workflow artifact.

A separate workflow can inject the resulting welcome screen into the test IPA used by the project.

### WelcomeToJapan

`WelcomeToJapan` has its own build workflow and produces its dynamic-library artifact independently from `WelcomeToSpace`.

No local macOS build environment is required on the development PC.

## Injection

The welcome screens are designed for use as injected dynamic libraries in compatible IPA packages.

The project does not contain a specific application identity in the universal welcome UI. This allows the same welcome implementation to be reused across different applications.

## Design Philosophy

The visual direction of the project is based on a simple idea:

> The welcome screen should feel like part of the application, not an external installer window.

`WelcomeToSpace` focuses on depth, translucency, blur, subtle lighting and restrained animation. `WelcomeToJapan` takes the opposite visual direction and uses illustration, layered artwork and Japanese-inspired decorative elements.

Despite the different styles, both implementations share the same goal: a compact, recognizable and reusable GeraKStore welcome experience.

## Status

The repository is actively developed.

- [x] WelcomeToSpace implementation
- [x] WelcomeToJapan implementation
- [x] Configurable UI settings
- [x] Embedded resource support
- [x] GitHub Actions builds
- [x] IPA injection workflow for WelcomeToSpace
- [ ] Further UI polish
- [ ] Deeper GeraStoreManager integration

## Repository

**GeraKStore Welcome**  
https://github.com/gkuhtov/GeraKStore-Welcome

Maintained by **GeraK**.

---

<p align="center">
  <sub>GeraKStore · Welcome Experience</sub>
</p>
