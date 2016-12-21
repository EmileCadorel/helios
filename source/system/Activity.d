module system.Activity;
public import system.Application, system.SurfaceView;
public import system.Intent;

abstract class Activity {

    private SurfaceView _surfaceView;
    private bool _close = false;
    
    void onCreate (Application context);

    void onPause () {}

    void onResume () {}
    
    void onUpdate ();

    void onDraw ();
    
    void onClose ();

    void setContentView (SurfaceView view) {
	this._surfaceView = view;
    }

    final void close () {
	this._close = true;
    }
    
    final bool isClose () {
	return this._close;
    }
    
}

