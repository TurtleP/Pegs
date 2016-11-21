//3DS and lib includes
#include <sf2d.h>
#include <sfil.h>
#include <sftd.h>
#include <3ds.h>

//Standard libs
#include <malloc.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <vector>
#include <ctime>
#include <sstream>

//Net stuff
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <fcntl.h>

//Ogg format things
#include <ivorbiscodec.h>
#include <ivorbisfile.h>

//Custom types
#include "types.h"

//Class includes
#include "../include/oggvorbis.h"
#include "../include/graphics.h"
#include "../include/quad.h"
#include "../include/image.h"
#include "../include/font.h"
#include "../include/input.h"

//States
#include "../include/state.h"
#include "../include/title.h"

extern STATE currentState;

extern std::vector<State *> states;

extern void displayError(const char * error);
extern bool romfsEnabled;
extern float delta;
extern bool channelList[24];
extern int currentScreen;
extern bool forceQuit;

extern float deltaStep();
extern char keyNames[32][32];

extern void setCurrentState(STATE state);
extern State * getCurrentState();