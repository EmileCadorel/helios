module system.Application;
import system.Input, system.Window, system.Camera;
import system.Timer, units.Second, system.Activity;
import gfm.opengl, system.Configuration, std.conv : to;
import gfm.sdl2, system.Intent, std.container;

class Application {

    private Timer _timer;
    private Window _window;
    private Input _input;
    private Intent _intent;

    private float _fps;
    private bool _isRunning;
    private Array!Activity _current;
    private Configuration _config;
    
    this (string configFile) {
	this._config = Configuration (configFile);
	this._timer = new Timer ();
	this._window = new Window (this._config.name,
				   this._config.width,
				   this._config.height);
	
	this._input = new Input ();

	this._isRunning = true;
	this._input.quit.connect (&this.stop);
	this._current.insertBack (cast(Activity) Object.factory (this._config.activities ["main"]));
    }

    void show () {
	this._current.back (). onCreate (this);
	
	while (this._isRunning) {
	    this._input.poll ();
	    this._window.clear ();

	    if (this._current.back.isClose ()) {
		this._input.backup ();
		this._current.back.onClose ();
		this._current.removeBack ();
		if (this._current.length == 0) break;
		else this._current.back.onResume ();
	    }
	    
	    this._current.back.onUpdate ();
	    this._current.back.onDraw2D ();
	    //this._window.sdlRenderer.present ();

	    this._current.back.onDraw ();
	    
	    this._window.swap ();
	    this.calcFrameStats ();
	}
	
	foreach (it ; this._current) {
	    it.onClose ();
	}	
    }
    
    void launch (string name) {
	auto actName = name in this._config.activities;
	if (actName is null) {
	    assert (false, "Intent " ~ name ~ " n'existe pas");
	} else {
	    this._current.back ().onPause ();
	    this._input.store ();
	    auto act = cast (Activity) Object.factory (*actName);
	    act.onCreate (this);
	    this._current.insertBack (act);
	}
    }

    float getFps () {
	return this._fps;
    }

    void stop () {
	this._isRunning = false;
    }

    OpenGL openglContext () {
	return this._window.context ();
    }
        
    SDL2Renderer sdlRenderer () {
	return this._window.sdlRenderer;
    }

    SDL2 sdlContext () {
	return this._window.sdl ();
    }
    
    Input input () {
	return this._input;
    }
    
    ref Intent intent () {
	return this._intent;
    }

    private void calcFrameStats () {
	static int frameCount = 0;
	frameCount ++;
	this._timer.tick();
	if(this._timer.elapsed() > Second (1)) {
	    this._timer.frame();
	    
	    this._fps = cast (float) frameCount;
	    frameCount = 0;

	    this._window.setTitle (this._config.name ~ " - " ~ to!string (this._fps));
	}
    }


}
