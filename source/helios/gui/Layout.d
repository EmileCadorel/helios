module helios.gui.Layout;
import helios.gui._;
import std.container, gfm.math;


class Layout (T) : LoadWidget!T {

    protected Array!Widget _widgets;

    protected Array!Widget _widgets3D;

    this () {
	this._position = vec2f (0, 0);
    }

    void addWidget (Widget widget) {
	if (widget.isRelative) {
	    widget.size = this.size * widget.relativeSize;
	    widget.innerPosition = this.size * widget.relativePosition;
	    widget.onResize ();
	}
	
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
		    return;
		}
	    }
	}

	foreach (self ; this._widgets3D) {
	    auto pos = self.position;
	    auto size = self.size;
	    if (pos.x <= x && pos.x + size.x >= x) {
		if (pos.y <= y && pos.y + size.y >= y) {
		    self.onClickRight (MouseEvent (x, y, info));
		    return;
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
		    return;
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
		    return;
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
		    return;
		}
	    }
	}

	foreach (self ; this._widgets3D) {
	    auto pos = self.position;
	    auto size = self.size;
	    if (pos.x <= x && pos.x + size.x >= x) {
		if (pos.y <= y && pos.y + size.y >= y) {
		    super.setHover (self, MouseEvent (x, y, info));
		    return;
		}
	    }
	}
    }

    override final void onClickRight (MouseEvent event) {
	this.clickRightSlot (event.x, event.y, event.info);
    }

    override final void onClick (MouseEvent event) {
	this.clickSlot (event.x, event.y, event.info);
    }

    override final void onHover (MouseEvent event) {
	this.motionSlot (event.x, event.y, event.info);
    }
    
    override void onDraw () {
	foreach (it ; this._widgets) {
	    if (!super.isFocused (it)) it.draw ();
	}
    }

    override void onDraw3D () {
	foreach (it ; this._widgets) {
	    if (!super.isFocused (it)) it.onDraw3D ();
	}
	
	foreach (it ; this._widgets3D) {
	    if (!super.isFocused (it)) it.onDraw3D ();
	}
    }

    final override Widget getFromId (string name) {
	if (this.id == name) return this;
	foreach (it ; this._widgets3D) {
	    auto got = it.getFromId (name);
	    if (got) return got;
	}

	foreach (it ; this._widgets) {
	    auto got = it.getFromId (name);
	    if (got) return got;
	}
	return null;	    
    }
    
    void clear () {
	this._widgets3D = make!(Array!Widget);
	this._widgets = make!(Array!Widget);
    }
    
}
