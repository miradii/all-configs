-- Telescope Settings
local opts = { noremap = true }
require('legendary').keymaps({
    { '<space>pf', require('telescope.builtin').find_files, description = 'Telescope: Find files', opts = opts },
    { '<space>pg', require('telescope.builtin').live_grep, description = 'Telescope: Live grep', opts = opts },
    { '<space>pb', require('telescope.builtin').buffers, description = 'Telescope: Buffers', opts = opts },
    { '<space>ph', require('telescope.builtin').help_tags, description = 'Telescope: Help tags', opts = opts }
})
