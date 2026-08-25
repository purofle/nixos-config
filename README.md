# nixos-config

My nix configuration for my two devices (ThinkBook 14+ 2025 Intel) and Mac Mini M1.

Project structure:
```
.
├── common
│   ├── default.nix
│   ├── packages.nix
│   └── programs
│       ├── 1password.nix
│       ├── git.nix
│       ├── python.nix
│       └── zsh.nix
├── dev-linux.nix // Linux dev
├── dev.nix // common dev
├── develop
│   └── rust.nix
├── flake.lock
├── flake.nix
├── hosts
│   ├── darwin // nix-darwin
│   │   ├── default.nix
│   │   └── home.nix
│   └── nixos // NixOS
│       ├── base.nix
│       ├── default.nix
│       ├── font.nix
│       ├── hardware-configuration.nix
│       ├── home.nix
│       ├── i18n.nix
│       └── packages.nix // Nixos-specific software
└── README.md
```

`develop/rust.nix` is my devShell for Rust development, you can enter it with `nix develop ".#rust"`.

## License
MIT License