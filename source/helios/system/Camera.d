module helios.system.Camera;
import helios.system._;
import gfm.opengl, gfm.math, std.math;

class Guide {

    private Camera _camera;
    private Application _context;
	
    this (Application context) {
	this._context = context;
    }

    protected void inform (Camera who) {
	this._camera = who;
    }
        
}

class Camera {
       
    private mat4f _projection;
    private mat4f _view;

    private vec3f _eye;
    private vec3f _target;
    private vec3f _up;

    private Guide _guide;
    private float _fov;
    private float _near;
    private float _far;
    private float _ratio;

    private bool _changed;

    void near (float near) {
	this._near = near;
	this._changed = true;
    }
    
    void far (float far) {
	this._far = far;
	this._changed = true;
    }
    
    void ratio (float ratio) {
	this._ratio = ratio;
	this._changed = true;
    }
    
    void fov (float fov) {
	this._fov = fov;
	this._changed = true;
    }

    void guide (Guide gui) {
	this._guide = gui;
	this._guide.inform (this);
    }
    
    const (Guide) guide () {
	return this._guide;
    }

    void eye (vec3f eye) {
	this._eye = eye;
	this._changed = true;
    }

    vec3f eye () const {
	return this._eye;
    }
       
    void target (vec3f target) {
	this._target = target;
	this._changed = true;
    }

    vec3f target () const {
	return this._target;
    }
    
    void up (vec3f up) {
	this._up = up;
	this._changed = true;
    }

    vec3f up () const {
	return this._up;
    }    
    
    void perspective (float fov, float ratio, float near, float far) {
	this._fov = fov;
	this._ratio = ratio;
	this._near = near;
	this._far = far;
	this._changed = true;
    }

    void lookAt (vec3f eye, vec3f target, vec3f up) {
	this._eye = eye;
	this._target = target;
	this._up = up;
	this._changed = true;
    }
    
    mat4f getP () {
	if (this._changed) {
	    this._projection = mat4f.perspective (this._fov, this._ratio, this._near, this._far);
	}
	return this._projection;
    }

    mat4f getV () {
	if (this._changed) {
	    this._view = mat4f.lookAt (this._eye, this._target, this._up);
	}
	return this._view;
    }

    mat4f getVP () {
	if (this._changed) {
	    this._projection = mat4f.perspective (this._fov, this._ratio, this._near, this._far);
	    this._view = mat4f.lookAt (this._eye, this._target, this._up);
	}
	return this._projection * this._view;
    }

}

class TPSGuide : Guide {

    private long _phi = 0;
    private long _teta = 60;
    private int _ancx = -1, _ancy = -1;
    private double _precise = 0.2;
    private double _radius = 4.;
    private bool _started;
    
    this (Application context) {
	super (context);
	context.input.mouse (MouseInfo (SDL_BUTTON_LEFT, -1)).connect (&this._start);
	context.input.motion.connect (&this._update);	
    }

    private void _start (int, int, MouseInfo info) {
	this._started = info.type == SDL_MOUSEBUTTONDOWN;
	if (SDL_MOUSEBUTTONUP) {
	    this._ancy = -1;
	    this._ancx = -1;
	}
    }
    
    private void _update (int x, int y, MouseInfo) {
	if (this._started) {
	    if (this._ancx != -1) {
		auto posx = this._ancx - x;
		auto posy = this._ancy - y;
		this._phi = (this._phi + cast(long)(this._precise * posx)) % 360;
		this._teta = (this._teta - cast (long) (this._precise * posy)) % 360;
		if (this._camera !is null) {
		    auto pos = this._camera.eye;
		    auto target = this._camera.target;		    
		    this._radius = abs (sqrt ((target.x - pos.x) ^^2 + (target.z - pos.z) ^^2 + (target.y - pos.y) ^^2));
		    pos.x = target.x + this._radius * sin(this._teta * PI / 180.0) * sin(this._phi * PI / 180.0);
		    pos.y = target.y + this._radius * cos(this._teta* PI / 180.0);
		    pos.z = target.z + this._radius * sin(this._teta * PI / 180.0) * cos(this._phi* PI / 180.0);
		    this._camera.eye = pos;
		    this._camera.target = target;
		}
	    }
	    this._ancx = x;
	    this._ancy = y;
	}
    }

    void zoom () {
	if (this._camera !is null) {
	    auto pos = this._camera.eye;
	    auto target = this._camera.target;
	    this._radius = abs (sqrt ((target.x - pos.x) ^^2 + (target.z - pos.z) ^^2 + (target.y - pos.y) ^^2));
	    this._radius -= 0.2;
	    pos.x = target.x + this._radius * sin(this._teta * PI / 180.0) * sin(this._phi * PI / 180.0);
	    pos.y = target.y + this._radius * cos(this._teta* PI / 180.0);
	    pos.z = target.z + this._radius * sin(this._teta * PI / 180.0) * cos(this._phi* PI / 180.0);
	    this._camera.eye = pos;
	    this._camera.target = target;
	}
    }

    void unzoom () {
	if (this._camera !is null) {
	    auto pos = this._camera.eye;
	    auto target = this._camera.target;
	    this._radius = abs (sqrt ((target.x - pos.x) ^^2 + (target.z - pos.z) ^^2 + (target.y - pos.y) ^^2));
	    this._radius += 0.2;
	    pos.x = target.x + this._radius * sin(this._teta * PI / 180.0) * sin(this._phi * PI / 180.0);
	    pos.y = target.y + this._radius * cos(this._teta* PI / 180.0);
	    pos.z = target.z + this._radius * sin(this._teta * PI / 180.0) * cos(this._phi* PI / 180.0);
	    this._camera.eye = pos;
	    this._camera.target = target;
	}
    }
        
    
}
