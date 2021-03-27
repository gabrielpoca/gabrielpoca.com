---
title: A little bit of lua in your vim
date: 2019-11-02
layout: "_includes/post_layout.slime"
tag:
  - post
---

One of the reasons why I love Vim so much is because I can easily change it to
my needs. My Vim configuration is a living organism that evolves with my
knowledge, taste and career.

Unfortunately, VimScript never clicked for me, so whenever I needed to do
something more complex in Vim, I would
[rely in other languages, like Ruby](https://gabrielpoca.com/2017-09-04-vim-ruby/).
This has worked reasonably well for me, but since Neovim
[added built-in support for a lua](https://neovim.io/roadmap/), I've been
waiting to have the time, and the use-case, to try it out.

This is what I want to accomplish: four shortcuts that open up four different
neovim terminals. Whenever I hit one of the shortcuts, I get a new terminal. If
this terminal was already created, I want to open it instead. I also don't want
to see these terminals in my buffer list.

This is something I already have with tmux, but the ergonomics are a bit weird.
Doing it in neovim would be great for my workflow, but that's not the topic of
this blog post. On with the code.

The following piece of code is everything there is. I added some comments to
make it easier to understand.

```lua
-- to save terminals
list_of_terms = {}

function Terminal(nr, ...)
  -- if the terminal with nr exists, set the current buffer to it
  if list_of_terms[nr] then
    -- change to the terminal
    vim.api.nvim_set_current_buf(list_of_terms[nr])
  -- if the terminal doesn't exist
  else
    -- create a buffer that's is unlisted and not a scratch buffer
    local buf = vim.api.nvim_create_buf(false, false)
    -- change to that buffer
    vim.api.nvim_set_current_buf(buf)
    -- create a terinal in the new buffer using my favorite shell
    vim.api.nvim_call_function("termopen", {"/bin/zsh"})
    -- save a reference to that buffer
    list_of_terms[nr] = buf
  end
  -- change to insert mode
  vim.api.nvim_command(":startinsert")
end
```

I save this code in `~/.config/nvim/lua/navigation/init.lua`. Now, in one of my
Vim configuration files, I import the lua navigation package, and map the
function created in Lua to the shortcuts.

```vim
" require the lua module
lua require("navigation")
" map the Terminal function in the lua module to some shortcuts
nnoremap <silent> <leader>kh :lua Terminal(1)<cr>
nnoremap <silent> <leader>kj :lua Terminal(2)<cr>
nnoremap <silent> <leader>kk :lua Terminal(3)<cr>
nnoremap <silent> <leader>kl :lua Terminal(4)<cr>
```

That is all! One of my ideas to improve this is changing of the shortcuts to
immediately open up programs that I used more frequently. For that I could
change the function to accept a new argument to use instead of `/bin/zsh`. I
could do something like `nnoremap <silent> <leader>kl :lua Terminal(2, "tig")`
to get _tig_.

I'm sharing this not because this is a great use-case to use lua, I'm sure you
can do this easily with VimScript (I can't), but because it wasn't easy to
figure out which functions to call and how. I hope F˝ helps someone (or my
future self).
