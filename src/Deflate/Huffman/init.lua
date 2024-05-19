--Huffman.lua
--iiau, Sat May 18 2024
--Implementation of huffman coding algorithm for use in Roblox

local Huffman = {}
local PriorityQueue = require(script.PriorityQueue)
local Node = require(script.Node)
local BitBuffer = require(script.BitBuffer)

local CHUNK_SIZE = 256

--thanks to https://stackoverflow.com/a/32220398 for helping me with this
local function to_bin(n)
    local t = {}
    for _ = 1, 32 do
        n = bit32.rrotate(n, -1)
        table.insert(t, bit32.band(n, 1))
    end
    return table.concat(t)
end

-- Encode a string to huffman coded string. Limitation is that the data should not be more than 16777215 bytes.
-- @param data The string to encode
-- @return The encoded string
Huffman.encode = function(data: string) : string
    assert(#data > 0, "Data must not be empty")
    local buffer = BitBuffer()

    -- get the frequency of each character in the string
    local freq, dict, size = {}, {}, 0
    for c in data:gmatch(".") do
        freq[c] = (freq[c] or 0) + 1
    end
    for _ in pairs(freq) do
        size += 1
    end

    local q = PriorityQueue.new 'min'
    for k: string, v: number in pairs(freq) do
        local leaf = Node.new(string.byte(k))
        q:enqueue(leaf, v)
    end
    
    while q:len() > 1 do
        local left, freq_l = q:dequeue()
        local right, freq_r = q:dequeue()
        local parent = Node.new()
        parent.left = left
        parent.right = right

        q:enqueue(parent, freq_l + freq_r)
    end
    local tree = q:dequeue()
    buffer.writeUInt8(size-1)
    buffer.writeUnsigned(24, #data)
    for node, bits: string in tree:inorder() do
        if not node.data then
            continue
        end
        local number = tonumber(bits, 2)
        local bit_array = string.split(bits, "")
        for i = 1, #bit_array do
            bit_array[i] = tonumber(bit_array[i])
        end

        dict[string.char(node.data)] = bit_array
        buffer.writeUInt8(node.data) -- char
        buffer.writeUnsigned(5, #bits) -- number of bits
        buffer.writeUnsigned(#bits, number) -- bits
    end
    for c in data:gmatch(".") do
        buffer.writeBits(table.unpack(dict[c]))
    end

    -- to avoid the dreaded too many results to unpack error
    local chunks = {}
    for _, chunk in buffer.exportChunk(CHUNK_SIZE) do
        table.insert(chunks, chunk)
    end
    return table.concat(chunks)
end

-- Decode a string from huffman coded string
-- @param data The string to decode
-- @return The decoded string
Huffman.decode = function(data: string) : string
    assert(#data > 0, "Data must not be empty")
    local buffer = BitBuffer(data)

    local dict_size = buffer.readUInt8()+1
    local len_data = buffer.readUnsigned(24)
    local dict, read = {}, 0

    for i = 1, dict_size do
        local char = buffer.readUInt8()
        local digits = buffer.readUnsigned(5)
        local bits = buffer.readUnsigned(digits)
        dict[to_bin(bits):sub(-digits)] = char
    end
    local decoded = {}
    local bits = ""
    while read < len_data do
        bits ..= buffer.readBits(1)[1]
        local char = dict[bits]
        if char then
            table.insert(decoded, string.char(char))
            bits = ""
            read += 1
        end
    end
    return table.concat(decoded)
end

return Huffman