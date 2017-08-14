module helios.gui.D3View;
import helios._;
import std.container;
import gfm.math;

class D3View : Widget {

    private void delegate (Camera, Array!Scene) _routine;

    private Camera _camera;

    private Array!Scene _scene;

    private vec4f _backGround = vec4f (0, 0, 0, 1);
    
    this (vec2f pos, vec2f size, void delegate (Camera, Array!Scene) drawRoutine) {
	this._position = pos;
	this._size = size;
	this._routine = drawRoutine;
    }

    ref Camera camera () {
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
	if (this._camera) {
	    std.stdio.writeln ("Ici");
	    this._camera.guide.disableInputs ();
	}
    }

    override bool is3D () {
	return true;
    }
    
    override void onDraw () {
	Application.currentContext.window.setViewPort (this._position, this._size);
	Application.currentContext.window.clearScissor (this._backGround, this._position, this._size);
	this._routine (this._camera, this._scene);
    }
}
