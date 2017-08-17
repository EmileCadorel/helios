module helios.gui.LinearLayout;
import helios.gui._;
import std.container, gfm.math;


class LinearLayout : Layout {

    public enum Gravity {
	TOP,
	BOTTOM,
	LEFT,
	RIGHT
    }

    private Gravity _gravity;
    
    this (vec2f position, vec2f size, Gravity gravity) {
	this._position = position;
	this._size = size;
	this._gravity = gravity;
    }

    override void addWidget (Widget widget) {
	auto position = vec2f (0, 0);
	if (this._gravity == Gravity.TOP) {
	    if (!this._widgets.empty) {
		auto last = this._widgets.back ();
		if (!this._widgets3D.empty) {
		    if (this._widgets3D.back().position.y > last.position.y)
			last = this._widgets3D.back ();
		}
		position.y = last.innerPosition.y + last.size.y;		
	    } 
	} else if (this._gravity == Gravity.BOTTOM) {
	    position = vec2f (0, this._size.y - widget.size.y);
	    if (!this._widgets.empty) {
		auto last = this._widgets.back ();
		if (!this._widgets3D.empty) {
		    if (this._widgets3D.back().position.y < last.position.y)
			last = this._widgets3D.back ();
		}
		position.y = last.innerPosition.y - widget.size.y;		
	    }
	} else if (this._gravity == Gravity.LEFT) {
	    if (!this._widgets.empty) {
		auto last = this._widgets.back ();
		if (!this._widgets3D.empty) {
		    if (this._widgets3D.back().position.x > last.position.x)
			last = this._widgets3D.back ();
		}
		position.x = last.innerPosition.x + last.size.x;		
	    } 
	} else {
	    position = vec2f (this._size.x - widget.size.x, 0);
	    if (!this._widgets.empty) {
		auto last = this._widgets.back ();
		if (!this._widgets3D.empty) {
		    if (this._widgets3D.back().position.x < last.position.x)
			last = this._widgets3D.back ();
		}
		position.x = last.innerPosition.x - widget.size.x;		
	    }
	}
	widget.innerPosition = position;
	super.addWidget (widget);
    }
    
    override void onDraw () {
	super.drawQuad (this.position, this.size, vec4f (0.2, 0.2, 0.2, 0.2));
	super.onDraw ();
    }

}
