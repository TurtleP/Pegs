-- Credits code by Qcode, Thanks!
function credits_load()
			--[[I have to go to work soon, here's to you hat:
				Don't have finishedcredits = false here because it WILL mess up things.. maybe.
				I also updated the Achievementslist.lua file to allow the easy adding of the achievments
				and their respective quads]]
			--[[hey, jmiester14 here, I fixed my name ^_^, and yes, I remembered to add
			    flutter pie for this! Also, you may have to fix the last line's stopping point X_X]]--
            love.audio.stop(menu)
			playsound(creditssong)
            gamestate = "credits"
            love.graphics.setBackgroundColor(0, 0, 0)
            creditstext = {}
            creditstext[1] = "CREDITS:"
            creditstext[2] = "PEGS: Lua edition"
            creditstext[3] = "BY TINY TURTLE INDUSTRIES"
            creditstext[4] = "PROJECT LEAD PROGRAMMER:"
            creditstext[5] = "JEREMY POSTELNEK: TURTLEP"
            creditstext[6] = "GRAPHICS MADE BY:"
            creditstext[7]	= "Jeremy Postelnek: TurtleP"		
			creditstext[8] = "MUSIC MADE BY:"
			creditstext[9] = "KYLE PRIOR: editor"
            creditstext[10] = "St. happyfaces: BGM, credits"
            creditstext[11] = "B-MAN99: Menu"
			creditstext[12] = "BETA TESTING:"
			creditstext[13] = "E. FLIPPER: THUNDERFLIPPER"
			creditstext[14] = "HANK DORKO: BLACKPANDA"
			creditstext[15] = "JAYDEN MACKENZIE: PYROMANIAC"
            creditstext[16] = "FLUTTER PIE"
            creditstext[17] = "Hatninja"
            creditstext[18] = "Jordan Echoff: Jmiester14"
            creditstext[19] = "Idiot 9.0"
            creditstext[20] = "Rokit Boy"
            creditstext[21] = "CODING CONTRIBUTIONS:"
            creditstext[22] = "AUTOMATIK: Valid Editor map"
            creditstext[23] = " "
            creditstext[24] = " "
			creditstext[25] = "WE THANK YOU FOR PLAYING!"		
			creditstext[26] = "VISIT US AT:"
            creditstext[27] = "www.tinyturleindustries"
            creditstext[28] = ".blogspot.com"
            
            --Credits text.
            creditsscroll = 0
            height = love.graphics.getHeight()
            creditsy = {}
            creditsy[1] = height/2
            creditsy[2] = height - height/3
            creditsy[3] = height + height/3
            for i = #creditsy, #creditstext do
                    creditsy[i] = creditsy[i-1] + height/3
            end
            stopscrolling = false
            pressedspace = false
            finishedcredits = false
            stopscrollingtimer = 0

        creditstextX = {
            80*scale,
            88*scale,
            25*scale,
            30*scale,
            35*scale,
            63*scale,
            35*scale,
            63*scale,
            35*scale,
            35*scale,
            35*scale,
            35*scale,
            35*scale,
            35*scale,
            35*scale,
            35*scale,
            35*scale,
            35*scale,
            15*scale,
            35*scale,
            35*scale,
            60*scale,
        }
end
            --WEE SIMPLE
function credits_update(dt)
            if creditsscroll > 4899 then
            	stopscrolling = true
            end
            if not stopscrolling then
	            if love.keyboard.isDown(" ") then
	               	creditsscroll = creditsscroll + (70 *scale) *  dt
	               	pressedspace = true
	            else
	               	creditsscroll = creditsscroll + (11 *scale) *  dt
	            end
	        else
	        	stopscrollingtimer = stopscrollingtimer + 1*dt
	        	if stopscrollingtimer > 3 then
	        		if not pressedspace then
	        			finishedcredits = true
	        		end
		            menu_load(false)
	                gamestate = "menu"
	            end
	        end
end
     
function credits_draw()
			love.graphics.setColor(255, 255, 255)
            love.graphics.push()
            love.graphics.translate(0, -creditsscroll)
            for i, v in pairs(creditstext) do
            	--[[if i == 5 then
            		love.graphics.draw(turtelimg, love.graphics.getWidth()/2-((string.len(v)*scale))*3-40,  creditsy[i])
            	elseif i == 9 then
            		love.graphics.draw(idiotimg, love.graphics.getWidth()/2-((string.len(v)*scale))*3-40,  creditsy[i])
            	elseif i == 10 then
            		love.graphics.draw(hatimg,love.graphics.getWidth()/2-((string.len(v)*scale))*3-40,  creditsy[i]-24,0,2,2)
            	elseif i == 13 then
    	       		love.graphics.draw(kyleimg,love.graphics.getWidth()/2-((string.len(v)*scale))*3-40,  creditsy[i],0,2,2)
    	       	elseif i == 15 then
    	       		love.graphics.draw(flipperimg,love.graphics.getWidth()/2-((string.len(v)*scale))*3-40,  creditsy[i])
    	       	elseif i == 11 then
    	       		love.graphics.draw(jmiesterimg,love.graphics.getWidth()/2-((string.len(v)*scale))*3-40,  creditsy[i],0,2,2)
    	       	elseif i == 17 then
    	      		love.graphics.draw(pyroimg,love.graphics.getWidth()/2-((string.len(v)*scale))*3-40,  creditsy[i],0,2,2)
    	       	end]]
                gameprint(gamestring(v), 1,  creditsy[i], -1)
            end
            love.graphics.pop()
            if not stopscrolling then
            	love.graphics.print("PRESS SPACE TO SCROLL FASTER",1,2)
            end
end
     
function credits_keypressed(key, unicode)
		if key == "escape" or key == "return" then
			menu_load()
		end
end
