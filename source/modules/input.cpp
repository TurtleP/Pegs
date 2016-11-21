#include "shared.h"

u32 keyDown;
u32 keyUp;
u32 keyHeld;

int lastTouchX;
int lastTouchY;

touchPosition touch;

void scanInput()
{
    hidScanInput();

	hidTouchRead(&touch);

    keyDown = hidKeysDown();
    keyUp = hidKeysUp();
    keyHeld = hidKeysHeld();

	for (int keyIndex = 0; keyIndex < 32; keyIndex++)
	{
        if ((keyDown & BIT(keyIndex)) && keyIndex != 20)
        {
            getCurrentState()->keyPressed(keyNames[keyIndex]);
        }
    }

    for (int keyIndex = 0; keyIndex < 32; keyIndex++)
	{
        if ((keyDown & BIT(keyIndex)) && keyIndex != 20)
        {
            getCurrentState()->keyReleased(keyNames[keyIndex]);
        }
    }

    if (keyDown & BIT(20))
    {
        lastTouchX = touch.px;
        lastTouchY = touch.py;

        getCurrentState()->touch(touch.px, touch.py);
    }

    if (keyUp & BIT(20))
        getCurrentState()->touchRelease(lastTouchX, lastTouchY);
}

bool inside(int touchPosX, int touchPosY, int x, int y, int width, int height)
{
    return (touchPosX > x) && (touchPosX < x + width) && (touchPosY > y) && (touchPosY < y + height);
}