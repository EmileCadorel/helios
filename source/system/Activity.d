module system.Activity;
public import system.Application, system.SurfaceView;

abstract class Activity {

    private SurfaceView _surfaceView;
    
    void onCreate (Application context);

    void onUpdate ();

    void onDraw ();
    
    void onClose ();

    void setContentView (SurfaceView view) {
	this._surfaceView = view;
    }
    
}

