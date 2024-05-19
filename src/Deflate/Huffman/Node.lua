local Node = {}
Node.__index = Node

function Node.new(data)
    local node = setmetatable({}, Node)
    node.data = data
    node.left = nil
    node.right = nil
    return node
end

-- return an iterator that traverses the tree in order
function Node:inorder()
    local stack = {}
    local current = {self, ""}
    table.insert(stack, current)

    return function()
        while current[1].left do
            local parent = current
            current = {parent[1].left, parent[2] .. "0"}
            table.insert(stack, current)
        end

        if #stack > 0 then
            local node = table.remove(stack)

            if node[1].right then
                local parent = node
                current = {parent[1].right, parent[2] .. "1"}
                table.insert(stack, current)
            end
            return node[1], node[2]
        end
    end
end

return Node