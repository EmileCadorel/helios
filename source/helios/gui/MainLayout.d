module helios.gui.MainLayout;
import helios.gui._;
import gfm.math;

final class MainLayout : Layout!MainLayout {

    this () {
	Application.currentContext.input.winResize.connect (&this.onResize);
    }

    void onResize (int x, int y) {
	auto size = vec2f (x, y);
	foreach (it ; this._widgets) {
	    if (it.isRelative) {
		it.size = size * it.relativeSize;
		it.innerPosition = size * it.relativePosition;
		it.onResize ();
	    }
	}

	foreach (it ; this._widgets3D) {
	    if (it.isRelative) {
		it.size = size * it.relativeSize;
		it.innerPosition = size * it.relativePosition;
		it.onResize ();
	    }		
	}
    }

    Widget opDispatch (string name) () {
	return this.getFromId (name);
    }
    
    override vec2f size () {
	return vec2f (Application.currentContext.window.width,
		      Application.currentContext.window.height);
    }

}
