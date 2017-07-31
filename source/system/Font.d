module system.Font;
import gfm.sdl2, system.Application;
import utils.Singleton;

class Font {

    private SDLFont [string] _loaded;

    SDLFont getFont (string name, int size) {
	return null;
    }    
    
    mixin Singleton;
}


