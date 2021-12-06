local audio = {}
audio.inited = false
audio.nowPlaying = nil

if not audio.inited then
    audio.menu = love.audio.newSource("audio/menu.ogg", "stream")
    audio.menu:setLooping(true)

    audio.game = love.audio.newSource("audio/game.ogg", "stream")
    audio.game:setLooping(true)

    audio.win = love.audio.newSource("audio/win.ogg", "static")

    local hurtSound = "hurt%d.ogg"
    for i = 1, 3 do
        audio["hurt" .. i] = love.audio.newSource("audio/" .. hurtSound:format(i), "static")
    end

    audio.inited = true
end

function audio:play(sound)
    if self.nowPlaying then
        self.nowPlaying:stop()
    end
    self[sound]:play()
    self.nowPlaying = self[sound]
end
return audio
