local source = {}
local items = {}
local regs = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"=*+'

source.get_items = function()
	items = {}
	for i = 1, #regs do
		local reg = regs:sub(i, i)
		local reg_content = vim.fn.getreg(reg)
		if reg_content ~= "" then
			items[#items + 1] = {
				label = '"' .. reg .. reg_content,
				insertText = reg_content,
			}
		end
	end
end

source.get_items()

vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {callback = source.get_items})

function source:is_available()
	return true
end

function source:get_debug_name()
	return "registers"
end

source.get_trigger_characters = function()
	return { '"' }
end

source.get_keyword_pattern = function()
	return [=[\%(\s\|^\)\zs"[[:alnum:]_\-\+]*]=]
end

function source:complete(params, callback)
  -- if not vim.regex(self.get_keyword_pattern() .. '$'):match_str(params.context.cursor_before_line) then
  --   return callback()
  -- end
	callback(items)
end

require('cmp').register_source('registers', source)
