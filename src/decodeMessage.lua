local Stream = require(script.Parent.Stream)
local stableKeys = require(script.Parent.stableKeys)
local decode128 = require(script.Parent.var128).decode

local decodeAny

local function decodeUInt(stream)
	return decode128(stream)
end

local function decodeInt(stream)
	local n = decode128(stream)
	if n % 2 == 0 then -- zigzag
		return n / 2
	else
		return -(n + 1) / 2
	end
end

local function decodeFloat(stream)
	local str = string.char(stream.byte(4))
	return string.unpack("f", str)
end

local function decodeDouble(stream)
	local str = string.char(stream.byte(8))
	return string.unpack("d", str)
end

local function decodeString(stream)
	local len = decode128(stream)
	local out = {}
	for i = 1, len do
		out[i] = string.char(stream.byte())
	end
	return table.concat(out)
end

local function decodeBool(stream)
	return stream.byte() == 1
end

local function decodeArray(entry, stream)
	local len = decode128(stream)
	local out = {}
	for i = 1, len do
		out[i] = decodeAny(entry.valueType, stream)
	end
	return out
end

local function decodeMessage(message, input)
	local keys = stableKeys(message.data)
	local stream = input
	if typeof(input) == "string" then
		stream = Stream(input)
	end

	local numOptionalKeys = 0
	for _, key in ipairs(keys) do
		local entry = message.data[key]
		if entry.default ~= nil then
			numOptionalKeys += 1
		end
	end

	local isDefault = {}
	if numOptionalKeys > 0 then
		local defaultFlags = decode128(stream)
		for i = 1, numOptionalKeys do
			local pow = numOptionalKeys - i
			local flag = math.floor(defaultFlags / 2 ^ pow) % 2 == 1
			isDefault[keys[i]] = flag
		end
	end

	local out = {}
	for _, key in ipairs(keys) do
		local entry = message.data[key]
		if isDefault[key] then
			out[key] = entry.default
		else
			out[key] = decodeAny(entry, stream)
		end
	end

	return out
end

function decodeAny(entry, stream)
	if entry.type == "int" then
		return decodeInt(stream)
	elseif entry.type == "uint" then
		return decodeUInt(stream)
	elseif entry.type == "float" then
		return decodeFloat(stream)
	elseif entry.type == "double" then
		return decodeDouble(stream)
	elseif entry.type == "string" then
		return decodeString(stream)
	elseif entry.type == "bool" then
		return decodeBool(stream)
	elseif entry.type == "array" then
		return decodeArray(entry, stream)
	elseif entry.type == "message" then
		return decodeMessage(entry, stream)
	end
end

return decodeMessage
