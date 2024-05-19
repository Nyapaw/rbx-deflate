local Deflate = require(game.ReplicatedStorage.Deflate)
local str = ""
for i = 1, 10000 do
    str = str .. string.char(math.random() < 0.5 and 60 or math.random(0, 255))
end

return function(target)
    local t = os.clock()
    --print(#str)
    local en = Deflate.encode(str)
    local dec = Deflate.decode(en)
    print(dec == str, #en, #str)
    print('Deflate encode/decode time:', os.clock() - t)
    return function()
        
    end
end