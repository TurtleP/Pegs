local audio = {}
audio.inited = false
audio.nowPlaying = nil

if not audio.inited then
    audio.menu = love.audio.newSource("audio/menu.ogg", "stream")
    audio.menu:setLooping(true)

    audio.game = love.audio.newSource("audio/game.ogg", "stream")
    audio.game:setLooping(true)

    audio.win = love.audio.newSource("audio/win.ogg", "static")
    audio.die = love.audio.newSource("audio/died.ogg", "static")
    audio.wrong = love.audio.newSource("audio/mismatch.ogg", "static")

    audio.inited = true
end

function audio:play(sound, stop)
    stop = stop and true or false

    if self.nowPlaying and not stop then
        self.nowPlaying:stop()
    end
    self[sound]:play()
    self.nowPlaying = self[sound]
end

function audio:stopped(sound)
    if self[sound] then
        return not self[sound]:isPlaying()
    end
    return false
end

return audio
