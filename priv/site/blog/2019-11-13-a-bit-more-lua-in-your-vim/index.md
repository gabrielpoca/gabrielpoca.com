---
title: A bit more lua in your vim
date: 2019-11-13
layout: "_post_layout.slime"
tag:
  - post
---

Following up on the
[previous entry about lua in vim](https://gabrielpoca.com/2019-11-02-a-little-bit-of-lua-in-your-vim/),
in this one I document other ways in which I used lua to improve my setup.

Anyone using Neovim should know that it has support for floating windows: real
windows that can float around. You can do all kinds of cool stuff with it. Here
it is in action:

<blockquote class="twitter-tweet tw-align-center"><p lang="en" dir="ltr"><a href="https://twitter.com/hashtag/neovim?src=hash&amp;ref_src=twsrc%5Etfw">#neovim</a> floating window test with vim-iced (part 2)<br>Floating debugger info<a href="https://t.co/wAITDpmvip">https://t.co/wAITDpmvip</a><a href="https://twitter.com/hashtag/clojure?src=hash&amp;ref_src=twsrc%5Etfw">#clojure</a> <a href="https://t.co/5lebGKybiD">pic.twitter.com/5lebGKybiD</a></p>&mdash; 飯塚将志@にびいろClojure (@uochan) <a href="https://twitter.com/uochan/status/1101445517865771013?ref_src=twsrc%5Etfw">March 1, 2019</a></blockquote>

So this is how the story begins: one day my friend, and teammate,
[Miguel](https://twitter.com/naps62) was showing me something on his computer,
when I saw him doing something like this:

[![asciicast](https://asciinema.org/a/278565.svg)](https://asciinema.org/a/278565)

He was opening fzf inside a floating window! I immediately ran to my desk and
copied the code that does this from his dotfiles. The relevant parts are
[here](https://github.com/naps62/dotfiles/blob/b6df1166ce3b65ab408147a58201aa9c2cccd691/config/nvim/rc/functions.vim#L69-L87)
and
[here](https://github.com/naps62/dotfiles/blob/f5a3ed135ce210ae3b29268b6122cb5d863375cc/config/nvim/rc/plugins.vim#L226).
He got it somewhere from the Github.

I was in love with this for a while!... Until I realized that it didn't work
great when I was using Vim in smaller tmux splits. I need something more
"intelligent" that took into account the editor's size. Since my VimScript
skills are non-existent, I replaced his implementation with Lua.

Here's what I want:

- if the editor is small (when I'm in a split with 1/4 of the screen's size) it
  uses a full window instead of a floating one.
- the floating window's width is 90% of the editor's width, but if the editor's
  width is small, it uses full width minus 4 columns from each side.
- a floating window's height is 3/4 of the editor's height to a max of 30 lines.

The code, with comments, so it's easier to understand:

```lua
function NavigationFloatingWin()
  -- get the editor's max width and height
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  -- create a new, scratch buffer, for fzf
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')

  -- if the editor is big enough
  if (width > 150 or height > 35) then
    -- fzf's window height is 3/4 of the max height, but not more than 30
    local win_height = math.min(math.ceil(height * 3 / 4), 30)
    local win_width

    -- if the width is small
    if (width < 150) then
      -- just subtract 8 from the editor's width
      win_width = math.ceil(width - 8)
    else
      -- use 90% of the editor's width
      win_width = math.ceil(width * 0.9)
    end

    -- settings for the fzf window
    local opts = {
      relative = "editor",
      width = win_width,
      height = win_height,
      row = math.ceil((height - win_height) / 2),
      col = math.ceil((width - win_width) / 2)
    }

    -- create a new floating window, centered in the editor
    local win = vim.api.nvim_open_win(buf, true, opts)
  end
end
```

To make it work, place the code in a file such as
`~/.config/nvim/lua/navigation/init.lua`, and in your vim configuration put
something like this:

```vim
" load lua functions for navigation
lua require("navigation")
let g:fzf_layout = { 'window': 'lua NavigationFloatingWin()' }
```

Once again, I know that you can do this with VimScript, but I can't. And,
because I know there are more like me out there, I hope this helps you, and my
future self as well.
