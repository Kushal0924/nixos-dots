# Hosts, modules and `nh`

Working notes for `~/.dotfiles`: how the tree is laid out, how to drive it
with `nh`, how to add or change a host, and how to switch individual modules on
and off. `README.md` is the long-form description of what each module contains;
this file is the day-to-day guide.

---

## 1. File structure

### How a configuration is composed

```
flake.nix                     discovers hosts/, declares the dotfiles.* options
  └── hosts/<name>/           one directory per machine           ← the only per-host file
        ├── default.nix       user, hostname, timezone, opt-ins, imports
        ├── hardware-configuration.nix   generated, never hand-edited
        └── <machine-only modules>       (audio/, etc.)

modules/options.nix           every opt-in switch, declared once
modules/system/               required on every host (kernel, nix, users, packages…)
modules/features/             opt-in capability bundles (gaming, virtualization…)
modules/system/packages/apps.nix opt-in GUI apps (system-wide)
modules/home/apps/            opt-in GUI apps (Home Manager)
modules/home/                 Home Manager, embedded in the NixOS config
```

The flake (`flake.nix:53`) reads `hosts/` and emits one
`nixosConfigurations.<name>` per directory, each with two modules of its own:

```nix
modules = [
  ./modules/options.nix   # declares dotfiles.*, imported for every host
  ./hosts/${host}
];
```

`hosts/infinix/default.nix` then imports the shared bundles:

```nix
imports = [
  ./audio                              # this machine only
  ./hardware-configuration.nix         # generated
  ../../modules/system                 # always
  ../../modules/features               # gated, one switch each
];
```

### Full tree

```
~/.dotfiles/
├── flake.nix                     inputs, per-host outputs, formatter, lint check, devShell
├── flake.lock                    pinned input revisions
├── statix.toml                   skips generated hardware-configuration.nix in statix
│
├── hosts/
│   └── infinix/                  hostname nixos-btw, user mordred, Asia/Kolkata
│       ├── default.nix           userName, hostname, timezone, dotfiles.* opt-ins
│       ├── hardware-configuration.nix
│       └── audio/                SOF/ES8336 quirks, patched module, unmute unit
│
└── modules/
    ├── options.nix               dotfiles.desktop / dotfiles.features.* / dotfiles.apps.*
    │
    ├── system/                   required everywhere
    │   ├── default.nix           aggregator + system.stateVersion + greeter/Umbriel imports
    │   ├── boot.nix              kernel (linuxPackages_latest), GRUB on EFI
    │   ├── desktop.nix           umbriel, greeter, pipewire, libinput, dconf, keyring, xwayland
    │   ├── fonts.nix             mono, nerd fonts, emoji
    │   ├── home-manager.nix      HM as a NixOS module, points at ../home
    │   ├── nix.nix               flakes features, allowUnfree, direnv
    │   ├── packages/             environment.systemPackages
    │   │   ├── apps.nix          gated GUI apps (foliate, krita, libreoffice, obsidian, spotify, vesktop)
    │   │   ├── cli.nix           fetch, wget
    │   │   ├── dev.nix           gcc, git, lazygit, neovim, nh, nodejs, opencode, devenv
    │   │   ├── media.nix         file/image tools, nautilus, viewers, gvfs, pavucontrol
    │   │   ├── nix-ld.nix        programs.nix-ld
    │   │   ├── terminal.nix      kitty
    │   │   └── themes.nix        adw-gtk3, icons, cursors
    │   ├── services.nix          NetworkManager, Bluetooth/firmware, power, polkit+agent
    │   └── users.nix             user account, groups, shell
    │
    ├── features/                 opt-in bundles: browser, gaming, python, virtualization
    │
    └── home/                     Home Manager (per user)
        ├── default.nix           identity, session path, stateVersion, HM imports
        ├── packages.nix          ani-cli, awww, btop, fnm, grc, pokeget-rs
        ├── shell.nix             fish, fnm, grc
        ├── apps/                 bonfire, fastfetch, microfetch, mime, nautilus, vscode
        └── desktop/
            ├── noctalia.nix      session shell: theme, wallpaper
            ├── misc.nix          xdg-terminal-exec default (kitty), dconf window-buttons
            └── umbriel/          settings, keybinds, rules, animations, autostart
```

---

## 2. `nh` commands

`nh` ([nix-community/nh](https://github.com/nix-community/nh), `pkgs.nh`) is
part of the always-on dev packages in `modules/system/packages/dev.nix`, so it
is on `PATH` on every host after a rebuild.

### Host selection

Without an explicit target, `nh` builds
`nixosConfigurations.$(hostname)`. On this machine `hostname` is `nixos-btw`
while the host directory is `infinix`, so **plain `nh os switch` cannot work** —
always name the host:

```bash
nh os switch ~/.dotfiles#infinix     # flake ref + attribute path
nh os switch ~/.dotfiles -H infinix  # same thing via the global --hostname flag
sudo nh os switch ~/.dotfiles#infinix # nh can also elevate itself; both work
```

Make it permanent by exporting a default in `modules/home/shell.nix`:

```fish
set -gx NH_OS_FLAKE "$HOME/.dotfiles#infinix"
```

…after which plain `nh os switch` does the right thing.

### What it maps to

| `nh` | Equivalent | Does |
| --- | --- | --- |
| `nh os switch [HOST]` | `nixos-rebuild switch` | build, activate, set as boot default |
| `nh os boot [HOST]` | — | build and make it the boot default, do not activate |
| `nh os test [HOST]` | `nixos-rebuild test` | build and activate, boot default unchanged |
| `nh os build [HOST]` | `nixos-rebuild build` | build only |
| `nh os info` | `nix profile list --profile ...` | list generations of the current profile |
| `nh os rollback [N]` | `nixos-rebuild rollback` | roll back generations |
| `nh os repl [HOST]` | `nix repl .#nixosConfigurations.<host>.config` | poke at the evaluated config |
| `nh os build-vm [HOST]` | — | build a bootable VM of the host |
| `nh os build-image [HOST]` | — | build a disk image |
| `nh home switch/build/repl` | `home-manager …` | only works if the flake exposes `homeConfigurations` — **this flake does not**, because Home Manager is embedded in the NixOS config. Use `nh os switch`. |
| `nh search <term>` | — | look packages/options up on search.nixos.org |
| `nh clean all \| user \| profile` | — | prune old profiles and GC |

`nh os` also adds things `nixos-rebuild` lacks: a `--hostname/-H` flag for
multi-host flakes, `-v/-q` for progress-bar noise, and
`-e/--elevation-strategy` (`auto` by default — it picks `sudo`, `doas`, `run0`
or `pkexec` itself, so `nh os switch` can be run as a normal user).

### Useful recipes

```bash
# What will be built, without touching the machine
nh os build ~/.dotfiles#infinix

# Rebuild after editing any module
nh os switch ~/.dotfiles#infinix

# Look at an option before committing to it
nh os repl ~/.dotfiles#infinix
#   nixosConfigurations.infinix.config.programs.umbriel.enable

# Query an option from a normal shell
nix eval .#nixosConfigurations.infinix.config.programs.umbriel.enable

# Lint and format before rebuilding (same as checks.lint in flake.nix)
cd ~/.dotfiles && nix flake check
```

---

## 3. Changing or adding a host

Every directory in `hosts/` becomes a `nixosConfigurations` output; nothing in
`flake.nix` needs to change. See the current hosts:

```bash
cd ~/.dotfiles
nix eval .#nixosConfigurations --apply 'f: builtins.attrNames f'
# [ "infinix" ]
```

### Switch to another host that already exists

```bash
sudo nh os switch ~/.dotfiles#<name>
# or, without nh:
sudo nixos-rebuild switch --flake ~/.dotfiles#<name>
```

The target host's `hardware-configuration.nix` decides which disks are used, so
only switch between host entries that describe the machine you are on.

### Add a new machine

1. On the new machine (live USB or an existing install), generate the hardware
   file and bring it over:

   ```bash
   sudo nixos-generate-config
   # copy /etc/nixos/hardware-configuration.nix into ~/.dotfiles/hosts/<name>/
   ```

2. Write `hosts/<name>/default.nix` — this is the only file a host needs:

   ```nix
   {
     # Consumed by modules/system/users.nix and modules/home
     _module.args.userName = "mordred";

     imports = [
       ./hardware-configuration.nix
       ../../modules/system # always on
       ../../modules/features # every module here is opt-in
     ];

     networking.hostName = "<name>"; # also what nh uses for host selection
     time.timeZone = "Asia/Kolkata";

     dotfiles = {
       desktop.enable = true; # omit for a headless box
       features.gaming.enable = true;
       apps.vscode.enable = true;
       # everything else stays off
     };
   }
   ```

3. Validate and apply:

   ```bash
   cd ~/.dotfiles
   nix flake check
   sudo nh os switch ~/.dotfiles#<name>
   ```

   For a headless host also import the feature set you want; the desktop stays
   off because `dotfiles.desktop.enable` defaults to `false`.

### Change an existing host

Edit `hosts/<name>/default.nix` — hostname, timezone, `userName`, opt-ins and
machine-specific modules (like `infinix/audio/`) all live there. Nothing else in
the tree hardcodes a hostname. Note that `userName` is a module argument, so
renaming it also renames the account the system modules create.

---

## 4. Opting modules in and out

Every optional module is gated by a switch declared in `modules/options.nix` and
set by the host. **All switches default to `false`**, so a host only gets what it
asks for.

| Switch | Gates | Default |
| --- | --- | --- |
| `dotfiles.desktop.enable` | `modules/system/desktop.nix` and everything in `modules/home/desktop` (Umbriel, Noctalia, greeter, pipewire, terminal, theme) | off |
| `dotfiles.features.browser.enable` | `modules/features/browser.nix` (Helium) | off |
| `dotfiles.features.gaming.enable` | `modules/features/gaming.nix` (Millennium Steam, GameMode, 32-bit graphics, xpadneo) | off |
| `dotfiles.features.python.enable` | `modules/features/python.nix` (python3 + numpy/onnxruntime/pillow, `uv`) | off |
| `dotfiles.features.virtualization.enable` | `modules/features/virtualization.nix` (libvirt, QEMU/KVM, SPICE, virt-manager, `kvm`/`libvirtd` groups) | off |
| `dotfiles.apps.bonfire.enable` | `modules/home/apps/bonfire.nix` (Bonfire new-tab page on `127.0.0.1:8420`) | off |
| `dotfiles.apps.fastfetch.enable` | `modules/home/apps/fastfetch.nix` | off |
| `dotfiles.apps.foliate.enable` | `modules/system/packages/apps.nix` (Foliate) | off |
| `dotfiles.apps.krita.enable` | `modules/system/packages/apps.nix` (Krita) | off |
| `dotfiles.apps.libreoffice.enable` | `modules/system/packages/apps.nix` (LibreOffice) | off |
| `dotfiles.apps.microfetch.enable` | `modules/home/apps/microfetch.nix` (microfetch in the user profile) | off |
| `dotfiles.apps.mime.enable` | `modules/home/apps/mime.nix` (Celluloid/Loupe/Evince/Foliate defaults) | off |
| `dotfiles.apps.nautilus.enable` | `modules/home/apps/nautilus.nix` (nautilus-python, open-in-kitty) | off |
| `dotfiles.apps.obsidian.enable` | `modules/system/packages/apps.nix` (Obsidian) | off |
| `dotfiles.apps.spotify.enable` | `modules/system/packages/apps.nix` (Spotify) | off |
| `dotfiles.apps.vesktop.enable` | `modules/system/packages/apps.nix` (Vesktop) | off |
| `dotfiles.apps.vscode.enable` | `modules/home/apps/vscode.nix` | off |
| `dotfiles.apps.zapfast.enable` | `modules/system/packages/apps.nix` (WhatsApp via ZapFast) | off |

Opting **out** is the same edit: delete the `enable = true;` line (or set it to
`false`). Nothing else in the tree references the module, so the packages,
services and user groups it created disappear with it.

```nix
# hosts/infinix/default.nix — turn gaming off, drop LibreOffice
dotfiles = {
  desktop = {
    enable = true;
  };
  features = {
    browser = { enable = true; };
    # gaming.enable removed
    python = { enable = true; };
    virtualization = { enable = true; };
  };
  apps = {
    vscode = { enable = true; };
    # every other app stays off
  };
};
```

Check what a switch currently resolves to, then rebuild:

```bash
cd ~/.dotfiles
nix eval .#nixosConfigurations.infinix.config.dotfiles.features.gaming.enable
nix flake check
sudo nh os switch ~/.dotfiles#infinix
```

### How the gating works

* A NixOS module reads `config.dotfiles.…` and wraps its body in `lib.mkIf`:

  ```nix
  { config, lib, pkgs, ... }:
  lib.mkIf config.dotfiles.apps.spotify.enable {
    environment.systemPackages = [ pkgs.spotify ];
  }
  ```

* A Home Manager module reads the same option through `osConfig`, because the
  embedded Home Manager evaluation does not see NixOS options on its `config`:

  ```nix
  { lib, osConfig, ... }:
  lib.mkIf osConfig.dotfiles.apps.vscode.enable {
    programs.vscode.enable = true;
  }
  ```

* `imports` is **not** a normal option, so it can never live inside a
  conditional module — a module with `lib.mkIf { imports = …; }` fails to
  evaluate, and conditional *import* lists (`lib.optionals config.…`) cause
  infinite recursion. That is why the greeter and Umbriel modules
  are imported unconditionally and only their *settings* are gated.

### Adding a new optional module

1. Declare the switch in `modules/options.nix` (all `false` by default).
2. Wrap the module body in `lib.mkIf config.dotfiles.features.<name>.enable`
   (or `osConfig.…` in `modules/home`) — keep `imports` outside any `mkIf`.
3. Import the file unconditionally from its aggregator
   (`modules/features/default.nix`, `modules/system/packages/apps.nix`,
   `modules/home/apps/default.nix`).
4. Set `dotfiles.features.<name>.enable = true;` in the hosts that want it.
5. `nix fmt && nix flake check`.