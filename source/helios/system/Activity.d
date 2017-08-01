module helios.system.Activity;
public import helios.system._;

abstract class Activity {

    private bool _close = false;
    
    void onCreate (Application context);

    void onPause () {}

    void onResume () {}
    
    void onUpdate ();

    void onDraw2D () {}
    
    void onDraw ();
    
    void onClose ();

    final void close () {
	this._close = true;
    }
    
    final bool isClose () {
	return this._close;
    }
    
}

