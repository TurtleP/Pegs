#include "shared.h"

Title::Title()
{
    this->titleFont = new Font("graphics/PressStart2P.ttf", 48);

    this->titleImage = new Image("graphics/title.png");

    this->titleOptions =
    {
        "Play Game",
        "Map Editor",
        "View Credits",
        "Quit Game"
    };

    this->useFunctions =
    {
        [] (void) -> void { setCurrentState(GAME); },
        [] (void) -> void { setCurrentState(EDITOR); },
        [] (void) -> void { setCurrentState(CREDITS); },
        [] (void) -> void { forceQuit = true; }
    };
}

Title::~Title()
{
    delete this->titleFont;
    delete this->titleImage;
}

void Title::update(float dt)
{

}

void Title::activate()
{
    this->currentSelection = 0;
}

void Title::render()
{
    setScreen(GFX_TOP);

    setColor(255, 255, 255);

    this->titleImage->render(200 - this->titleImage->getWidth() / 2, 240 * 0.10);

    setColor(33, 33, 33);

    this->titleFont->print("(c) 2016 TurtleP", 200 - this->titleFont->getWidth("(c) 2016 TurtleP", 16) / 2, 240 * 0.38, 16);

    int width = this->titleFont->getWidth(this->titleOptions[this->currentSelection], 16);
    drawRectangle(200 - width / 2, 240 * 0.58 + (this->currentSelection * 22), width, 16);

    for (int i = 0; i < 4; i++)
    {
        if (this->currentSelection == i)
            setColor(245, 245, 245);
        else
            setColor(33, 33, 33);
            
        this->titleFont->print(this->titleOptions[i], 200 - this->titleFont->getWidth(this->titleOptions[i], 16) / 2, 240 * 0.58 + (i * 22), 16);
    }
}

void Title::keyPressed(char * key)
{
    if (strncmp(key, "down", 4) == 0)
        this->currentSelection = fmin(this->currentSelection + 1, 3);
    else if (strncmp(key, "up", 2) == 0)
        this->currentSelection = fmax(this->currentSelection - 1, 0);
    else if (strncmp(key, "a", 1) == 0)
        this->useFunctions[this->currentSelection]();
}

void Title::touch(int x, int y)
{
    printf("Touched %d, %d\n", x, y);
}

void Title::dispose()
{

}