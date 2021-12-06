local path = ...

return
{
    death = require(path .. ".message_die"),
    win   = require(path .. ".message_win")
}
