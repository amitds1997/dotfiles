# Global to-do list

## Pending

1. In `kitty`, set up top tab page using Python script to handle stuff nicely.
   See: [megalithic/dotfiles][1]
2. In `kitty`, set up [startup session][2]
3. Setup `k9s`, `yazi` and `lazydocker`
4. Add `chezmoi` command to automatically loop over all paths and add any missing
   files as and when needed

## Done

1. Setup a process to set a bunch of files/directories in an order to VLC (in
   future, maybe another app)

   ```bash
   fd -0 'S01E([1-9][0-9])|S01E09' -e mkv | xargs -0 open -a VLC
   ```

This is **bold** and this is _italics_ text.

[1]: https://github.com/megalithic/dotfiles/blob/main/config/kitty/tab_bar.py
[2]: https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.startup_session
