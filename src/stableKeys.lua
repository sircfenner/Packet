-- stable sorting of string keys
-- keys corresponding to optional values are sorted first
-- after this, keys are sorted alphabetically

local function stableKeys(data)
	local keys = {}
	for key in pairs(data) do
		table.insert(keys, key)
	end

	table.sort(keys, function(key0, key1)
		local opt0 = data[key0].default ~= nil
		local opt1 = data[key1].default ~= nil
		if opt0 ~= opt1 then
			return opt0
		end
		return key0 < key1
	end)

	return keys
end

return stableKeys
