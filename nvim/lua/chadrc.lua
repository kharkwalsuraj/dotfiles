---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "wallsync",

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.ui = {
  tabufline = {
    lazyload = false,

    order = { "buffers", "treeOffset" },

    modules = {
      buffers = function()
        local api = vim.api
        local utils = require("nvchad.tabufline.utils")
        local txt = utils.txt

        local cur_buf = api.nvim_get_current_buf()

        -- Keep only valid buffers
        vim.t.bufs = vim.tbl_filter(
          api.nvim_buf_is_valid,
          vim.t.bufs or {}
        )

        local max_len = 20
        local names = {}
        local counts = {}

        -- Get filenames and count duplicate filenames
        for _, nr in ipairs(vim.t.bufs) do
          local path = api.nvim_buf_get_name(nr)
          local name = vim.fn.fnamemodify(path, ":t")

          if name == "" then
            name = "Untitled"
          end

          names[nr] = {
            path = path,
            name = name,
          }

          counts[name] = (counts[name] or 0) + 1
        end

        -- Truncate while keeping the filename visible
        local function truncate(str, len)
          if vim.fn.strdisplaywidth(str) <= len then
            return str
          end

          local name = vim.fn.fnamemodify(str, ":t")

          if vim.fn.strdisplaywidth(name) + 3 >= len then
            return name:sub(1, len - 2) .. ".."
          end

          local parent = str:sub(1, #str - #name - 1)
          local available = len - vim.fn.strdisplaywidth(name) - 3

          return parent:sub(1, available) .. "../" .. name
        end

        local buffers = {}

        for _, nr in ipairs(vim.t.bufs) do
          local data = names[nr]
          local display_name = data.name

          -- Show parent directory for duplicate filenames
          if counts[data.name] > 1 and data.path ~= "" then
            local parent = vim.fn.fnamemodify(data.path, ":h:t")

            if parent ~= "" and parent ~= "." then
              display_name = parent .. "/" .. data.name
            end
          end

          display_name = truncate(display_name, max_len)

          local is_current = cur_buf == nr
          local hl = is_current and "TbBufOn" or "TbBufOff"
          local close_hl = is_current and "TbBufOnClose" or "TbBufOffClose"

          -- Buffer name: click to switch to buffer
          local buf = "%" .. nr .. "@TbGoToBuf@"
          buf = buf .. "%#" .. hl .. "# " .. display_name .. " "

          -- Close button: IMPORTANT:
          -- Pass the buffer number to TbKillBuf as minwid.
          buf = buf .. "%" .. nr .. "@TbKillBuf@"
          buf = buf .. "%#" .. close_hl .. "#• "
          buf = buf .. "%X"

          table.insert(buffers, buf)
        end

        return table.concat(buffers) .. txt("%=", "Fill")
      end,
    },
  },
}

return M
