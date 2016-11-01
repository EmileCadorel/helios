module system.Input;
import gfm.sdl2, std.container;

struct KeyInfo {
    SDL_Keycode code;
    Uint32 type;
}

struct MouseInfo {
    Uint8 button;
    Uint32 type;
}

struct MouseEvent {
    int x, y;
    MouseInfo info;
}

class Input {

    class Signal (Type...) {
	alias SlotDel = void delegate (Type);
	alias SlotFunc = void function (Type);
	
	SList! (SlotDel) _slotDels;
	SList! (SlotFunc) _slotFuncs;
	
	void connect (SlotDel slot) {
	    this._slotDels.insertFront (slot);
	}

	void connect (SlotFunc slot) {
	    this._slotFuncs.insertFront (slot);
	}

	void opCall (Type elem) {
	    foreach (it ; this._slotFuncs)
		it (elem);
	    foreach (it ; this._slotDels)
		it (elem);
	}		
    }

    private Signal!KeyInfo [KeyInfo]  _keys;
    private Signal!MouseEvent [MouseInfo] _mouse;
    private Signal!MouseEvent _motion;
    private Signal !(int, int) _resize;
    private Signal !() _quit;
    private bool [Uint32] _isDown;

    this () {
	this._motion = new Signal!MouseEvent ();
	this._resize = new Signal!(int, int) ();
	this._quit = new Signal!()();
    }
    
    void poll () {
	SDL_Event e;
	while (SDL_PollEvent(&e)) {
	    if(e.type == SDL_KEYDOWN) {
		if (!isDown(e.key.keysym.sym)) {
		    KeyInfo info = KeyInfo(e.key.keysym.sym, e.type);
		    auto sig = this.keyboard (info);
		    this._isDown [info.code] = true;
		    sig(info);
		}
	    } else if (e.type == SDL_KEYUP) {
		auto info = KeyInfo (e.key.keysym.sym, e.type);
		auto sig = this.keyboard (info);
		this._isDown [info.code] = false;
		sig (info);
	    } else if (e.type == SDL_MOUSEBUTTONDOWN || e.type == SDL_MOUSEBUTTONUP) {
		auto info = MouseInfo (e.button.button, e.type);
		auto event = MouseEvent (e.button.x, e.button.y, info);
		auto sig = this.mouse (info);
		sig(event);
	    } else if (e.type == SDL_MOUSEMOTION) {
		auto info = MouseInfo (0, e.type);
		auto event = MouseEvent (e.motion.x, e.motion.y, info);
		this._motion (event);
	    } else if(e.type == SDL_QUIT) {
		this._quit ();
	    } else if (e.type == SDL_WINDOWEVENT) {
		if(e.window.event == SDL_WINDOWEVENT_SIZE_CHANGED) {
		    this._resize (e.window.data1, e.window.data2);
		}
	    }
	}	
    }

    Signal!KeyInfo keyboard(KeyInfo info) {
	auto it = (info in this._keys);
	if (it !is null) return *it;
	else {
	    auto ret = new Signal!KeyInfo;
	    this._keys [info] = ret;
	    return ret;
	}       
    }
    
    Signal!(MouseEvent) mouse(MouseInfo info) {
	auto it = (info in this._mouse);
	if (it !is null) return *it;
	else {
	    auto ret = new Signal!MouseEvent;
	    this._mouse [info] = ret;
	    return ret;
	}
    }
    
    Signal!(MouseEvent) motion() {
	return this._motion;
    }
    
    Signal!(int, int) winResize() {
	return this._resize;
    }

    Signal!() quit () {
	return this._quit;
    }
    
    private bool isDown (SDL_Keycode code) {
	auto it = (code in this._isDown);
	if (it !is null) return *it;
	else return false;
    }

    void clear () {
    }
    
}
