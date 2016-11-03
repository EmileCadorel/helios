module system.Application;
import system.Input, system.Window, system.Camera;
import system.Timer, units.Second, system.Activity;
import gfm.opengl, system.Configuration, std.conv : to;
import gfm.sdl2;

class Application {

    private Timer _timer;
    private Window _window;
    private Input _input;
    
    private float _fps;
    private bool _isRunning;
    private Activity _current = null;
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
	this._current = cast(Activity) Object.factory (this._config.mainAct);
    }

    void show () {
	if (this._current !is null) {
	    this._current.onCreate (this);
	    
	    while (this._isRunning) {
		this._window.clear ();
		this._input.poll ();
		
		this._current.onUpdate ();
		this._current.onDraw ();
		
		this._window.swap ();
		this.calcFrameStats ();
	    }
	    
	    this._current.onClose ();
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

    SDL2 sdlContext () {
	return this._window.sdl ();
    }
    
    Input input () {
	return this._input;
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
