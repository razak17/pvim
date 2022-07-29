return function()
	local ok, ajk = pcall(require, "accelerated-jk")
	if not ok then
		return
	end

	ajk.setup({
		mappings = { j = "gj", k = "gk" },
		-- If the interval of key-repeat takes more than `acceleration_limit` ms, the step is reset
		-- acceleration_limit = 150,
	})
end
