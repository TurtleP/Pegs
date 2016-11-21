/*
	The MIT License (MIT)

	Copyright (c) 2016 Jeremy 'TurtleP' Postelnek - jeremy.postelnek@gmail.com

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
*/

#include "shared.h"

bool romfsEnabled = false;
bool channelList[24];
bool hasError = false;
bool forceQuit = false;
bool audioEnabled = false;

bool consoleEnabled = true;
gfxScreen_t consoleScreen = GFX_BOTTOM;

int prevTime = 0;
int currTime = 0;
float dt;
std::vector<State *> states;

STATE currentState;

State * getCurrentState()
{
	return states[currentState];
}

void setCurrentState(STATE state)
{
	currentState = state;

	states[state]->activate(); //init things WITHOUT the constructor (timers, etc)
}

float deltaStep()
{
	prevTime = currTime;

	currTime = osGetTime();

	dt = currTime - prevTime;

	dt = dt * 0.001;

	if (dt < 0) dt = 0; // Fix nasty timer bug

	return dt;
}

void displayError(const char * error)
{	
	sf2d_set_clear_color(RGBA8(0, 0, 0, 0xFF));

	hasError = true;

	consoleInit(GFX_TOP, NULL);

	printf("\n\x1b[31mError: %s\x1b[0m\nPress 'Start' to quit.\n", error);
}

int main()
{
	srand(osGetTime());

	sf2d_init(); // 2D Drawing lib.

	sftd_init(); // Text Drawing lib.

	cfguInit(); //Configuration stuff

	ptmuInit(); //System stuff kind of

	if (consoleEnabled) 
		consoleInit(consoleScreen, NULL);

	setBackgroundColor(RGBA8(224, 224, 224, 0xFF)); // Reset background color.

	Result enableROMFS = romfsInit();

	romfsEnabled = (enableROMFS) ? false : true;

	//audioEnabled = !ndspInit();

	if (romfsEnabled) 
		chdir("romfs:/");

	states =
	{
		new Title
	};

	setCurrentState(TITLE);
	
	//if (!audioEnabled) 
		//displayError("DSP Failed to initialize. Please dump your DSP Firm!");

	deltaStep();

	while (aptMainLoop())
	{
		if (!forceQuit)
		{
			if (!hasError)
			{
				scanInput();

				getCurrentState()->update(deltaStep());

				//Start top screen
				if (!consoleEnabled || (consoleEnabled && consoleScreen != GFX_TOP))
				{
					sf2d_start_frame(GFX_TOP, GFX_LEFT);
					
					getCurrentState()->render();

					sf2d_end_frame();
				}
				//Start bottom screen
				if (!consoleEnabled || (consoleEnabled && consoleScreen != GFX_BOTTOM))
				{
					sf2d_start_frame(GFX_BOTTOM, GFX_LEFT);

					getCurrentState()->render();

					sf2d_end_frame();
				}

				sf2d_swapbuffers();
			}
			else
			{
				hidScanInput();

				u32 kTempDown = hidKeysDown();

				if (kTempDown & KEY_START)
					break;
			}
		}
	}

	sftd_fini();

	sf2d_fini();

	cfguExit();

	ptmuExit();

	if (romfsEnabled) 
		romfsExit();

	if (audioEnabled) 
		ndspExit();

	return 0;
}
