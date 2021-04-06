local RepStore = game:GetService("ReplicatedStorage")
local hexDump = require(RepStore.hexDump)

local Packet = require(RepStore.Vendor.Packet)
local T = Packet.Type

local EnemySpawn = T.Message({
	id = T.UInt,
	name = T.String,
})

local packed = EnemySpawn.encode({
	id = 1,
	name = "test",
})

local unpacked = EnemySpawn.decode(packed)

print(string.format("packed %i bytes", #packed))
print(hexDump(packed))
print()
print("unpacked data:", unpacked)
