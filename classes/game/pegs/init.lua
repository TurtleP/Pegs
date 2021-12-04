local path = ...

return
{
    base = require(path .. ".peg"),
    player = require(path .. ".player"),
    plus = require(path .. ".plus"),
    triangle = require(path .. ".triangle")
}
