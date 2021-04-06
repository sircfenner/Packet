# Motivation

Interchange formats like JSON have the advantage of being able to encode arbitrary data without the decoder needing any additional information. However, this comes at the cost of larger file sizes because the shape of the data is encoded in the file itself.

When a sender and recipient can agree on the shape of some data ahead of time, data can be packed much more compactly. This library provides a mechanism to do this by defining Messages, which describe the shape of data and can be used to encode and decode any data that fits their shape.

Unlike mechanisms like Protocol Buffers, this is not suitable for scenarios where a sender and recipient may disagree on the shape of a Message. This means that it is generally not suitable for persistent storage but is suitable for sending data over the network in a Roblox game where the server will always be on the same version as the client.

Packet encodes to a binary format that supports the main data types as well as arrays, nesting, and optional default values. Optional default values come at very little additional cost. See [Binary format](#Binary-format) for more information.

# Installation

## Rojo

Either add this repository to your project as a submodule or build it from source using the `default.project.json`.

## Studio

Insert the latest `.rbxm` build from releases into Roblox Studio.

# Usage

Place the Packet library in a shared location such as ReplicatedStorage.

## Defining a message

Messages are the root object that gets encoded and decoded.

They are comprised of simple key-value pairs, where keys are strings and values are any of the accepted types.

### Packet value types

| Type    | Description                                 | Parameters                 | Lua value type           |
|---------|---------------------------------------------|----------------------------|--------------------------|
| Message | Top-level object defined by key-value pairs | Message content            | table (dictionary-like)  |
| String  | UTF-8 string                                | Optional default value     | string                   |
| UInt    | Varint-encoded unsigned integer             | Optional default value     | number (positive, whole) |
| Int     | Varint-encoded signed integer               | Optional default value     | number (whole)           |
| Bool    | Boolean value                               | Optional default value     | boolean                  |
| Float   | IEEE 754 single-precision float             | Optional default value     | number                   |
| Double  | IEEE 754 double-precision float             | Optional default value     | number                   |
| Array   | Zero or more values of the specified type   | Value type from this table | table (array-like)       |

### Optional defaults

All types other than Message and Array may be given a default value in a definition. This means that the fields are optional when encoding/decoding. An optional field cannot be defined without a default value. The default value will be written to the data when decoded.

### Example definition

The code below defines a message with four fields:
- `id`: an unsigned integer
- `name`: a string
- `alive`: an optional boolean that defaults to `true`
- `friends`: an array of strings
```Lua
local Player = T.Message({
	id = T.UInt,
	name = T.String,
	alive = T.Bool(true),
	friends = T.Array(T.String),
})
```

## Encoding and decoding data

Creating a Message returns a table with `encode` and `decode` functions. These are used to convert between data between Lua tables and the binary format according to the shape specified by the Message.

The following code samples assume that `Player` has been defined as above.

The `packed` variable holds the binary-encoded data. The `unpacked` variable holds a plain Lua table decoded from the binary data. Note that the `alive` field was not given so it will appear as `true` in the unpacked data, as specified by the definition of the `Player` Message.
```Lua
local packed = Player.encode({
	id = 5,
	name = "foo",
	friends = {"bar", "baz"},
})

local unpacked = Player.decode(packed)
```

### Nesting and re-use

All value types can be nested either in a Message or an Array. The recommended way to re-use Messages is to define each one in its own file.

The following code examples define two Messages:
- `User`: a representation of a user
- `FriendsList`: a table with a friends field, which is a list of users

```Lua
-- shared/User.lua
return T.Message({
	id = T.UInt,
	name = T.String,
})
```
```Lua
-- shared/FriendsList.lua
local User = require(...)

return T.Message({
	friends = T.Array(User),
})
```

## Limitations

Explanation of limitations here.
- Varints
- Maximum/minimum number values
- Maximum number of optional values
- No optional arrays/messages

## Examples

Check out the demo project in this repository to see a working example.

# Binary format

Explanation of binary format here.
