local RepStore = game:GetService("ReplicatedStorage")
local hexDump = require(RepStore.hexDump)

local Packet = require(RepStore.Vendor.Packet)
local T = Packet.Type

local Test = T.Message({
	name = T.String,
	age = T.UInt,
	alive = T.Bool(true),
})

local packed = Test.encode({
	name = "foo",
	age = 41,
})

print(string.format("packed %i bytes", #packed))
print(hexDump(packed))

local unpacked = Test.decode(packed)

print("unpacked data:", unpacked)
