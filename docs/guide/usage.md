The purpose of this module is to save and load data with an incredible compression ratio. The basic usage of it can be seen in the following code.

What this code does is:

- Checks if the Player already has Leaderstats when the PlayerAdded function is called.
- If they don't have it, create a new BitBuffer.
- After the BitBuffer is created, check if they have any data saved on the DataStore. If they don't have any, set their data to the default created at the start of the script.
- Loads their data from the Base64 string that is stored in the DataStore using `FromBase64`.
- Create the Leaderstats using the `LoadFromBitBuffer`, which reads the Color3 first, and then the unsigned number second because that's what order they are stored in.
- Parents the Leaderstats returned by `LoadFromBitBuffer` to the Player.
- When the player leaves, check if they have Leaderstats. If they do, create a new BitBuffer.
- Run the `SaveToBitBuffer` function, which calls `WriteColor3` first followed by `WriteUnsigned`.
- Sets the new data using `SetAsync` and `ToBase64`. Once that is complete, we call `Destroy` on the BitBuffer and set it to nil.

!!! important
	The order of which you read and write does matter. If you don't follow the same order, your data will not be correct.

!!! error
	I do not recommend using the data saving part of this example in your code. Instead, it's suggested to use either [DataStore2](https://kampfkarren.github.io/Roblox/) or [Quenty's DataStore system](https://github.com/Quenty/NevermoreEngine/tree/version2/Modules/Server/DataStore).

```Lua
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local DataStoreService = game:GetService("DataStoreService")
local FastBitBuffer = require(ServerStorage.FastBitBuffer)

local USER_DATA = {"FavoriteColor", "Stage"}
local TOTAL_STAGES = 400
local BITS_REQUIRED = FastBitBuffer.BitsRequired(TOTAL_STAGES)
local DEFAULT_DATA do
	local BitBuffer = FastBitBuffer.new()
	BitBuffer:WriteColor3(Color3.new())
	BitBuffer:WriteUnsigned(BITS_REQUIRED, 1)
	DEFAULT_DATA = BitBuffer:ToBase64()

	BitBuffer:Destroy()
	BitBuffer = nil
end

local GameDataStore = DataStoreService:GetDataStore("GameDataStore")

local function SaveToBitBuffer(BitBuffer, Leaderstats)
	for _, ValueName in ipairs(USER_DATA) do
		assert(Leaderstats:FindFirstChild(ValueName), string.format("Expected ValueObject %s to exist but it doesn't.", ValueName))
	end

	BitBuffer:WriteColor3(Leaderstats.FavoriteColor.Value)
	BitBuffer:WriteUnsigned(BITS_REQUIRED, Leaderstats.Stage.Value)
end

local function LoadFromBitBuffer(BitBuffer)
	local Leaderstats = Instance.new("Folder")
	Leaderstats.Name = "Leaderstats"

	local FavoriteColor = Instance.new("Color3Value")
	FavoriteColor.Name = "FavoriteColor"
	FavoriteColor.Value = BitBuffer:ReadColor3()
	FavoriteColor.Parent = Leaderstats

	local Stage = Instance.new("IntValue")
	Stage.Name = "Stage"
	Stage.Value = BitBuffer:ReadUnsigned(BITS_REQUIRED)
	Stage.Parent = Leaderstats

	return Leaderstats
end

local function PlayerAdded(Player)
	if not Player:FindFirstChild("Leaderstats") then
		local BitBuffer = FastBitBuffer.new()
		local Success, PlayerData = pcall(GameDataStore.GetAsync, GameDataStore, Player.UserId)
		if Success then
			if not PlayerData then
				PlayerData = DEFAULT_DATA
				pcall(GameDataStore.SetAsync, GameDataStore, Player.UserId, PlayerData)
			end

			BitBuffer:FromBase64(PlayerData)

			local Leaderstats = LoadFromBitBuffer(BitBuffer)
			Leaderstats.Parent = Player

			BitBuffer:Destroy()
			BitBuffer = nil
		end
	end
end

local function PlayerRemoving(Player)
	local Leaderstats = Player:FindFirstChild("Leaderstats")
	if Leaderstats then
		local BitBuffer = FastBitBuffer.new()
		SaveToBitBuffer(BitBuffer, Leaderstats)
		local Success, Error = pcall(GameDataStore.SetAsync, GameDataStore, Player.UserId, BitBuffer:ToBase64())
		if not Success and Error then warn("Failed to save PlayerData!", Error) end

		BitBuffer:Destroy()
		BitBuffer = nil
	end
end

Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(PlayerRemoving)
for _, Player in ipairs(Players:GetPlayers()) do PlayerAdded(Player) end
```
