# Dotfiles To Do list

## On cmdline

- Use `opt+arrows` to navigate back-forward one word at a time
- Use `ctrl+e` to complete the entire suggestion and `ctrl+a` to jump to the
  front

## Fresh new tools

- `lazydocker` - Handle everything docker
- `viddy` - Replacement for `watch`
- `duckdb` - Nifty SQL-based file processor
- `tldr` (using `tlrc`) - Find usage patterns of a command
- `tokei` - Get fast, accurate count of lines
- `doggo` - A nicer DNS search utility
- `hyperfine` - Benchmarking tool
- `rmlint` - Clean up duplicate files
- `yazi` - New terminal based file manager
- `euporie` - Terminal-based `jupyter` notebook
- `eza` - New-world `ls` alternative
- `pv` - Pipe viewer; view more stuff
- `gitleaks` - Find leaky cauldron of secrets. Pipe files in
  `gitsecrets -v stdin` to gather info about them

## 📋 To do lists

### Dropped (for now) 🫳

1. In `kitty`, set tab bar. See: [megalithic/dotfiles]
2. In `kitty`, set up [kitty-startup-sessions].
   - One dedicated to `dotfiles`

### Blocked 🚫

1. Auto theme in `delta` and `lazygit`: [delta#1968] and [lazygit#4366]
2. Use cases before spending time on `ast-grep` and `yazi`

### Pending ⏰

- `Chezmoi` should handle getting changed/deleted/fresh files with a single
  command
- Set up `grc`
- Better tools:
  - Shell history - (`altuin`)
  - Package manager - (`mise` as replacement for `fnm` and `sdkman`)
  - Database tool that remembers credentials well and supports Redshift
- More use cases for password managers, passkeys and fingerprint based
  authentication
- For switching from Kitty to Ghostty, figure out replacements for most of the
  additional benefits that Kitty provides
  1. Unicode insert mode using Mod+u
  2. Scroll-back buffer
  3. Jump b/w prompts
  4. Font selector
  5. Work spaces and sessions

### Under review 📗

1. Set up `raycast`
2. Set up `lazydocker`

### Done ✅

- [x] Set up `-` as a word breaker when moving in the `cmdline` of the terminal
- [x] Tested out `harlequin` — Did not like it, did not have enough features to
      spend more time there
- [x] Test `ghostty` terminal. Now using it
- [x] Set up a process to set a bunch of files/directories in an order to VLC
      (in future, maybe another app)

  ```bash
  fd -0 'S01E([1-9][0-9])|S01E09' -e mkv | xargs -0 open -a VLC
  ```

[delta#1968]: https://github.com/dandavison/delta/issues/1968
[lazygit#4366]: https://github.com/jesseduffield/lazygit/issues/4366
[kitty-startup-sessions]:
  https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.startup_session
[megalithic/dotfiles]:
  https://github.com/megalithic/dotfiles/blob/main/config/kitty/tab_bar.py
