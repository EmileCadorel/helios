module system.Window;
import gfm.math, gfm.sdl2, gfm.opengl;
import std.file, std.path, std.experimental.logger;
import std.stdio;

class Window {

    private SDL2 _sdl2;
    private OpenGL _gl;
    private SDL2Window _window;
    private int _width, _height;
    
    this (Logger log) {
	initWindow (log);
    }

    void showCursor (bool show = false) {
	if (show) 
	    SDL_ShowCursor (SDL_ENABLE);
	else
	    SDL_ShowCursor (SDL_DISABLE);
    }
    
    private void initWindow (Logger log) {
	this._sdl2 = new SDL2 (null);
	this._gl = new OpenGL (null);	

	this._sdl2.subSystemInit (SDL_INIT_VIDEO);
	this._sdl2.subSystemInit (SDL_INIT_EVENTS);     

	SDL_GL_SetAttribute (SDL_GL_CONTEXT_MAJOR_VERSION, 3);
	SDL_GL_SetAttribute (SDL_GL_CONTEXT_MINOR_VERSION, 3);
	SDL_GL_SetAttribute (SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);

	SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 2);
	SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
	SDL_GL_SetAttribute (SDL_GL_MULTISAMPLESAMPLES, 8);
	
	const windowFlags = SDL_WINDOW_SHOWN |
	    SDL_WINDOW_INPUT_FOCUS |
	    SDL_WINDOW_MOUSE_FOCUS |
	    SDL_WINDOW_OPENGL;

	this._width = 600;
	this._height = 800;
	
	this._window = new SDL2Window (this._sdl2,
				       SDL_WINDOWPOS_UNDEFINED,
				       SDL_WINDOWPOS_UNDEFINED,
				       800,
				       600,
				       windowFlags);

	this._window.setTitle ("OpenGL_1");
	this._gl.reload ();
	this._gl.debugCheck ();
	this.defaultGLContext ();
    }

    private void defaultGLContext () {
	glEnable (GL_DEPTH_TEST);
	glDepthFunc (GL_LESS);
	glEnable (GL_CULL_FACE);
	glCullFace (GL_BACK);
	glEnable(GL_MULTISAMPLE);  
	/*glEnable(GL_BLEND);
	 glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);*/
    }

    OpenGL context () {
	return this._gl;
    }
    
    void clear () {
	glViewport (0, 0, this._width, this._height);
	glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    }
    
    void swap () {
	this._window.swapBuffers ();
    }
    
    ~this () {
	this._gl.destroy ();
	this._sdl2.destroy ();
	this._window.destroy ();       
    }
    

    
}
