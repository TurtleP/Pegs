#pragma once

u32 getCurrentColor();

void setScreen(int screen);

void setColor(int r, int g, int b);

void setColor(int r, int g, int b, int a);

void setColor(u32 color);

u32 getBackgroundColor();

void setBackgroundColor(u32 color);

int getCurrentScreen();

void translateCoords(float * x, float * y);

void translate(float x, float y);

void push();

void pop();

void setScissor(u32 x, u32 y, u32 width, u32 height);

void setScissor();

void drawRectangle(int x, int y, float width, float height);

void drawCircle(int x, int y, int r);

int getScreenWidth();

int getScreenHeight();