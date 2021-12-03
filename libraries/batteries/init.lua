--[[
    batteries for lua

    a collection of helpful code to get your project off the ground faster
]]

local path = ...
local function require_relative(p)
    return require(table.concat({path, p}, "."))
end

--build the module
local _batteries = {
    class = require_relative("class"),
    assert = require_relative("assert"),
    mathx = require_relative("mathx"),
    pooled = require_relative("pooled"),
    tablex = require_relative("tablex"),
    timer = require_relative("timer")
}

--assign aliases
for _, alias in ipairs({
    {"mathx", "math"},
    {"tablex", "table"},
    {"stringx", "string"},
    {"sort", "stable_sort"},
    {"colour", "color"},
}) do
    _batteries[alias[2]] = _batteries[alias[1]]
end

--easy export globally if required
function _batteries:export()
    --export all key strings globally, if doesn't already exist
    for k, v in pairs(self) do
        if _G[k] == nil then
            _G[k] = v
        end
    end

    --overwrite assert wholesale (it's compatible)
    assert = self.assert

    --overlay tablex and functional and sort routines onto table
	self.tablex.overlay(table, self.tablex)

    --overlay onto global math table
	table.overlay(math, self.mathx)

    --export the whole library to global `batteries`
    batteries = self

    return self
end

return _batteries