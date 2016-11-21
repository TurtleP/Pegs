#pragma once

class Title : public State
{
    public:
        Title();
        ~Title();
        
        void update(float dt);
        void render();
        void touch(int x, int y);
        void keyPressed(char * key);

        void dispose();

        void keyReleased(char * key) {};
        void touchRelease(int x, int y) {};

        void activate();
        
    private:
        Font * titleFont;

        Image * titleImage;

        std::vector<const char *> titleOptions;
        std::vector<OnUseFunction> useFunctions;
        
        int currentSelection;
};