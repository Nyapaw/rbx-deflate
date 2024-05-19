local Deflate = require(game.ReplicatedStorage.Deflate)
local str = script.Parent.Shakespeare.Source

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