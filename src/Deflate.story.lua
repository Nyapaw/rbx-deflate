local Deflate = require(game.ReplicatedStorage.Deflate)
local str = ""
for i = 1, 100000 do
    str = str .. string.char(math.random() < 0.5 and 60 or 71)
end

return function(target)
    local t = os.clock()
    --print(#str)
    local encoded = Deflate.encode(str)
    local dec = Deflate.decode(encoded)
    print(dec == str, #encoded, #str)
    print('Deflate encode/decode time:', os.clock() - t)
    return function()
        
    end
end