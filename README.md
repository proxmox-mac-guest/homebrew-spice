# proxmox-mac-guest/spice

Homebrew tap for SPICE guest agent tools on Intel macOS (Proxmox guests).

## Install

```bash
brew tap proxmox-mac-guest/spice
brew install spice-vdagent
brew services start spice-vdagent
```

## What's included

| Formula | Description |
|---------|-------------|
| spice-vdagent | SPICE vdagent for macOS (clipboard sharing with Proxmox SPICE console) |

## Complementary tool

For QEMU Guest Agent support (fsfreeze, shutdown, OS info), install [mac-guest-agent](https://github.com/mav2287/mac-guest-agent) separately. It uses a different serial channel (ISA) and coexists with spice-vdagent without conflict.
