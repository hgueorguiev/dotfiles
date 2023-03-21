local M = {}
local core = require("user.quickfix_actually.quickfix_actually")

function M.setup()
	core.tmp_do_all()
end

-- Start with defaults
M.setup()
return M
