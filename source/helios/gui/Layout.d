module helios.gui.Layout;
import helios.gui._;
import std.container, gfm.math;


class Layout : Widget {

    private Array!Widget _widgets;

    private Array!Widget _widgets3D;

    this () {
	this._position = vec2f (30, 30);
    }

    void addWidget (Widget widget) {
	widget.parent = this;
	if (widget.is3D) this._widgets3D.insertBack (widget);
	else this._widgets.insertBack (widget);
    }

    final void clickRightSlot (int x, int y, MouseInfo info) {
	foreach (self ; this._widgets) {
	    auto pos = self.position;
	    auto size = self.size;
	    if (pos.x <= x && pos.x + size.x >= x) {
		if (pos.y <= y && pos.y + size.y >= y) {
		    self.onClickRight (MouseEvent (x, y, info));
		    break;
		}
	    }
	}

	foreach (self ; this._widgets3D) {
	    auto pos = self.position;
	    auto size = self.size;
	    if (pos.x <= x && pos.x + size.x >= x) {
		if (pos.y <= y && pos.y + size.y >= y) {
		    self.onClickRight (MouseEvent (x, y, info));
		    break;
		}
	    }	    
	}	
    }

    final void clickSlot (int x, int y, MouseInfo info) {	
	foreach (self ; this._widgets) {
	    auto pos = self.position;
	    auto size = self.size;
	    if (pos.x <= x && pos.x + size.x >= x) {
		if (pos.y <= y && pos.y + size.y >= y) {
		    self.isClicked = true;
		    super.setFocus (self);
		    self.onClick (MouseEvent (x, y, info));
		    break;
		}	    
	    }
	}

	foreach (self ; this._widgets3D) {
	    auto pos = self.position;
	    auto size = self.size;
	    if (pos.x <= x && pos.x + size.x >= x) {
		if (pos.y <= y && pos.y + size.y >= y) {
		    self.isClicked = true;
		    super.setFocus (self);
		    self.onClick (MouseEvent (x, y, info));
		    break;
		}	    
	    }
	}
    }

    final void motionSlot (int x, int y, MouseInfo info) {
	foreach (self ; this._widgets) {
	    auto pos = self.position;
	    auto size = self.size;
	    if (pos.x <= x && pos.x + size.x >= x) {
		if (pos.y <= y && pos.y + size.y >= y) {
		    super.setHover (self, MouseEvent (x, y, info));
		    break;
		}
	    }
	}

	foreach (self ; this._widgets3D) {
	    auto pos = self.position;
	    auto size = self.size;
	    if (pos.x <= x && pos.x + size.x >= x) {
		if (pos.y <= y && pos.y + size.y >= y) {
		    super.setHover (self, MouseEvent (x, y, info));
		    break;
		}
	    }
	}
    }
    
    override void onDraw () {
	foreach (it ; this._widgets) {
	    if (!super.isFocused (it)) it.draw ();
	}
	super.drawQuad (this._position, this.size, vec4f (0.2, 0.2, 0.2, 0.2));
    }

    void onDraw3D () {	
	foreach (it ; this._widgets3D) {
	    if (!super.isFocused (it)) it.draw ();
	}
    }

    void clear () {
	this._widgets3D = make!(Array!Widget);
	this._widgets = make!(Array!Widget);
    }

    override vec2f size () {
	return vec2f (Application.currentContext.window.width - 60,
		      Application.currentContext.window.height - 60);
    }
    
}
