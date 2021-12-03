local strings = {}
strings.inited = false

if not strings.inited then
    -- Main Menu
    strings.returnToMenu = "Press 'B' to Return to the Menu"

    strings.helpText = "To beat each level you must destroy all of the pegs. " ..
                       "If two of the same pegs are pushed into one another, " ..
                       "they will disappear, except for triangles which form " ..
                       "a solid block and plusses which allow you to choose a" ..
                       " replacement block of any type.\n\n" ..
                       strings.returnToMenu

    strings.subtitle = "A GAME OF OBJECT ELIMINATION..."

    strings.inited = true

    strings.version = "ver 0.1.0"
    strings.copyright = "© 2021 TurtleP"

    strings.playGame = "Play Game"
    strings.selectMappack = "Select Pack"
    strings.instructions = "Instructions"
    strings.bonus = "???? ??????"
end

return strings
