# Dotfiles with GNU Stow

This repo uses [GNU Stow](https://www.gnu.org/software/stow/) to manage symlinks from this repo into your `$HOME`.

## Mental model (so you never forget)

- Each top-level folder in this repo is a **package** (example: `zsh/`, `git/`, `nvim/`).
- Inside each package, mirror the path you want under `$HOME`.
- `stow <package>` creates symlinks into `$HOME`.
- `stow -D <package>` removes symlinks for that package.

Example layout:

```text
dotfiles/
  zsh/
    .zshrc
  git/
    .gitconfig
  nvim/
    .config/nvim/init.lua
```

From the repo root, `stow zsh` links `zsh/.zshrc` -> `~/.zshrc`.

## Install stow

```bash
# Debian/Ubuntu
sudo apt install stow

# Arch
sudo pacman -S stow

# macOS (Homebrew)
brew install stow
```

## Use stow on a new machine (or after clone)

1. Clone repo to `~/dotfiles` (or any path).
2. Run stow from repo root:

```bash
cd ~/dotfiles
stow zsh git nvim
```

If a target file already exists, Stow will refuse to overwrite it. Move/back it up first, then run stow again.

## Add new things to stow

When you create a new config, put it in a package path first, then stow that package.

Example: add `~/.config/alacritty/alacritty.toml`.

```bash
cd ~/dotfiles
mkdir -p alacritty/.config/alacritty
cp ~/.config/alacritty/alacritty.toml alacritty/.config/alacritty/
stow alacritty
```

Now `~/.config/alacritty/alacritty.toml` should be a symlink to this repo.

## Adopt existing files into repo

If you already have real files in `$HOME` and want Stow to pull them into the package automatically:

```bash
cd ~/dotfiles
mkdir -p alacritty/.config/alacritty
stow --adopt alacritty
```

`--adopt` moves conflicting existing files into the package, then symlinks them back.
After adopting, review changes with git:

```bash
git status
git diff
```

## Get things back from stow (undo/recover)

### Remove symlinks for one package

```bash
cd ~/dotfiles
stow -D nvim
```

This removes only links created by Stow for that package (it does not delete files inside this repo).

### Restow (clean/rebuild links)

```bash
cd ~/dotfiles
stow -R nvim
```

`-R` = unstow then stow, useful after reorganizing files.

### Fully stop managing a config with stow

1. `stow -D <package>`
2. Copy file(s) from repo package back to `$HOME` manually
3. Remove package folder from repo if you no longer want it tracked

## Helpful checks

Preview without changing anything:

```bash
stow -nv zsh
```

Common flags:

- `-n` dry run
- `-v` verbose
- `-D` unstow
- `-R` restow
- `--adopt` move existing files into package

## Typical daily workflow

```bash
cd ~/dotfiles
# edit files in package directories
stow -R zsh git nvim
git status
```
