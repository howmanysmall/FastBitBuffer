# FastBitBuffer

This is currently the fastest BitBuffer for Roblox. It is around 65-75% faster than any of the competition. If you have any possible ideas to make it faster, feel free to make a pull request.

## Usage

To use this BitBuffer, just copy the source of the [init.lua](https://github.com/howmanysmall/FastBitBuffer/blob/master/src/init.lua) file to a ModuleScript, and require it.

![FastBitBuffer Setup](https://raw.githubusercontent.com/howmanysmall/FastBitBuffer/master/docs/FastBitBufferSetup.png)

To actually use the BitBuffer, you need to use the following API.

## API

This is the API of the BitBuffer. Every function has a lowerCamelCase equivalent to it.

<details>
<summary><code>function BitBuffer.new()</code></summary>

Creates a new BitBuffer.

**Returns:**  
[BitBuffer] The new BitBuffer.

</details>

<details>
<summary><code>function BitBuffer:ResetPointer()</code></summary>

Resets the BitBuffer's BitPointer.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:Reset()</code></summary>

Resets the BitBuffer's BitPointer and buffer table.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:FromString(String)</code></summary>

Reads the given string and writes to the BitBuffer accordingly. Not really useful.

**Parameters:**
- `String` (`string`)  
The string.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ToString()</code></summary>

Writes the BitBuffer to a string.

**Returns:**  
`string`  
The BitBuffer string.

</details>

<details>
<summary><code>function BitBuffer:FromBase64(String)</code></summary>

Reads the given Base64 string and writes to the BitBuffer accordingly.

**Parameters:**
- `String` (`string`)  
The Base64 string.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ToBase64()</code></summary>

Writes the BitBuffer to a Base64 string.

**Returns:**  
`string`  
The BitBuffer encoded in Base64.

</details>

<details>
<summary><code>function BitBuffer:FromBase128(String)</code></summary>

Reads the given Base128 string and writes to the BitBuffer accordingly. Not recommended. Credit to Defaultio for the original functions.

**Parameters:**
- `String` (`string`)  
The Base128 string.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ToBase128()</code></summary>

Writes the BitBuffer to Base128. Not recommended. Credit to Defaultio for the original functions.

**Returns:**  
`string`  
The BitBuffer encoded in Base128.

</details>

<details>
<summary><code>function BitBuffer:Dump()</code></summary>

Dumps the BitBuffer data and prints it.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:WriteUnsigned(Width, Value)</code></summary>

Writes an unsigned number to the BitBuffer.

**Parameters:**
- `Width` (`integer`)  
The bit width of the value.
- `Value` (`integer`)  
The unsigned integer.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ReadUnsigned(Width)</code></summary>

Reads an unsigned integer from the BitBuffer.

**Parameters:**
- `Width` (`integer`)  
The bit width of the value.

**Returns:**  
`integer`  
The unsigned integer.

</details>

<details>
<summary><code>function BitBuffer:WriteSigned(Width, Value)</code></summary>

Writes a signed integer to the BitBuffer.

**Parameters:**
- `Width` (`integer`)  
The bit width of the value.
- `Value` (`integer`)  
The signed integer.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ReadSigned(Width)</code></summary>

Reads a signed integer from the BitBuffer.

**Parameters:**
- `Width` (`integer`)  
The bit width of the value.

**Returns:**  
`integer`  
The signed integer.

</details>

<details>
<summary><code>function BitBuffer:WriteString(String)</code></summary>

Writes a string to the BitBuffer.

**Parameters:**
- `String` (`string`)  
The string you are writing to the BitBuffer.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ReadString()</code></summary>

Reads the BitBuffer for a string.

**Returns:**  
`string`  
The string written to the BitBuffer.

</details>

<details>
<summary><code>function BitBuffer:WriteBool(Boolean)</code></summary>

Writes a boolean to the BitBuffer.

**Parameters:**
- `Boolean` (`boolean`)  
The value you are writing to the BitBuffer.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ReadBool()</code></summary>

Reads the BitBuffer for a boolean.

**Returns:**  
`boolean`  
The boolean.

</details>

<details>
<summary><code>function BitBuffer:WriteFloat(Fraction, WriteExponent, Float)</code></summary>

Writes a float to the BitBuffer.

**Parameters:**
- `Fraction` (`integer`)  
The number of bits (probably).
- `WriteExponent` (`integer`)  
The number of bits for the decimal (probably).
- `Float` (`number`)  
The actual number you are writing.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ReadFloat(Fraction, WriteExponent)</code></summary>

Reads a float from the BitBuffer.

**Parameters:**
- `Fraction` (`integer`)  
The number of bits (probably).
- `WriteExponent` (`integer`)  
The number of bits for the decimal (probably).

**Returns:**  
`number`  
The float.

</details>

<details>
<summary><code>function BitBuffer:WriteFloat8(Float)</code></summary>

Writes a float8 (quarter precision) to the BitBuffer.

**Parameters:**
- `The` (`number`)  
float8.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ReadFloat8()</code></summary>

Reads a float8 (quarter precision) from the BitBuffer.

**Returns:**  
`number`  
The float8.

</details>

<details>
<summary><code>function BitBuffer:WriteFloat16(Float)</code></summary>

Writes a float16 (half precision) to the BitBuffer.

**Parameters:**
- `The` (`number`)  
float16.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ReadFloat16()</code></summary>

Reads a float16 (half precision) from the BitBuffer.

**Returns:**  
`number`  
The float16.

</details>

<details>
<summary><code>function BitBuffer:WriteFloat32(Float)</code></summary>

Writes a float32 (single precision) to the BitBuffer.

**Parameters:**
- `The` (`number`)  
float32.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ReadFloat32()</code></summary>

Reads a float32 (single precision) from the BitBuffer.

**Returns:**  
`number`  
The float32.

</details>

<details>
<summary><code>function BitBuffer:WriteFloat64(Float)</code></summary>

Writes a float64 (double precision) to the BitBuffer.

**Parameters:**
- `The` (`number`)  
float64.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ReadFloat64()</code></summary>

Reads a float64 (double precision) from the BitBuffer.

**Returns:**  
`number`  
The float64.

</details>

<details>
<summary><code>function BitBuffer:WriteBrickColor(Color)</code></summary>

[DEPRECATED] Writes a BrickColor to the BitBuffer.

**Parameters:**
- `Color` (`BrickColor`)  
The BrickColor you are writing to the BitBuffer.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ReadBrickColor()</code></summary>

[DEPRECATED] Reads a BrickColor from the BitBuffer.

**Returns:**  
`BrickColor`  
The BrickColor read from the BitBuffer.

</details>

<details>
<summary><code>function BitBuffer:WriteRotation(CoordinateFrame)</code></summary>

Writes the rotation part of a CFrame into the BitBuffer.

**Parameters:**
- `CoordinateFrame` (`CFrame`)  
The CFrame you wish to write.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ReadRotation()</code></summary>

Reads the rotation part of a CFrame saved in the BitBuffer.

**Returns:**  
`CFrame`  
The rotation read from the BitBuffer.

</details>

<details>
<summary><code>function BitBuffer:WriteColor3(Color)</code></summary>

Writes a Color3 to the BitBuffer.

**Parameters:**
- `Color` (`Color3`)  
The color you want to write into the BitBuffer.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ReadColor3()</code></summary>

Reads a Color3 from the BitBuffer.

**Returns:**  
`Color3`  
The color read from the BitBuffer.

</details>

<details>
<summary><code>function BitBuffer:WriteVector3(Vector)</code></summary>

Writes a Vector3 to the BitBuffer. Writes with Float32 precision.

**Parameters:**
- `Vector` (`Vector3`)  
The vector you want to write into the BitBuffer.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ReadVector3()</code></summary>

Reads a Vector3 from the BitBuffer. Uses Float32 precision.

**Returns:**  
`Vector3`  
The vector read from the BitBuffer.

</details>

<details>
<summary><code>function BitBuffer:WriteCFrame(CoordinateFrame)</code></summary>

Writes a full CFrame (position and rotation) to the BitBuffer. Uses Float64 precision.

**Parameters:**
- `CoordinateFrame` (`CFrame`)  
The CFrame you are writing to the BitBuffer.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ReadCFrame()</code></summary>

Reads a full CFrame (position and rotation) from the BitBuffer. Uses Float64 precision.

**Returns:**  
`CFrame`  
The CFrame you are reading from the BitBuffer.

</details>

<details>
<summary><code>function BitBuffer:WriteVector2(Vector)</code></summary>

Writes a Vector2 to the BitBuffer. Writes with Float32 precision.

**Parameters:**
- `Vector` (`Vector2`)  
The vector you want to write into the BitBuffer.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ReadVector2()</code></summary>

Reads a Vector2 from the BitBuffer. Uses Float32 precision.

**Returns:**  
`Vector2`  
The vector read from the BitBuffer.

</details>

<details>
<summary><code>function BitBuffer:WriteUDim2(Value)</code></summary>

Writes a UDim2 to the BitBuffer. Uses Float32 precision for the scale.

**Parameters:**
- `Value` (`UDim2`)  
The UDim2 you are writing to the BitBuffer.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ReadUDim2()</code></summary>

Reads a UDim2 from the BitBuffer. Uses Float32 precision for the scale.

**Returns:**  
`UDim2`  
The UDim2 read from the BitBuffer.

</details>

<details>
<summary><code>function BitBuffer:WriteVector3Float64(Vector)</code></summary>

Writes a Vector3 to the BitBuffer. Writes with Float64 precision.

**Parameters:**
- `Vector` (`Vector3`)  
The vector you want to write into the BitBuffer.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ReadVector3Float64()</code></summary>

Reads a Vector3 from the BitBuffer. Reads with Float64 precision.

**Returns:**  
`Vector3`  
The vector read from the BitBuffer.

</details>

<details>
<summary><code>function BitBuffer:WriteVector2Float64(Vector)</code></summary>

Writes a Vector2 to the BitBuffer. Writes with Float64 precision.

**Parameters:**
- `Vector` (`Vector2`)  
The vector you want to write into the BitBuffer.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer:ReadVector2Float64()</code></summary>

Reads a Vector2 from the BitBuffer. Reads with Float64 precision.

**Returns:**  
`Vector2`  
The vector read from the BitBuffer.

</details>

<details>
<summary><code>function BitBuffer:Destroy()</code></summary>

Destroys the BitBuffer metatable.

**Returns:**  
[void]

</details>

<details>
<summary><code>function BitBuffer.BitsNeeded(Number)</code></summary>

Calculates the amount of bits needed for a given number.

**Parameters:**
- `Number` (`number`)  
The number you want to use.

**Returns:**  
`number`  
The amount of bits needed.

</details>

## Example Code

This isn't actually recommended for use, as it's full of bad practices. The intention of it is to show you how the API is used. I recommend using one of the options listed below in the DataStoreService modules section.

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

## DataStoreService Modules

- [DataStore2](https://github.com/Kampfkarren/Roblox/tree/master/DataStore2) - Very popular for a reason. To learn how to use it, I recommend either reading the [docs](https://kampfkarren.github.io/Roblox/) or [asking on the DevForum post](https://devforum.roblox.com/t/how-to-use-datastore2-data-store-caching-and-data-loss-prevention/136317).
- [Nevermore DataStores](https://github.com/Quenty/NevermoreEngine/tree/version2/Modules/Server/DataStore) - A very good module system. Uses other modules in Nevermore, so beware. To learn how to use it, read the [readme file](https://github.com/Quenty/NevermoreEngine/blob/version2/Modules/Server/DataStore/README.md).

## Credits

- Defaultio - created the original Base128 module I based this on.
- TheNexusAvenger - Created some of the float functions.
- Stravant - Created the original module itself.
