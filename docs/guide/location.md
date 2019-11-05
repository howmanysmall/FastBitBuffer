This page will show you how to save the player's last location using FastBitBuffer and [DataStore2](https://kampfkarren.github.io/Roblox/). This assumes you already have it installed and it is located in `ServerStorage`. If you want to see it in action, the place is [right here](https://www.roblox.com/games/4154966583).

```Lua
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local DataStore2 = require(ServerStorage.DataStore2)
local FastBitBuffer = require(ServerStorage.FastBitBuffer)

local DATA_STORE_NAME = "LastPlayerLocation"
local RAISED_VECTOR3 = Vector3.new(0, 3, 0)
local DEFAULT_PLAYER_SPAWN_CFRAME = CFrame.new(0, 6, 0)

local DEFAULT_PLAYER_SPAWN_BASE64 do
	local BitBuffer = FastBitBuffer.new()
	BitBuffer:WriteCFrame(DEFAULT_PLAYER_SPAWN_CFRAME)
	DEFAULT_PLAYER_SPAWN_BASE64 = BitBuffer:ToBase64()

	BitBuffer:Destroy()
	BitBuffer = nil
end

local PlayerLocations = {}

local function BeforeInitialGet(Serialized)
	local BitBuffer = FastBitBuffer.new()
	BitBuffer:FromBase64(Serialized)

	local Deserialized = BitBuffer:ReadCFrame()
	BitBuffer:Destroy()
	BitBuffer = nil

	return Deserialized
end

local function BeforeSave(Deserialized)
	local BitBuffer = FastBitBuffer.new()
	BitBuffer:WriteCFrame(Deserialized)

	local Serialized = BitBuffer:ToBase64()
	BitBuffer:Destroy()
	BitBuffer = nil

	return Serialized
end

local function OnUpdate(Player)
	return function(PlayerLocation)
		PlayerLocations[Player] = PlayerLocation
	end
end

local function CharacterRemoving(Player)
	return function(Character)
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		if Humanoid and Humanoid.Health > 0 then
			local PlayerLocation = DataStore2(DATA_STORE_NAME, Player)
			PlayerLocation:Set(Character:GetPrimaryPartCFrame())
		end
	end
end

local function PlayerAdded(Player)
	if not PlayerLocations[Player] then
		Player.CharacterRemoving:Connect(CharacterRemoving(Player))

		local PlayerLocation = DataStore2(DATA_STORE_NAME, Player)
		PlayerLocation:BeforeInitialGet(BeforeInitialGet)
		PlayerLocation:BeforeSave(BeforeSave)
		PlayerLocation:OnUpdate(OnUpdate(Player))

		local DefaultLocation = PlayerLocation:Get(DEFAULT_PLAYER_SPAWN_BASE64)
		if type(DefaultLocation) == "string" then
			DefaultLocation = BeforeInitialGet(DefaultLocation)
		end

		local Character = Player.Character or Player.CharacterAdded:Wait()
		Character:WaitForChild("HumanoidRootPart")
		Character:SetPrimaryPartCFrame(DefaultLocation + RAISED_VECTOR3)
	end
end

local function PlayerRemoving(Player)
	if PlayerLocations[Player] then
		PlayerLocations[Player] = nil
	end
end

Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(PlayerRemoving)
for _, Player in ipairs(Players:GetPlayers()) do PlayerAdded(Player) end
```
