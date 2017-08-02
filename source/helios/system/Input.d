module helios.system.Input;
public import gfm.sdl2;
import std.container, std.algorithm;

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

    struct InputConnections { 
	Signal!KeyInfo [KeyInfo]  keys;
	Signal!(int, int, MouseInfo) [MouseInfo] mouse;
	Signal!(int, int, MouseInfo) motion;
	Signal !(int, int) resize;
	Signal !() quit;   
    }
    
    class Signal (Type...) {
	alias SlotDel = void delegate (Type);
	alias SlotFunc = void function (Type);
	
	Array! (SlotDel) _slotDels;
	Array! (SlotFunc) _slotFuncs;
	
	void connect (SlotDel slot) {
	    this._slotDels.insertBack (slot);
	}

	void connect (SlotFunc slot) {
	    this._slotFuncs.insertBack (slot);
	}

	void disconnect (SlotDel slot) {
	    auto it = this._slotDels[].find!"a is b" (slot);
	    if (!it.empty) {
		this._slotDels.linearRemove (it [0 .. 1]);
	    }
	}

	void disconnect (SlotFunc slot) {
	    auto it = this._slotFuncs[].find!"a is b" (slot);
	    if (!it.empty) {
		this._slotFuncs.linearRemove (it [0 .. 1]);
	    }
	}
	
	void opCall (Type elem) {
	    foreach (it ; this._slotFuncs)
		it (elem);
	    foreach (it ; this._slotDels)
		it (elem);
	}		
    }

    private SList!InputConnections _connects;
    private bool [Uint32] _isDown;

    this () {
	this._connects.insertFront (InputConnections ());
	this._connects.front.motion = new Signal!(int, int, MouseInfo) ();
	this._connects.front.resize = new Signal!(int, int) ();
	this._connects.front.quit = new Signal!()();
    }
    
    void poll () {
	SDL_Event e;
	while (SDL_PollEvent(&e)) {
	    if(e.type == SDL_KEYDOWN) {
		if (!isDown(e.key.keysym.sym)) {
		    KeyInfo info = KeyInfo(e.key.keysym.sym, e.type);
		    KeyInfo other = KeyInfo(e.key.keysym.sym, -1);
		    auto sig = this.keyboard (info);
		    auto sigother = this.keyboard (other);
		    this._isDown [info.code] = true;
		    sig(info);
		    sigother (info);
		}
	    } else if (e.type == SDL_KEYUP) {
		auto info = KeyInfo (e.key.keysym.sym, e.type);
		auto other = KeyInfo (e.key.keysym.sym, -1);
		auto sig = this.keyboard (info);
		auto sigother = this.keyboard (other);
		this._isDown [info.code] = false;
		sig (info);
		sigother (info);
	    } else if (e.type == SDL_MOUSEBUTTONDOWN || e.type == SDL_MOUSEBUTTONUP) {
		auto info = MouseInfo (e.button.button, e.type);
		auto other = MouseInfo (e.button.button, -1);
		auto sig = this.mouse (info);
		auto sigother = this.mouse (other);
		sig(e.button.x, e.button.y, info);
		sigother (e.button.x, e.button.y, info);
	    } else if (e.type == SDL_MOUSEMOTION) {
		auto info = MouseInfo (0, e.type);
		this._connects.front.motion (e.motion.x, e.motion.y, info);
	    } else if(e.type == SDL_QUIT) {
		this._connects.front.quit ();
	    } else if (e.type == SDL_WINDOWEVENT) {
		if(e.window.event == SDL_WINDOWEVENT_SIZE_CHANGED) {
		    this._connects.front.resize (e.window.data1, e.window.data2);
		}
	    }
	}	
    }

    Signal!KeyInfo keyboard(KeyInfo info) {
	auto it = (info in this._connects.front.keys);
	if (it !is null) return *it;
	else {
	    auto ret = new Signal!KeyInfo;
	    this._connects.front.keys [info] = ret;
	    return ret;
	}       
    }
    
    Signal!(int, int, MouseInfo) mouse(MouseInfo info) {
	auto it = (info in this._connects.front.mouse);
	if (it !is null) return *it;
	else {
	    auto ret = new Signal!(int, int, MouseInfo);
	    this._connects.front.mouse [info] = ret;
	    return ret;
	}
    }
    
    Signal!(int, int, MouseInfo) motion() {
	return this._connects.front.motion;
    }
    
    Signal!(int, int) winResize() {
	return this._connects.front.resize;
    }

    Signal!() quit () {
	return this._connects.front.quit;
    }
    
    private bool isDown (SDL_Keycode code) {
	auto it = (code in this._isDown);
	if (it !is null) return *it;
	else return false;
    }

    void store () {
	this._connects.insertFront (InputConnections());
    }

    void backup () {
	if (!this._connects.empty)
	    this._connects.removeFront ();
	
	if (this._connects.empty) 
	    this._connects.insertFront (InputConnections ());
    }
    
    void clear () {
	if (!this._connects.empty) {
	    this._connects.removeFront ();
	    this._connects.insertFront (InputConnections());	    
	}
    }
    
}
