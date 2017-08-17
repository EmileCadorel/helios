module helios.gui.MainLayout;
import helios.gui._;
import gfm.math;

final class MainLayout : Layout {
        
    override vec2f size () {
	return vec2f (Application.currentContext.window.width,
		      Application.currentContext.window.height);
    }

}
