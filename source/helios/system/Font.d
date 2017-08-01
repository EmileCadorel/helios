module helios.system.Font;
import gfm.sdl2, helios.system._;
import helios.utils.Singleton;

class Font {

    private SDLFont [string] _loaded;

    SDLFont getFont (string name, int size) {
	return null;
    }    
    
    mixin Singleton;
}


