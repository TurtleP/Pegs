#pragma once

class State
{
    public:
        virtual void touch(int x, int y);
        virtual void update(float dt);
        virtual void render();
        virtual void dispose();
        
        virtual void keyPressed(char * key);
        virtual void keyReleased(char * key);
        virtual void touchRelease(int x, int y);
        virtual void activate();
};