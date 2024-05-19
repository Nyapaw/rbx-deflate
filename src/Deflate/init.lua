--Deflate.lua
--iiau, Sat May 18 2024

local Deflate = {}

local LZW = require(script.LZW)
local Huffman = require(script.Huffman)

Deflate.encode = function(data: string) : string
    data = LZW.compress(data)
    return Huffman.encode(data)
end

Deflate.decode = function(data: string) : string
    data = Huffman.decode(data)
    return LZW.decompress(data)
end

return Deflate