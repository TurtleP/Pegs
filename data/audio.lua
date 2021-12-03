local audio = {}
audio.inited = false

if not audio.inited then
    audio.menu = love.audio.newSource("audio/menu.ogg", "stream")
    audio.menu:setLooping(true)

    audio.inited = true
end

return audio
