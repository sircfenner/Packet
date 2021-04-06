local function hexDump(raw)
	local out = {}
	for i = 1, #raw do
		out[i] = string.format("%02x", raw:byte(i))
	end
	return "<" .. table.concat(out, " ") .. ">"
end

return hexDump
