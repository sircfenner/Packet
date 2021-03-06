local RepStore = game:GetService("ReplicatedStorage")
local hexDump = require(RepStore.hexDump)

local Packet = require(RepStore.Vendor.Packet)
local T = Packet.Type

local Player = T.Message({
	id = T.UInt,
	name = T.String,
	alive = T.Bool(true),
	friends = T.Array(T.String),
})

local packed = Player.encode({
	id = 5,
	name = "foo",
	friends = { "bar", "baz" },
})

local unpacked = Player.decode(packed)

print(string.format("packed %i bytes", #packed))
print(hexDump(packed))

print("unpacked data:", unpacked)
