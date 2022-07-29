local P = require("highlights.palette")

return {
	Normal = { fg = P.fg, bg = P.bg },
	NormalFloat = { fg = P.fg, bg = P.bg },
	NormalNC = { fg = P.fg, bg = P.none },
	Terminal = { fg = P.fg, bg = P.bg },
	SignColumn = { fg = P.fg, bg = P.bg },
	FoldColumn = { fg = P.fg_alt, bg = P.black },
	VertSplit = { fg = P.darker_blue, bg = P.bg },
	LineNr = { fg = P.base5, bg = P.none },
  IncSearch = { fg = P.bg, bg = P.error_red, style = P.none },
  Search = { fg = P.bg, bg = P.error_red },

	TelescopeNormal = { fg = P.fg },
	TelescopeBorder = { fg = P.blue, bg = P.bg },
	TelescopeResultsBorder = { fg = P.blue, bg = P.bg },
	TelescopePromptBorder = { fg = P.blue, bg = P.bg },
	TelescopePreviewBorder = { fg = P.magenta, bg = P.bg },
	TelescopeMatching = { fg = P.yellowgreen, style = "bold" },
	TelescopeSelection = { fg = P.cyan, style = "bold" },
	TelescopeSelectionCaret = { fg = P.yellow },
	TelescopeMultiSelection = { fg = P.light_green },
	TelescopePromptPrefix = { fg = P.yellow },

	WhichKey = { fg = P.pink },
	WhichKeyName = { fg = P.yellow },
	WhichKeyTrigger = { fg = P.black },
	WhichKeyFloat = { fg = P.red, bg = P.bg },
	WhichKeySeperator = { fg = P.yellowgreen },
	WhichKeyGroup = { fg = P.pale_blue },
	WhichKeyDesc = { fg = P.dark_cyan },
}
