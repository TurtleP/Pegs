local path = (...) .. ".types"

local result = {}
local items = love.filesystem.getDirectoryItems(path:gsub("%.", "/"))

for _, value in ipairs(items) do
    local name = value:gsub(".lua", "")
    local _, _, match = value:find("_(%w+).+")

    result[match] = require(path .. "." .. name)
end

return result
