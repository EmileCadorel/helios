module helios.gui.Layout;
import helios.gui._;
import std.container;


class Layout : Widget {

    private Array!Widget _widget;

    this () {
    }

    void addWidget (Widget widget) {
	this._widget.insertBack (widget);
    }
    
    override void onDraw () {
	foreach (it ; this._widget) {
	    it.draw ();
	}
    }
           
}
