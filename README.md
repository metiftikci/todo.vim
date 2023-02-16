# Todo Vim Helper Plugin

1. Create `TODO.md` file
2. When you write `- [ ] ` **todo.vim** adds ` @created(mm/dd)` to end of the line
3. When you write `- [x] ` **todo.vim** adds ` @updated(mm/dd)` to end of the line

## Install

### Packer

```lua
require('packer').startup(function()
  use 'metiftikci/todo.vim'
end)
```
