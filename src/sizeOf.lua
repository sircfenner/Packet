local function sizeOf(n)
	if n < 0x100 then
		return 1
	elseif n < 0x10000 then
		return 2
	elseif n < 0x1000000 then
		return 3
	elseif n < 0x100000000 then
		return 4
	end
end

return sizeOf
