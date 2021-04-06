local function Stream(raw)
	local idx = 1
	local function eof()
		return idx > #raw
	end
	local function peek()
		return raw:byte(idx)
	end
	local function byte(n)
		n = n or 1
		idx += n
		return raw:byte(idx - n, idx - 1)
	end
	return {
		eof = eof,
		peek = peek,
		byte = byte,
	}
end

return Stream
