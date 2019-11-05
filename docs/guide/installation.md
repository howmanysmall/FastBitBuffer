There's really only one way to install this module. I recommend that you put it in your `ServerStorage`, as it's the perfect place for storing ModuleScripts, and it's only meant for use on the server.

To install, just run this in your Studio command line.

```Lua
local ServerStorage = game:GetService("ServerStorage")
local Installer = require(4300858244)
local FastBitBuffer = Installer:Install("https://github.com/howmanysmall/FastBitBuffer/tree/master/src", ServerStorage)
FastBitBuffer.Name = "FastBitBuffer"
```
