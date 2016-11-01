module system.Camera;
import gfm.opengl, gfm.math;

class Camera {

    private mat4f _projection;
    private mat4f _view;

    private vec3f _eye;
    private vec3f _target;
    private vec3f _up;

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
    
    void eye (vec3f eye) {
	this._eye = eye;
	this._changed = true;
    }

    void target (vec3f target) {
	this._target = target;
	this._changed = true;
    }

    void up (vec3f up) {
	this._up = up;
	this._changed = true;
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
