local encodeMessage = require(script.Parent.encodeMessage)
local decodeMessage = require(script.Parent.decodeMessage)

local function makeEncoder(message)
	return function(input)
		return encodeMessage(message, input)
	end
end

local function makeDecoder(message)
	return function(raw)
		return decodeMessage(message, raw)
	end
end

local function callable(item) -- e.g. T.String -> T.String()
	if type(item) == "function" then
		return item()
	end
	return item
end

local function defaultable(type)
	return function(default)
		return {
			type = type,
			default = default,
		}
	end
end

local function Array(valueType)
	return {
		type = "array",
		valueType = callable(valueType),
	}
end

local function Message(data)
	local newData = {}
	for key, val in pairs(data) do
		newData[key] = callable(val)
	end

	local object = {}
	object.type = "message"
	object.data = newData
	object.encode = makeEncoder(object)
	object.decode = makeDecoder(object)

	return object
end

return {
	String = defaultable("string"),
	Int = defaultable("int"),
	UInt = defaultable("uint"),
	Float = defaultable("float"),
	Bool = defaultable("bool"),
	Array = Array,
	Message = Message,
}
