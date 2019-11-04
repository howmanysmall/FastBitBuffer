--[[

Differences from the original:
	Using metatables instead of a function returning a table.
	Added Vector3, Color3, Vector2, and UDim2 support.
	Deprecated BrickColors.
	Changed the creation method from BitBuffer.Create to BitBuffer.new.
	OPTIMIZED!
	Added a ::Destroy method.

Constructor: BitBuffer.new()

Read/Write pairs for reading data from or writing data to the BitBuffer:
	BitBuffer::WriteUnsigned(BitWidth: number, Value: number): void
	BitBuffer::ReadUnsigned(BitWidth: number): number
		Read / Write an unsigned value with a given number of bits. The
		value must be a positive integer. For instance, if BitWidth is
		4, then there will be 4 magnitude bits, for a value in the
		range [0, 2 ^ 4 - 1] = [0, 15]

	BitBuffer::WriteSigned(BitWidth: number, Value: number): void
	BitBuffer::ReadSigned(BitWidth: number): number
		Read / Write a a signed value with a given number of bits. For
		instance, if BitWidth is 4 then there will be 1 sign bit and
		3 magnitude bits, a value in the range [-2 ^ 3 + 1, 2 ^ 3 - 1] = [-7, 7]

	BitBuffer:WriteFloat(MantissaBitWidth: number, ExponentBitWidth: number, Value: number): void
	BitBuffer:ReadFloat(MantissaBitWidth, ExponentBitWidth): number
		Read / Write a floating point number with a given mantissa and
		exponent size in bits.

	BitBuffer::WriteFloat8(Float: number): void
	BitBuffer::ReadFloat8(): number

	BitBuffer::WriteFloat16(Float: number): void
	BitBuffer::ReadFloat16(): number

	BitBuffer::WriteFloat32(Float: number): void
	BitBuffer::ReadFloat32(): number

	BitBuffer::WriteFloat64(Float: number): void
	BitBuffer::ReadFloat64(): number
		Read and write the common types of floating point number that
		are used in code. If you want to 100% accurately save an
		arbitrary Lua number, then you should use the Float64 format. If
		your number is known to be smaller, or you want to save space
		and don't need super high precision, then a Float32 will often
		suffice. For instance, the Transparency of an object will do
		just fine as a Float32.

	BitBuffer::WriteBool(Boolean: boolean): void
	BitBuffer::ReadBool(): boolean
		Read / Write a boolean (true / false) value. Takes one bit worth of space to store.

	BitBuffer::WriteString(String: string): void
	BitBuffer::ReadString(): string
		Read / Write a variable length string. The string may contain embedded nulls.
		Only 7 bits / character will be used if the string contains no non-printable characters (greater than 0x80).

	****** PLEASE DON'T USE THIS. USE ::WRITECOLOR3 INSTEAD. ******
	BitBuffer::WriteBrickColor(Color: BrickColor): void
	BitBuffer::ReadBrickColor(): BrickColor
		Read / Write a Roblox BrickColor. Provided as an example of reading / writing a derived data type.
		Please don't actually use this, just use ::WriteColor3 instead.

	BitBuffer::WriteColor3(Color: Color3): void
	BitBuffer::ReadColor3(): Color3
		Read / Write a Roblox Color3. Use this over the BrickColor methods, PLEASE.

	BitBuffer::WriteRotation(CoordinateFrame: CFrame): void
	BitBuffer::ReadRotation(): CFrame
		Read / Write the rotation part of a given CFrame. Encodes the
		rotation in question into 64bits, which is a good size to get
		a pretty dense packing, but still while having errors well within
		the threshold that Roblox uses for stuff like MakeJoints()
		detecting adjacency. Will also perfectly reproduce rotations which
		are orthagonally aligned, or inverse-power-of-two rotated on only
		a single axix. For other rotations, the results may not be
		perfectly stable through read-write cycles (if you read/write an
		arbitrary rotation thousands of times there may be detectable
		"drift")

	BitBuffer::WriteVector3(Vector: Vector3): void
	BitBuffer::ReadVector3(): Vector3
	BitBuffer::WriteVector3Float32(Vector: Vector3): void
	BitBuffer::ReadVector3Float32(): Vector3
		Read / write a Vector3. Encodes the vector using 32-bit precision.
		For more precision, use BitBuffer::WriteVector3Float64 instead.

	BitBuffer::WriteVector3Float64(Vector: Vector3): void
	BitBuffer::ReadVector3Float64(): Vector3
		Read / write a Vector3. Encodes the vector using 64-bit precision.
		For less precision, use BitBuffer::WriteVector3 instead.

	BitBuffer::WriteVector2(Vector: Vector2): void
	BitBuffer::ReadVector2(): Vector2
	BitBuffer::WriteVector2Float32(Vector: Vector2): void
	BitBuffer::ReadVector2Float32(): Vector2
		Read / write a Vector2. Encodes the vector using 32-bit precision.
		For more precision, use BitBuffer::WriteVector2Float64 instead.

	BitBuffer::WriteVector2Float64(Vector: Vector2): void
	BitBuffer::ReadVector2Float64(): Vector2
		Read / write a Vector2. Encodes the vector using 64-bit precision.
		For less precision, use BitBuffer::WriteVector2Float32 instead.

	BitBuffer::WriteCFrame(CoordinateFrame: CFrame): void
	BitBuffer::ReadCFrame(): CFrame
		Read / write the whole CFrame. This will call both ::WriteVector3Float64 and ::WriteRotation
		to save the entire CFrame, and encodes it using 64-bit precision.

	BitBuffer::WriteUDim2(Value: UDim2): void
	BitBuffer::ReadUDim2(): UDim2
		Read / write a UDim2. Encodes the value using 32-bit precision.

From/To pairs for dumping out the BitBuffer to another format:
	BitBuffer::ToString(): string
	BitBuffer::FromString(String: string): void
		Will replace / dump out the contents of the buffer to / from
		a binary chunk encoded as a Lua string. This string is NOT
		suitable for storage in the Roblox DataStores, as they do
		not handle non-printable characters well.

	BitBuffer::ToBase64(): string
	BitBuffer::FromBase64(String: string): void
		Will replace / dump out the contents of the buffer to / from
		a set of Base64 encoded data, as a Lua string. This string
		only consists of Base64 printable characters, so it is
		ideal for storage in Roblox DataStores.

	BitBuffer::ToBase128(): string
	BitBuffer::FromBase128(String: string): void
		Defaultio added this function. 128 characters can all be written
		to DataStores, so this function packs more tightly than saving
		in only 64 bit strings. Full disclosure: I have no idea what I'm
		doing but I think this is useful.

Buffer / Position Manipulation
	BitBuffer::ResetPointer(): void
		Will Reset the point in the buffer that is being read / written
		to back to the start of the buffer.

	BitBuffer::Reset(): void
		Will reset the buffer to a clean state, with no contents.

Example Usage:
	local function SaveToBuffer(buffer, userData)
		buffer:WriteString(userData.HeroName)
		buffer:WriteUnsigned(14, userData.Score) --> 14 bits -> [0, 2^14-1] -> [0, 16383]
		buffer:WriteBool(userData.HasDoneSomething)
		buffer:WriteUnsigned(10, #userData.ItemList) --> [0, 1023]
		for _, itemInfo in pairs(userData.ItemList) do
			buffer:WriteString(itemInfo.Identifier)
			buffer:WriteUnsigned(10, itemInfo.Count) --> [0, 1023]
		end
	end
	local function LoadFromBuffer(buffer, userData)
		userData.HeroName = buffer:ReadString()
		userData.Score = buffer:ReadUnsigned(14)
		userData.HasDoneSomething = buffer:ReadBool()
		local itemCount = buffer:ReadUnsigned(10)
		for i = 1, itemCount do
			local itemInfo = {}
			itemInfo.Identifier = buffer:ReadString()
			itemInfo.Count = buffer:ReadUnsigned(10)
			table.insert(userData.ItemList, itemInfo)
		end
	end
	--...
	local buff = BitBuffer.new()
	SaveToBuffer(buff, someUserData)
	myDataStore:SetAsync(somePlayer.userId, buff:ToBase64())
	--...
	local data = myDataStore:GetAsync(somePlayer.userId)
	local buff = BitBuffer.new()
	buff:FromBase64(data)
	LoadFromBuffer(buff, someUserData)
--]]

-- This is quite possibly the fastest BitBuffer module.

local BitBuffer = {
	ClassName = "BitBuffer";
	__tostring = function(self) return self.ClassName end;
}

BitBuffer.__index = BitBuffer

local CHAR_0X10 = string.char(0x10)
local LOG_10_OF_2 = math.log10(2)

local NumberToBase64, Base64ToNumber = {}, {} do
	local CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	for Index = 1, #CHARACTERS do
		local Character = string.sub(CHARACTERS, Index, Index)
		NumberToBase64[Index - 1] = Character
		Base64ToNumber[Character] = Index - 1
	end
end

local NumberToBase128, Base128ToNumber = {}, {} do -- edit
	local CHARACTERS = ""
	for Index = 0, 127 do CHARACTERS = CHARACTERS .. string.char(Index) end

	for Index = 1, #CHARACTERS do
		local Character = string.sub(CHARACTERS, Index, Index)
		NumberToBase128[Index - 1] = Character
		Base128ToNumber[Character] = Index - 1
	end
end --/edit

local PowerOfTwo = {} do
	for Index = 0, 128 do
		PowerOfTwo[Index] = 2 ^ Index
	end
end

--[[
local PowerOfTwo = setmetatable({}, {
	__index = function(self, Index)
		local Value = 2 ^ Index
		self[Index] = Value
		return Value
	end;
})

for Index = 0, 128 do local _ = PowerOfTwo[Index] end
--]]

local BrickColorToNumber, NumberToBrickColor = {}, {} do
	for Index = 0, 63 do
		local Color = BrickColor.palette(Index)
		BrickColorToNumber[Color.Number] = Index
		NumberToBrickColor[Index] = Color
	end
end

local DIGITS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

local function ToBase(Number, Base)
	Number = Number - Number % 1
	if not Base or Base == 10 then return tostring(Number) end

	local Array = {}
	local Sign = ""
	if Number < 0 then
		Sign = "-"
		Number = 0 - Number
	end

	repeat
		local Index = (Number % Base) + 1
		Number = Number / Base
		Number = Number - Number % 1
		table.insert(Array, 1, string.sub(DIGITS, Index, Index))
	until Number == 0

	return Sign .. table.concat(Array)
end

--[[**
	Creates a new BitBuffer.
	@returns [BitBuffer] The new BitBuffer.
**--]]
function BitBuffer.new()
	return setmetatable({
		BitPointer = 0;
		mBitBuffer = {};
		HasWarned = false;
	}, BitBuffer)
end

--[[**
	Resets the BitBuffer's BitPointer.
**--]]
function BitBuffer:ResetPointer()
	self.BitPointer = 0
end

--[[**
	Resets the BitBuffer's BitPointer and buffer table.
**--]]
function BitBuffer:Reset()
	self.mBitBuffer, self.BitPointer = {}, 0
end

--[[**
	Reads the given string and writes to the BitBuffer accordingly. Not really useful.
	@param [t:string] String The string.
**--]]
function BitBuffer:FromString(String)
	if type(String) ~= "string" then
		error(string.format("bad argument #1 in BitBuffer::FromString (string expected, instead got %s)", typeof(String)), 1)
	end

	self.mBitBuffer, self.BitPointer = {}, 0

	for Index = 1, #String do
		local ByteCharacter = string.byte(string.sub(String, Index, Index))
		for _ = 1, 8 do
			self.BitPointer = self.BitPointer + 1
			self.mBitBuffer[self.BitPointer] = ByteCharacter % 2
			ByteCharacter = ByteCharacter / 2
			ByteCharacter = ByteCharacter - ByteCharacter % 1
		end
	end

--	for Character in string.gmatch(String, ".") do
--		local ByteCharacter = string.byte(Character)
--		for _ = 1, 8 do
--			self.BitPointer = self.BitPointer + 1
--			self.mBitBuffer[self.BitPointer] = ByteCharacter % 2
--			ByteCharacter = ByteCharacter / 2
--			ByteCharacter = ByteCharacter - ByteCharacter % 1
--		end
--	end

	self.BitPointer = 0
end

--[[**
	Writes the BitBuffer to a string.
	@returns [t:string] The BitBuffer string.
**--]]
function BitBuffer:ToString()
	local String = ""
	local Accumulator = 0
	local Power = 0

	for Index = 1, math.ceil(#self.mBitBuffer / 8) * 8 do
		Accumulator = Accumulator + PowerOfTwo[Power] * (self.mBitBuffer[Index] or 0)
		Power = Power + 1
		if Power >= 8 then
			String = String .. string.char(Accumulator)
			Accumulator = 0
			Power = 0
		end
	end

	return String
end

--[[**
	Reads the given Base64 string and writes to the BitBuffer accordingly.
	@param [t:string] String The Base64 string.
**--]]
function BitBuffer:FromBase64(String)
	if type(String) ~= "string" then
		error(string.format("bad argument #1 in BitBuffer::FromBase64 (string expected, instead got %s)", typeof(String)), 1)
	end

	self.mBitBuffer, self.BitPointer = {}, 0

	for Index = 1, #String do
		local Character = string.sub(String, Index, Index)
		local ByteCharacter = Base64ToNumber[Character]
		if not ByteCharacter then error("Bad character: 0x" .. ToBase(string.byte(Character), 16), 1) end

		for _ = 1, 6 do
			self.BitPointer = self.BitPointer + 1
			self.mBitBuffer[self.BitPointer] = ByteCharacter % 2
			ByteCharacter = ByteCharacter / 2
			ByteCharacter = ByteCharacter - ByteCharacter % 1
		end

		if ByteCharacter ~= 0 then
			error("Character value 0x" .. ToBase(Base64ToNumber[Character], 16) .. " too large", 1)
		end
	end

--	for Character in string.gmatch(String, ".") do
--		local ByteCharacter = Base64ToNumber[Character]
--		if not ByteCharacter then error("Bad character: 0x" .. ToBase(string.byte(Character), 16), 1) end
--
--		for _ = 1, 6 do
--			self.BitPointer = self.BitPointer + 1
--			self.mBitBuffer[self.BitPointer] = ByteCharacter % 2
--			ByteCharacter = ByteCharacter / 2
--			ByteCharacter = ByteCharacter - ByteCharacter % 1
--		end
--
--		if ByteCharacter ~= 0 then
--			error("Character value 0x" .. ToBase(Base64ToNumber[Character], 16) .. " too large", 1)
--		end
--	end

	self.BitPointer = 0
end

--[[**
	Writes the BitBuffer to a Base64 string.
	@returns [t:string] The BitBuffer encoded in Base64.
**--]]
function BitBuffer:ToBase64()
	local Array = {}
	local Length = 0
	local Accumulator = 0
	local Power = 0

	local mBitBuffer = self.mBitBuffer

	for Index = 1, math.ceil(#mBitBuffer / 6) * 6 do
		Accumulator = Accumulator + PowerOfTwo[Power] * (mBitBuffer[Index] or 0)
		Power = Power + 1
		if Power >= 6 then
			Length = Length + 1
			Array[Length] = NumberToBase64[Accumulator]
			Accumulator = 0
			Power = 0
		end
	end

	return table.concat(Array)
end

--[[**
	Reads the given Base128 string and writes to the BitBuffer accordingly. Not recommended. Credit to Defaultio for the original functions.
	@param [t:string] String The Base128 string.
**--]]
function BitBuffer:FromBase128(String)
	if type(String) ~= "string" then
		error(string.format("bad argument #1 in BitBuffer::FromBase128 (string expected, instead got %s)", typeof(String)), 1)
	end

	self.mBitBuffer, self.BitPointer = {}, 0

	for Index = 1, #String do
		local Character = string.sub(String, Index, Index)
		local ByteCharacter = Base128ToNumber[Character]
		if not ByteCharacter then
			error("Bad character: 0x" .. ToBase(string.byte(Character), 16), 1)
		end

		for _ = 1, 7 do
			self.BitPointer = self.BitPointer + 1
			self.mBitBuffer[self.BitPointer] = ByteCharacter % 2
			ByteCharacter = ByteCharacter / 2
			ByteCharacter = ByteCharacter - ByteCharacter % 1
		end

		if ByteCharacter ~= 0 then
			error("Character value 0x" .. ToBase(Base128ToNumber[Character], 16) .. " too large", 1)
		end
	end

--	for Character in string.gmatch(String, ".") do
--		local ByteCharacter = Base128ToNumber[Character]
--		if not ByteCharacter then
--			error("Bad character: 0x" .. ToBase(string.byte(Character), 16), 1)
--		end
--
--		for _ = 1, 7 do
--			self.BitPointer = self.BitPointer + 1
--			self.mBitBuffer[self.BitPointer] = ByteCharacter % 2
--			ByteCharacter = ByteCharacter / 2
--			ByteCharacter = ByteCharacter - ByteCharacter % 1
--		end
--
--		if ByteCharacter ~= 0 then
--			error("Character value 0x" .. ToBase(Base128ToNumber[Character], 16) .. " too large", 1)
--		end
--	end

	self.BitPointer = 0
end

--[[**
	Writes the BitBuffer to Base128. Not recommended. Credit to Defaultio for the original functions.
	@returns [t:string] The BitBuffer encoded in Base128.
**--]]
function BitBuffer:ToBase128()
	local Array = {}
	local Length = 0
	local Accumulator = 0
	local Power = 0
	local mBitBuffer = self.mBitBuffer

	for Index = 1, math.ceil(#mBitBuffer / 7) * 7 do
		Accumulator = Accumulator + PowerOfTwo[Power] * (mBitBuffer[Index] or 0)
		Power = Power + 1
		if Power >= 7 then
			Length = Length + 1
			Array[Length] = NumberToBase128[Accumulator]
			Accumulator = 0
			Power = 0
		end
	end

	return table.concat(Array)
end

--[[**
	Dumps the BitBuffer data and prints it.
**--]]
function BitBuffer:Dump()
	local String = ""
	local String2 = ""
	local Accumulator = 0
	local Power = 0

	local mBitBuffer = self.mBitBuffer

	for Index = 1, math.ceil(#mBitBuffer / 8) * 8 do
		String2 = String2 .. (mBitBuffer[Index] or 0)
		Accumulator = Accumulator + PowerOfTwo[Power] * (mBitBuffer[Index] or 0)
		Power = Power + 1

		if Power >= 8 then
			String2 = String2 .. " "
			String = String .. "0x" .. ToBase(Accumulator, 16) .. " "
			Accumulator = 0
			Power = 0
		end
	end

	print("Bytes:", String)
	print("Bits:", String2)
end

function BitBuffer:_readBit()
	self.BitPointer = self.BitPointer + 1
	return self.mBitBuffer[self.BitPointer]
end

local function DetermineType(Value)
	local ActualType = typeof(Value)
	if ActualType == "number" then
		if Value % 1 == 0 then
			ActualType = Value < 0 and "negative integer" or "positive integer"
		else
			ActualType = Value < 0 and "negative number" or "positive number"
		end
	elseif ActualType == "table" then
		local Key = next(Value)
		if DetermineType(Key) == "positive integer" then
			ActualType = "array"
		else
			ActualType = "dictionary"
		end
	end

	return ActualType
end

--[[**
	Writes an unsigned number to the BitBuffer.
	@param [t:integer] Width The bit width of the value.
	@param [t:integer] Value The unsigned integer.
**--]]
function BitBuffer:WriteUnsigned(Width, Value)
	if type(Width) ~= "number" then
		error(string.format("bad argument #1 in BitBuffer::WriteUnsigned (number expected, instead got %s)", DetermineType(Width)), 1)
	end

	if not (Value or type(Value) == "number" or Value >= 0 or Value % 1 == 0) then
		error(string.format("bad argument #2 in BitBuffer::WriteUnsigned (positive integer expected, instead got %s)", DetermineType(Value)), 1)
	end

	-- Store LSB first
	for _ = 1, Width do
		self.BitPointer = self.BitPointer + 1
		self.mBitBuffer[self.BitPointer] = Value % 2
		Value = Value / 2
		Value = Value - Value % 1
	end

	if Value ~= 0 then
		error("Value " .. tostring(Value) .. " has width greater than " .. Width .. " bits", 1)
	end
end

function BitBuffer:ReadUnsigned(Width)
	local Value = 0
	for Index = 1, Width do Value = Value + self:_readBit() * PowerOfTwo[Index - 1] end
	return Value
end

--[[**
	Writes a signed integer to the BitBuffer.
	@param [t:integer] Width The bit width of the value.
	@param [t:integer] Value The signed integer.
**--]]
function BitBuffer:WriteSigned(Width, Value)
	if not (Width and Value) then error("bad arguments in BitBuffer::WriteSigned (missing values)", 1) end
	if Value % 1 ~= 0 then error("Non-integer value to BitBuffer::WriteSigned", 1) end

	-- Write sign
	if Value < 0 then
		self.BitPointer = self.BitPointer + 1
		self.mBitBuffer[self.BitPointer] = 1
		Value = 0 - Value
	else
		self.BitPointer = self.BitPointer + 1
		self.mBitBuffer[self.BitPointer] = 0
	end

	self:WriteUnsigned(Width - 1, Value)
end

--[[**
	Reads a signed integer from the BitBuffer.
	@param [t:integer] Width The bit width of the value.
	@returns [t:integer] The signed integer.
**--]]
function BitBuffer:ReadSigned(Width)
	self.BitPointer = self.BitPointer + 1
	return ((-1) ^ self.mBitBuffer[self.BitPointer]) * self:ReadUnsigned(Width - 1)
end

-- Read / Write a string. May contain embedded nulls (string.char(0))
--[[**
	Writes a string to the BitBuffer.
	@param [t:string] String The string you are writing to the BitBuffer.
**--]]
function BitBuffer:WriteString(String)
	if type(String) ~= "string" then
		error(string.format("bad argument #1 in BitBuffer::WriteString (string expected, instead got %s)", typeof(String)), 1)
	end

	-- First check if it's a 7 or 8 bit width of string
	local StringLength = #String
	local BitWidth = 7
	for Index = 1, StringLength do
		if string.byte(string.sub(String, Index, Index)) > 127 then
			BitWidth = 8
			break
		end
	end

--	for Character in string.gmatch(String, ".") do
--		if string.byte(Character) > 127 then
--			BitWidth = 8
--			break
--		end
--	end

	-- Write the bit width flag
	self:WriteUnsigned(1, BitWidth == 7 and 0 or 1) -- 1 for wide chars

	-- Now write out the string, terminated with "0x10, 0b0"
	-- 0x10 is encoded as "0x10, 0b1"
	for Index = 1, StringLength do
		local ByteCharacter = string.byte(string.sub(String, Index, Index))
		if ByteCharacter == 0x10 then
			self:WriteUnsigned(BitWidth, 0x10)
			self:WriteUnsigned(1, 1)
		else
			self:WriteUnsigned(BitWidth, ByteCharacter)
		end
	end

--	for Character in string.gmatch(String, ".") do
--		local ByteCharacter = string.byte(Character)
--		if ByteCharacter == 0x10 then
--			self:WriteUnsigned(BitWidth, 0x10)
--			self:WriteUnsigned(1, 1)
--		else
--			self:WriteUnsigned(BitWidth, ByteCharacter)
--		end
--	end

	-- Write terminator
	self:WriteUnsigned(BitWidth, 0x10)
	self:WriteUnsigned(1, 0)
end

--[[**
	Reads the BitBuffer for a string.
	@returns [t:string] The string written to the BitBuffer.
**--]]
function BitBuffer:ReadString()
	-- Get bit width
	local BitWidth = self:ReadUnsigned(1) == 1 and 8 or 7

	-- Loop
	local String = ""
	while true do
		local Character = self:ReadUnsigned(BitWidth)
		if Character == 0x10 then
			if self:ReadUnsigned(1) == 1 then
				String = String .. CHAR_0X10
			else
				break
			end
		else
			String = String .. string.char(Character)
		end
	end

	return String
end

--[[**
	Writes a boolean to the BitBuffer.
	@param [t:boolean] Boolean The value you are writing to the BitBuffer.
**--]]
function BitBuffer:WriteBool(Boolean)
	if type(Boolean) ~= "boolean" then
		error(string.format("bad argument #1 in BitBuffer::WriteBool (boolean expected, instead got %s)", typeof(Boolean)), 1)
	end

	self:WriteUnsigned(1, Boolean and 1 or 0)
end

--[[**
	Reads the BitBuffer for a boolean.
	@returns [t:boolean] The boolean.
**--]]
function BitBuffer:ReadBool()
	return self:ReadUnsigned(1) == 1
end

-- Read / Write a floating point number with |wfrac| fraction part
-- bits, |wexp| exponent part bits, and one sign bit.

--[[**
	Writes a float to the BitBuffer.
	@param [t:integer] Fraction The number of bits (probably).
	@param [t:integer] WriteExponent The number of bits for the decimal (probably).
	@param [t:number] Float The actual number you are writing.
**--]]
function BitBuffer:WriteFloat(Fraction, WriteExponent, Float)
	if not (Fraction and WriteExponent and Float) then error("missing argument(s)", 1) end

	-- Sign
	local Sign = 1
	if Float < 0 then
		Float = 0 - Float
		Sign = -1
	end

	-- Decompose
	local Mantissa, Exponent = math.frexp(Float)
	if Exponent == 0 and Mantissa == 0 then
		self:WriteUnsigned(Fraction + WriteExponent + 1, 0)
		return
	else
		Mantissa = (Mantissa - 0.5) / 0.5 * PowerOfTwo[Fraction]
	end

	-- Write sign
	self:WriteUnsigned(1, Sign == -1 and 1 or 0)

	-- Write mantissa
	Mantissa = Mantissa + 0.5
	Mantissa = Mantissa - Mantissa % 1 -- Not really correct, should round up/down based on the parity of |wexp|
	self:WriteUnsigned(Fraction, Mantissa)

	-- Write exponent
	local MaxExp = PowerOfTwo[WriteExponent - 1] - 1
	self:WriteSigned(WriteExponent, Exponent > MaxExp and MaxExp or Exponent < -MaxExp and -MaxExp or Exponent)
end

--[[**
	Reads a float from the BitBuffer.
	@param [t:integer] Fraction The number of bits (probably).
	@param [t:integer] WriteExponent The number of bits for the decimal (probably).
	@returns [t:number] The float.
**--]]
function BitBuffer:ReadFloat(Fraction, WriteExponent)
	if not (Fraction and WriteExponent) then error("missing argument(s)", 1) end

	local Sign = self:ReadUnsigned(1) == 1 and -1 or 1
	local Mantissa = self:ReadUnsigned(Fraction)
	local Exponent = self:ReadSigned(WriteExponent)
	if Exponent == 0 and Mantissa == 0 then return 0 end

	Mantissa = Mantissa / PowerOfTwo[Fraction] / 2 + 0.5
	return Sign * math.ldexp(Mantissa, Exponent)
end

--[[**
	Writes a float8 (quarter precision) to the BitBuffer.
	@param [t:number] The float8.
**--]]
function BitBuffer:WriteFloat8(Float)
	self:WriteFloat(3, 4, Float)
end

--[[**
	Reads a float8 (quarter precision) from the BitBuffer.
	@returns [t:number] The float8.
**--]]
function BitBuffer:ReadFloat8()
	local Sign = self:ReadUnsigned(1) == 1 and -1 or 1
	local Mantissa = self:ReadUnsigned(3)
	local Exponent = self:ReadSigned(4)
	if Exponent == 0 and Mantissa == 0 then return 0 end

	Mantissa = Mantissa / PowerOfTwo[3] / 2 + 0.5
	return Sign * math.ldexp(Mantissa, Exponent)
end

--[[**
	Writes a float16 (half precision) to the BitBuffer.
	@param [t:number] The float16.
**--]]
function BitBuffer:WriteFloat16(Float)
	self:WriteFloat(10, 5, Float)
end

--[[**
	Reads a float16 (half precision) from the BitBuffer.
	@returns [t:number] The float16.
**--]]
function BitBuffer:ReadFloat16()
	local Sign = self:ReadUnsigned(1) == 1 and -1 or 1
	local Mantissa = self:ReadUnsigned(10)
	local Exponent = self:ReadSigned(5)
	if Exponent == 0 and Mantissa == 0 then return 0 end

	Mantissa = Mantissa / PowerOfTwo[10] / 2 + 0.5
	return Sign * math.ldexp(Mantissa, Exponent)
end

--[[**
	Writes a float32 (single precision) to the BitBuffer.
	@param [t:number] The float32.
**--]]
function BitBuffer:WriteFloat32(Float)
	self:WriteFloat(23, 8, Float)
end

--[[**
	Reads a float32 (single precision) from the BitBuffer.
	@returns [t:number] The float32.
**--]]
function BitBuffer:ReadFloat32()
	local Sign = self:ReadUnsigned(1) == 1 and -1 or 1
	local Mantissa = self:ReadUnsigned(23)
	local Exponent = self:ReadSigned(8)
	if Exponent == 0 and Mantissa == 0 then return 0 end

	Mantissa = Mantissa / PowerOfTwo[23] / 2 + 0.5
	return Sign * math.ldexp(Mantissa, Exponent)
end

--[[**
	Writes a float64 (double precision) to the BitBuffer.
	@param [t:number] The float64.
**--]]
function BitBuffer:WriteFloat64(Float)
	self:WriteFloat(52, 11, Float)
end

--[[**
	Reads a float64 (double precision) from the BitBuffer.
	@returns [t:number] The float64.
**--]]
function BitBuffer:ReadFloat64()
	local Sign = self:ReadUnsigned(1) == 1 and -1 or 1
	local Mantissa = self:ReadUnsigned(52)
	local Exponent = self:ReadSigned(11)
	if Exponent == 0 and Mantissa == 0 then return 0 end

	Mantissa = Mantissa / PowerOfTwo[52] / 2 + 0.5
	return Sign * math.ldexp(Mantissa, Exponent)
end

-- Roblox DataTypes:

--[[**
	[DEPRECATED] Writes a BrickColor to the BitBuffer.
	@param [t:BrickColor] Color The BrickColor you are writing to the BitBuffer.
**--]]
function BitBuffer:WriteBrickColor(Color)
	if typeof(Color) ~= "BrickColor" then
		error(string.format("bad argument #1 in BitBuffer::WriteBrickColor (BrickColor expected, instead got %s)", typeof(Color)), 1)
	end

	if not self.HasWarned then
		self.HasWarned = true
		warn("::WriteBrickColor is deprecated. Using ::WriteColor3 is suggested instead.")
	end

	local BrickColorNumber = BrickColorToNumber[Color.Number]
	if not BrickColorNumber then
		warn("Attempt to serialize non-pallete BrickColor \"" .. tostring(Color) .. "\" (#" .. Color.Number .. "), using Light Stone Grey instead.")
		BrickColorNumber = BrickColorToNumber[1032]
	end

	self:WriteUnsigned(6, BrickColorNumber)
end

--[[**
	[DEPRECATED] Reads a BrickColor from the BitBuffer.
	@returns [t:BrickColor] The BrickColor read from the BitBuffer.
**--]]
function BitBuffer:ReadBrickColor()
	return NumberToBrickColor[self:ReadUnsigned(6)]
end

--[[**
	Writes the rotation part of a CFrame into the BitBuffer.
	@param [t:CFrame] CoordinateFrame The CFrame you wish to write.
**--]]
function BitBuffer:WriteRotation(CoordinateFrame)
	if typeof(CoordinateFrame) ~= "CFrame" then
		error(string.format("bad argument #1 in BitBuffer::WriteRotation (CFrame expected, instead got %s)", typeof(CoordinateFrame)), 1)
	end

	local LookVector = CoordinateFrame.LookVector
	local Azumith = math.atan2(-LookVector.X, -LookVector.Z)
	local Elevation = math.atan2(LookVector.Y, (LookVector.X * LookVector.X + LookVector.Z * LookVector.Z) ^ 0.5)
	local WithoutRoll = CFrame.new(CoordinateFrame.Position) * CFrame.Angles(0, Azumith, 0) * CFrame.Angles(Elevation, 0, 0)
	local _, _, Roll = (WithoutRoll:Inverse() * CoordinateFrame):ToEulerAnglesXYZ()

	-- Atan2 -> in the range [-pi, pi]
	Azumith = ((Azumith / 3.1415926535898) * (PowerOfTwo[21] - 1)) + 0.5
	Azumith = Azumith - Azumith % 1

	Roll = ((Roll / 3.1415926535898) * (PowerOfTwo[20] - 1)) + 0.5
	Roll = Roll - Roll % 1

	Elevation = ((Elevation / 1.5707963267949) * (PowerOfTwo[20] - 1)) + 0.5
	Elevation = Elevation - Elevation % 1

	self:WriteSigned(22, Azumith)
	self:WriteSigned(21, Roll)
	self:WriteSigned(21, Elevation)
end

--[[**
	Reads the rotation part of a CFrame saved in the BitBuffer.
	@returns [t:CFrame] The rotation read from the BitBuffer.
**--]]
function BitBuffer:ReadRotation()
	local Azumith = self:ReadSigned(22)
	local Roll = self:ReadSigned(21)
	local Elevation = self:ReadSigned(21)

	Azumith = 3.1415926535898 * (Azumith / (PowerOfTwo[21] - 1))
	Roll = 3.1415926535898 * (Roll / (PowerOfTwo[20] - 1))
	Elevation = 3.1415926535898 * (Elevation / (PowerOfTwo[20] - 1))

	local Rotation = CFrame.Angles(0, Azumith, 0)
	Rotation = Rotation * CFrame.Angles(Elevation, 0, 0)
	Rotation = Rotation * CFrame.Angles(0, 0, Roll)

	return Rotation
end

--[[**
	Writes a Color3 to the BitBuffer.
	@param [t:Color3] Color The color you want to write into the BitBuffer.
**--]]
function BitBuffer:WriteColor3(Color)
	if typeof(Color) ~= "Color3" then
		error(string.format("bad argument #1 in BitBuffer::WriteColor3 (Color3 expected, instead got %s)", typeof(Color)), 1)
	end

	local R, G, B = Color.R * 255, Color.G * 255, Color.B * 255
	R, G, B = R - R % 1, G - G % 1, B - B % 1

	self:WriteUnsigned(8, R)
	self:WriteUnsigned(8, G)
	self:WriteUnsigned(8, B)
end

--[[**
	Reads a Color3 from the BitBuffer.
	@returns [t:Color3] The color read from the BitBuffer.
**--]]
function BitBuffer:ReadColor3()
	return Color3.fromRGB(self:ReadUnsigned(8), self:ReadUnsigned(8), self:ReadUnsigned(8))
end

--[[**
	Writes a Vector3 to the BitBuffer. Writes with Float32 precision.
	@param [t:Vector3] Vector The vector you want to write into the BitBuffer.
**--]]
function BitBuffer:WriteVector3(Vector)
	if typeof(Vector) ~= "Vector3" then
		error(string.format("bad argument #1 in BitBuffer::WriteVector3 (Vector3 expected, instead got %s)", typeof(Vector)), 1)
	end

	self:WriteFloat32(Vector.X)
	self:WriteFloat32(Vector.Y)
	self:WriteFloat32(Vector.Z)
end

--[[**
	Reads a Vector3 from the BitBuffer. Uses Float32 precision.
	@returns [t:Vector3] The vector read from the BitBuffer.
**--]]
function BitBuffer:ReadVector3()
	return Vector3.new(self:ReadFloat32(), self:ReadFloat32(), self:ReadFloat32())
end

--[[**
	Writes a full CFrame (position and rotation) to the BitBuffer. Uses Float64 precision.
	@param [t:CFrame] CoordinateFrame The CFrame you are writing to the BitBuffer.
**--]]
function BitBuffer:WriteCFrame(CoordinateFrame)
	if typeof(CoordinateFrame) ~= "CFrame" then
		error(string.format("bad argument #1 in BitBuffer::WriteCFrame (CFrame expected, instead got %s)", typeof(CoordinateFrame)), 1)
	end

	self:WriteVector3Float64(CoordinateFrame.Position)
	self:WriteRotation(CoordinateFrame)
end

--[[**
	Reads a full CFrame (position and rotation) from the BitBuffer. Uses Float64 precision.
	@returns [t:CFrame] The CFrame you are reading from the BitBuffer.
**--]]
function BitBuffer:ReadCFrame()
	return CFrame.new(self:ReadVector3Float64()) * self:ReadRotation()
end

--[[**
	Writes a Vector2 to the BitBuffer. Writes with Float32 precision.
	@param [t:Vector2] Vector The vector you want to write into the BitBuffer.
**--]]
function BitBuffer:WriteVector2(Vector)
	if typeof(Vector) ~= "Vector2" then
		error(string.format("bad argument #1 in BitBuffer::WriteVector2 (Vector2 expected, instead got %s)", typeof(Vector)), 1)
	end

	self:WriteFloat32(Vector.X)
	self:WriteFloat32(Vector.Y)
end

--[[**
	Reads a Vector2 from the BitBuffer. Uses Float32 precision.
	@returns [t:Vector2] The vector read from the BitBuffer.
**--]]
function BitBuffer:ReadVector2()
	return Vector2.new(self:ReadFloat32(), self:ReadFloat32())
end

--[[**
	Writes a UDim2 to the BitBuffer. Uses Float32 precision for the scale.
	@param [t:UDim2] Value The UDim2 you are writing to the BitBuffer.
**--]]
function BitBuffer:WriteUDim2(Value)
	if typeof(Value) ~= "UDim2" then
		error(string.format("bad argument #1 in BitBuffer::WriteUDim2 (UDim2 expected, instead got %s)", typeof(Value)), 1)
	end

	self:WriteFloat32(Value.X.Scale)
	self:WriteSigned(17, Value.X.Offset)
	self:WriteFloat32(Value.Y.Scale)
	self:WriteSigned(17, Value.Y.Offset)
end

--[[**
	Reads a UDim2 from the BitBuffer. Uses Float32 precision for the scale.
	@returns [t:UDim2] The UDim2 read from the BitBuffer.
**--]]
function BitBuffer:ReadUDim2()
	return UDim2.new(self:ReadFloat32(), self:ReadSigned(17), self:ReadFloat32(), self:ReadSigned(17))
end

--[[**
	Writes a Vector3 to the BitBuffer. Writes with Float64 precision.
	@param [t:Vector3] Vector The vector you want to write into the BitBuffer.
**--]]
function BitBuffer:WriteVector3Float64(Vector)
	if typeof(Vector) ~= "Vector3" then
		error(string.format("bad argument #1 in BitBuffer::WriteVector3Float64 (Vector3 expected, instead got %s)", typeof(Vector)), 1)
	end

	self:WriteFloat64(Vector.X)
	self:WriteFloat64(Vector.Y)
	self:WriteFloat64(Vector.Z)
end

--[[**
	Reads a Vector3 from the BitBuffer. Reads with Float64 precision.
	@returns [t:Vector3] The vector read from the BitBuffer.
**--]]
function BitBuffer:ReadVector3Float64()
	return Vector3.new(self:ReadFloat64(), self:ReadFloat64(), self:ReadFloat64())
end

--[[**
	Writes a Vector2 to the BitBuffer. Writes with Float64 precision.
	@param [t:Vector2] Vector The vector you want to write into the BitBuffer.
**--]]
function BitBuffer:WriteVector2Float64(Vector)
	if typeof(Vector) ~= "Vector2" then
		error(string.format("bad argument #1 in BitBuffer::WriteVector2Float64 (Vector2 expected, instead got %s)", typeof(Vector)), 1)
	end

	self:WriteFloat64(Vector.X)
	self:WriteFloat64(Vector.Y)
end

--[[**
	Reads a Vector2 from the BitBuffer. Reads with Float64 precision.
	@returns [t:Vector2] The vector read from the BitBuffer.
**--]]
function BitBuffer:ReadVector2Float64()
	return Vector2.new(self:ReadFloat64(), self:ReadFloat64())
end

BitBuffer.WriteVector3Float32 = BitBuffer.WriteVector3
BitBuffer.ReadVector3Float32 = BitBuffer.ReadVector3

BitBuffer.WriteVector2Float32 = BitBuffer.WriteVector2
BitBuffer.ReadVector2Float32 = BitBuffer.ReadVector2

--[[**
	Destroys the BitBuffer metatable.
**--]]
function BitBuffer:Destroy()
	self:Reset()
	setmetatable(self, nil)
end

--[[**
	Calculates the amount of bits needed for a given number.
	@param [t:number] Number The number you want to use.
	@returns [t:number] The amount of bits needed.
**--]]
function BitBuffer.BitsNeeded(Number)
	if type(Number) ~= "number" then
		error(string.format("bad argument #1 in BitBuffer.BitsNeeded (number expected, instead got %s)", typeof(Number)), 1)
	end

	local Bits = math.log10(Number + 1) / LOG_10_OF_2
	return Bits + (1 - Bits % 1)
end

return BitBuffer
