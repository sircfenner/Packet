local RepStore = game:GetService("ReplicatedStorage")

local Packet = require(RepStore.Vendor.Packet)
local T = Packet.Type

local User = T.Message({
	id = T.UInt,
	name = T.String,
})

local packed = User.encode({
	id = 941072,
	name = "sircfenner",
})

local unpacked = User.decode(packed)

print(string.format("packed %i bytes", #packed))
print("unpacked data:", unpacked)
