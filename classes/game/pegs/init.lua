local path = ...

return
{
    barrier  = require(path .. ".barrier"),
    base     = require(path .. ".peg"),
    gap      = require(path .. ".gap"),
    player   = require(path .. ".player"),
    plus     = require(path .. ".plus"),
    square   = require(path .. ".square"),
    triangle = require(path .. ".triangle")
}
