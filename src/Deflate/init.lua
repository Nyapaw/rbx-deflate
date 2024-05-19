--Deflate.lua
--iiau, Sat May 18 2024

local Deflate = {}

local LZW = require(script.LZW)
local Huffman = require(script.Huffman)

Deflate.encode = function(data: string) : string
    local compressed = Huffman.encode(data)
    return LZW.decompress(compressed)
end

Deflate.decode = function(data: string) : string
    local decompressed = LZW.decode(data)
    return Huffman.compress(decompressed)
end

return Deflate