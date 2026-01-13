# JackTrip Nix Flake

A standalone Nix flake for [JackTrip](https://github.com/jacktrip/jacktrip) - a high-quality audio network performance system for remote music collaboration over the Internet.

## Features

- **Cross-platform support**: Linux and macOS (x86_64 and aarch64)
- **Platform-optimized builds**:
  - Linux: Full GUI with Virtual Studio (Qt6 WebEngine)
  - macOS: Classic GUI (Virtual Studio disabled due to Qt6 framework limitations)
- **Reproducible builds**: Fetches source from upstream with pinned hashes
- **Development shell**: Includes all necessary tools for development

## Why?

I created this flake because the [nixpkgs provided flake](https://github.com/NixOS/nixpkgs/blob/nixos-25.11/pkgs/by-name/ja/jacktrip) is not compatible with nix-darwin. Just a temporary solution while I test this flake to eventually contribute to nixpkgs.

## Quick Start

### Run JackTrip directly (no installation)

```bash
# Using flakes
nix run github:Cephalode/jacktrip-flake

# Check version
nix run github:Cephalode/jacktrip-flake -- --version
```

### Install to your profile

```bash
# Using flakes
nix profile install github:Cephalode/jacktrip-flake

# Run
jacktrip --version
```

### Try without installing

```bash
nix shell github:Cephalode/jacktrip-flake
jacktrip --version
```

## Usage in Your Flake

Add to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    jacktrip.url = "github:Cephalode/jacktrip-flake";
  };

  outputs = { self, nixpkgs, jacktrip }: {
    # Use jacktrip.packages.${system}.jacktrip in your configuration
  };
}
```

## Development

### Enter development shell

```bash
nix develop github:Cephalode/jacktrip-flake
```

The development shell includes:
- All build dependencies (Qt6, JACK, Meson, etc.)
- Development tools (clang-tools, cmake-format)
- Platform-specific tools (gdb, valgrind on Linux)

### Build from source

```bash
nix develop github:Cephalode/jacktrip-flake
meson setup builddir -Dqtversion=6 -Djack=enabled
meson compile -C builddir
./builddir/jacktrip --version
```

## Non-Flake Usage

For users not using flakes:

```bash
# Clone the repository
git clone https://github.com/Cephalode/jacktrip-flake.git
cd jacktrip-flake

# Build
nix-build

# Run
./result/bin/jacktrip --version
```

## Platform Notes

### Linux
- Full GUI with Virtual Studio support
- Qt6 WebEngine enabled
- All features available

### macOS
- Classic GUI mode
- Virtual Studio disabled (due to Qt6 framework header resolution issues in nixpkgs)
- All core functionality available for music performance

## Build Options

The package is built with these options:
- Qt6
- JACK audio backend
- libsamplerate support
- No auto-updater (managed by Nix)
- No RtAudio (JACK-only)

## About JackTrip

JackTrip is a multi-machine audio system for network music performance over the Internet. It supports any number of channels of bidirectional, high quality, uncompressed audio signal streaming with the JACK audio connection kit.

- **Homepage**: https://jacktrip.github.io/jacktrip/
- **Upstream Repository**: https://github.com/jacktrip/jacktrip
- **Version**: 2.7.1

## License

This flake packaging is released under the MIT license.

JackTrip itself is released under MIT and GPL licenses. See the [upstream LICENSE](https://github.com/jacktrip/jacktrip/blob/main/LICENSE.md) for details.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Acknowledgments

Built with [Claude Code](https://claude.com/claude-code).
