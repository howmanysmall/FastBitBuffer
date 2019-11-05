## Global Methods

### FastBitBuffer.new
```
FastBitBuffer.new() => BitBuffer
```

This will create a new [BitBuffer](#bitbuffer-api) object which can be used to compress any data given down to a much smaller size.

### FastBitBuffer.BitsRequired
```
FastBitBuffer.BitsRequired(Number: number) => number
```

Calculates the number of bits required for a given number. The equation for calculating this is:
$$
\left \lceil \frac{\log_{10}(x + 1)}{\log 2} \right \rceil
$$

## BitBuffer API

### BitBuffer:ResetPointer
```
ResetPointer() => void
```

Resets the BitBuffer's pointer to zero. This is mostly used for the encoding process.

### BitBuffer:Reset
```
Reset() => void
```

Resets both the BitBuffer's pointer and the BitBuffer data table.

### BitBuffer:FromString
```
FromString(String: string) => void
```

Reads the string and adds it to the BitBuffer accordingly.

!!! warning
	This function is not recommended for use because it's quite useless and isn't DataStore ready.

### BitBuffer:ToString
```
ToString() => string
```

Writes the current data in the BitBuffer to a string. This string isn't useful for anything.

!!! warning
	This function is not recommended for use because it's quite useless and isn't DataStore ready.

### BitBuffer:FromBase64
```
FromBase64(String: string) => void
```

Reads the Base64 string and adds it to the BitBuffer accordingly.

!!! tip
	This is the recommended way to encode your data. It's guaranteed to be the safest as well as still being fast.

### BitBuffer:ToBase64
```
ToBase64() => string
```

Writes the current data in the BitBuffer to a Base64 encoded string.

!!! tip
	This is the recommended way to encode your data. It's guaranteed to be the safest as well as still being fast.

### BitBuffer:FromBase128
```
FromBase128(String: string) => void
```

Reads the Base128 string and adds it to the BitBuffer accordingly.

!!! info
	This function isn't actually tested, and might not work in DataStores. Use it with caution. It is still very fast despite this.

### BitBuffer:ToBase128
```
ToBase128() => string
```

Writes the current data in the BitBuffer to a Base128 encoded string.

!!! info
	This function isn't actually tested, and might not work in DataStores. Use it with caution. It is still very fast despite this.

### BitBuffer:Dump
```
Dump() => void
```

Dumps the data inside the BitBuffer and prints it.

### BitBuffer:WriteUnsigned
```
WriteUnsigned(Width: integer, Value: integer) => void
```

This function writes an unsigned number with a given number of bits. The value must be a positive integer. If the given width is four, the max value that can be stored is calculated as such:

$$
\left [0, 2 ^ 4 - 1 \right ] = \left [0, 15 \right ]
$$

!!! tip
	If you don't need either negatives or a float, this is the function you should use for maximum compression.

### BitBuffer:ReadUnsigned
```
ReadUnsigned(Width: integer) => integer
```

This function reads an unsigned number with a given number of bits.

### BitBuffer:WriteSigned
```
WriteSigned(Width: integer, Value: integer) => void
```

This function is similar to [`WriteUnsigned`](#bitbufferwriteunsigned), except it writes a signed number, meaning it can store negatives as well. The value must still be an integer. As an example, if the given width is seven, there will be one sign bit and six magnitude bits.

$$
\left [-2 ^ 7 + 1, 2 ^ 7 - 1 \right ] = \left [-127, 127 \right ]
$$

### BitBuffer:ReadSigned
```
ReadSigned(Width: integer) => integer
```

This function reads a signed number with a given number of bits.

### BitBuffer:WriteFloat
```
WriteFloat(MantissaWidth: integer, ExponentWidth: integer, Value: number) => void
```

Writes a floating point number to the BitBuffer with a given mantissa and exponent size in bits.

!!! tip
	You don't really need to call this function unless you want to have faster code at the cost of your sanity and code readability. I recommend using the other float functions instead.

### BitBuffer:ReadFloat
```
ReadFloat(MantissaWidth: integer, ExponentWidth: integer) => number
```

Reads a floating point number from the BitBuffer with a given mantissa and exponent size in bits.

### BitBuffer:WriteFloat8
```
WriteFloat8(Value: number) => void
```

Writes a [minifloat](https://en.wikipedia.org/wiki/Minifloat) to the BitBuffer.

!!! tip
	This is the smallest method of compressing a float down, but it comes at the cost of number accuracy. If you need more accuracy, use something above this in precision.

### BitBuffer:ReadFloat8
```
ReadFloat8() => number
```

Reads a minifloat from the BitBuffer.

### BitBuffer:WriteFloat16
```
WriteFloat16(Value: number) => void
```

Writes a half precision floating point number to the BitBuffer.

### BitBuffer:ReadFloat16
```
ReadFloat16() => number
```

Reads a half precision floating point number from the BitBuffer.

### BitBuffer:WriteFloat32
```
WriteFloat32(Value: number) => void
```

Writes a single precision floating point number to the BitBuffer.

!!! tip
	This function is the suggested one for storing most floats. If you want to store the player's last height, you should use this function.

### BitBuffer:ReadFloat32
```
ReadFloat32() => number
```

Reads a single precision floating point number from the BitBuffer.

### BitBuffer:WriteFloat64
```
WriteFloat64(Value: number) => void
```

Writes a double precision floating point number to the BitBuffer. This is the most accurate float function provided, but is also least efficient.

!!! tip
	If you want to 100% accurately save an arbitrary Lua number, then you should use this function.

### BitBuffer:ReadFloat64
```
ReadFloat64() => number
```

Reads a double precision floating point number from the BitBuffer.

### BitBuffer:WriteBool
```
WriteBool(Boolean: boolean) => void
```

Writes a boolean value to the BitBuffer. Takes only one bit worth of space to store. Alternatively, you can call WriteBoolean for a more accurate name for Lua types.

### BitBuffer:ReadBool
```
ReadBool() => boolean
```

Reads a boolean value from the BitBuffer. Takes only one bit worth of space to store. Alternatively, you can call ReadBoolean for a more accurate name for Lua types.

### BitBuffer:WriteString
```
WriteString(String: string) => void
```

Writes a variable length string. The string may contain embedded nulls. Only seven bits / character will be used if the string contains no non-printable characters (greater than 0x80).

!!! note
	This function doesn't require a width argument because it'll do it for you automatically.

### BitBuffer:ReadString
```
ReadString() => string
```

Reads a variable length string. The string may contain embedded nulls. Only seven bits / character will be used if the string contains no non-printable characters (greater than 0x80).

### BitBuffer:WriteBrickColor
```
WriteBrickColor(Color: BrickColor) => void
```

Writes a Roblox BrickColor to the BitBuffer. Provided as an example of reading / writing a derived data type.

!!! danger
	This function is deprecated and should not be used. Instead, use [`WriteColor3`](#bitbufferwritecolor3) instead.

### BitBuffer:ReadBrickColor
```
ReadBrickColor() => BrickColor
```

Reads a Roblox BrickColor from the BitBuffer. Provided as an example of reading / writing a derived data type.

!!! danger
	This function is deprecated and should not be used. Instead, use [`ReadColor3`](#bitbufferreadcolor3) instead.

### BitBuffer:WriteColor3
```
WriteColor3(Color: Color3) => void
```

Writes a Roblox Color3 to the BitBuffer. This is the recommended way to store anything color related in your BitBuffer.

### BitBuffer:ReadColor3
```
ReadColor3() => Color3
```

Reads a Roblox Color3 from the BitBuffer. This is the recommended way to store anything color related in your BitBuffer.

### BitBuffer:WriteRotation
```
WriteRotation(CoordinateFrame: CFrame) => void
```

Write the rotation part of a given CFrame to the BitBuffer. Encodes the rotation in question into double precision, which is a good size to get a pretty dense packing, but still while having errors well within the threshold that Roblox uses for stuff like `MakeJoints()` detecting adjacency. Will also perfectly reproduce rotations which are orthagonally aligned, or inverse-power-of-two rotated on only a single axix. For other rotations, the results may not be perfectly stable through read-write cycles (if you read/write an arbitrary rotation thousands of times there may be detectable "drift").

!!! tip
	If you want to write the entire CFrame, you should use the function [`WriteCFrame`](#bitbufferwritecframe) instead.

### BitBuffer:ReadRotation
```
ReadRotation() => CFrame
```

Reads the rotation part of a given CFrame from the BitBuffer.

### BitBuffer:WriteVector3
```
WriteVector3(Vector: Vector3) => void
```

Writes a Vector3 to the BitBuffer using single precision floating points. Alternatve name for this is `WriteVector3Float32`.

### BitBuffer:ReadVector3
```
ReadVector3() => Vector3
```

Reads a Vector3 from the BitBuffer. Alternatve name for this is `ReadVector3Float32`.

### BitBuffer:WriteVector3Float64
```
WriteVector3Float64(Vector: Vector3) => void
```

Writes a Vector3 to the BitBuffer using double precision floating points. For less precision, use `WriteVector3` instead.

### BitBuffer:ReadVector3Float64
```
ReadVector3Float64() => Vector3
```

Reads a Vector3 from the BitBuffer. For less precision, use `ReadVector3` instead.

### BitBuffer:WriteVector2
```
WriteVector2(Vector: Vector2) => void
```

Writes a Vector2 to the BitBuffer using single precision floating points. Alternatve name for this is `WriteVector2Float32`.

### BitBuffer:ReadVector2
```
ReadVector2() => Vector2
```

Reads a Vector2 from the BitBuffer. Alternatve name for this is `ReadVector2Float32`.

### BitBuffer:WriteVector2Float64
```
WriteVector2Float64(Vector: Vector2) => void
```

Writes a Vector2 to the BitBuffer using double precision floating points. For less precision, use `WriteVector2` instead.

### BitBuffer:ReadVector2Float64
```
ReadVector2Float64() => Vector2
```

Reads a Vector2 from the BitBuffer. For less precision, use `ReadVector2` instead.

### BitBuffer:WriteCFrame
```
WriteCFrame(CoordinateFrame: CFrame) => void
```

Writes the entire CFrame to the BitBuffer. Uses double precision floating points to do so.

### BitBuffer:ReadCFrame
```
ReadCFrame() => CFrame
```

Reads an entire CFrame from the BitBuffer. Uses double precision floating points to do so.

### BitBuffer:WriteUDim2
```
WriteUDim2(Value: UDim2) => void
```

Writes a UDim2 to the BitBuffer. Uses half precision floating points.

### BitBuffer:ReadUDim2
```
ReadUDim2() => UDim2
```

Reads a UDim2 from the BitBuffer.

### BitBuffer:Destroy
```
Destroy() => void
```

Destroys the BitBuffer and sets the metatable to nil.
