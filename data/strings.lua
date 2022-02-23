local strings = {}
strings.inited = false

if not strings.inited then
    -- Main Menu
    strings.returnToMenu = "press 'b' to return"

    strings.info = "instructions/Rules:\n\n" ..
                   "1.destroy all pegs.\n\n" ..
                   "2.matches disappear.\n\n" ..
                   "3.triangles form a\n  solid block.\n\n" ..
                   "4.pluses allow you\n  to choose a\n  replacement.\n\n\n" ..
                   strings.returnToMenu

    strings.subtitle = "a game of\nobject\nelimination"

    strings.inited = true

    strings.version = "v0.1.0"
    strings.copyright = "C2021 turtlep"

    strings.playGame = "play game"
    strings.selectMappack = "select pack"
    strings.instructions = "instructions"
    strings.levelEditor = "Level Editor"

    strings.resetPacks = "press 'X' to reset"
end

return strings
