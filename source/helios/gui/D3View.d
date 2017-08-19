module helios.gui.D3View;
import helios._;
import std.container;
import gfm.math, std.json;

class D3View : LoadWidget!D3View {

    private void delegate (Camera, Array!Scene) _routine;

    private Camera _camera;

    private Array!Scene _scene;

    private vec4f _backGround = vec4f (0, 0, 0, 1);

    private this (JSONValue value) {
	if (auto id = "id" in value) super.setId (id.str);
    }
    
    this (vec2f pos, vec2f size, void delegate (Camera, Array!Scene) drawRoutine) {
	this._position = pos;
	this._size = size;
	this._routine = drawRoutine;
    }

    this (void delegate (Camera, Array!Scene) drawRoutine) {
	this._routine = drawRoutine;
    }

    ref void delegate (Camera, Array!Scene) drawRoutine () {
	return this._routine;
    }

    void camera (Camera cam) {
	this._camera = cam;
	if (cam) cam.ratio (this.size.x / this.size.y);
    }
    
    Camera camera () {
	return this._camera;
    }

    ref Array!Scene scenes () {
	return this._scene;
    }
    
    override void onFocusGain () {
	if (this._camera) 
	    this._camera.guide.enableInputs ();	
    }

    override void onFocusLose () {
	if (this._camera) 
	    this._camera.guide.disableInputs ();	
    }

    override bool is3D () {
	return true;
    }

    override void onDraw () {
    }

    override void onResize () {
	if (this._camera) {
	    this._camera.ratio (this.size.x / this.size.y);
	}	    
    }
    
    override void onDraw3D () {
	Application.currentContext.window.setViewPort (this._position, this._size);
	Application.currentContext.window.clearScissor (this._backGround, this._position, this._size);
	this._routine (this._camera, this._scene);
    }

    static Widget load (JSONValue value) {
	return new D3View (value);
    }
}
