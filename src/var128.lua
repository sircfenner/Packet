local function encode(n)
	local out = {}
	local i = 1
	while n >= 0x80 do
		local b = n % 0x80
		n = (n - b) / 0x80
		out[i] = b + 0x80
		i += 1
	end
	out[i] = n
	return string.char(unpack(out))
end

local function decode(stream)
	local n = 0
	local i = 0
	while not stream.eof() do
		local b = stream.byte()
		if b < 0x80 then
			n += b * 0x80 ^ i
			break
		end
		n += (b - 0x80) * 0x80 ^ i
		i += 1
	end
	return n
end

return {
	encode = encode,
	decode = decode,
}
