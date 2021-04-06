local stableKeys = require(script.Parent.stableKeys)
local encode128 = require(script.Parent.var128).encode

local Default = newproxy(true)
getmetatable(Default).__tostring = function()
	return "<Default>"
end

local function getValue(entry, value)
	if value ~= nil then
		if value == entry.default then
			return Default
		else
			return value
		end
	elseif entry.default ~= nil then
		return Default
	end
	error("no value, no default")
end

local encodeAny = nil

local function encodeUInt(value)
	return encode128(value)
end

local function encodeInt(value)
	local adjusted = bit32.bxor(bit32.lshift(value, 1), bit32.arshift(value, 31))
	return encode128(adjusted)
end

local function encodeFloat(value)
	return string.pack("f", value)
end

local function encodeDouble(value)
	return string.pack("d", value)
end

local function encodeString(value)
	return encode128(#value) .. value
end

local function encodeBool(value)
	return string.char(value and 1 or 0)
end

local function encodeArray(entry, value)
	local out = {}
	for i, item in ipairs(value) do
		out[i] = encodeAny(entry.valueType, item)
	end
	return encode128(#value) .. table.concat(out)
end

local function encodeMessage(message, content)
	local keys = stableKeys(message.data)

	local outBody = {}
	local outDefault = 0
	for _, key in ipairs(keys) do
		local entry = message.data[key]
		local value = getValue(entry, content[key])
		if entry.default ~= nil then
			outDefault *= 2
		end
		if value == Default then
			outDefault += 1
		else
			table.insert(outBody, encodeAny(entry, value))
		end
	end

	return encode128(outDefault) .. table.concat(outBody)
end

function encodeAny(entry, value)
	if entry.type == "int" then
		return encodeInt(value)
	elseif entry.type == "uint" then
		return encodeUInt(value)
	elseif entry.type == "float" then
		return encodeFloat(value)
	elseif entry.type == "double" then
		return encodeDouble(value)
	elseif entry.type == "string" then
		return encodeString(value)
	elseif entry.type == "bool" then
		return encodeBool(value)
	elseif entry.type == "array" then
		return encodeArray(entry, value)
	elseif entry.type == "message" then
		return encodeMessage(entry, value)
	end
end

return encodeMessage
