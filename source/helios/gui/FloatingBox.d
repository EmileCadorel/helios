module helios.gui.FloatingBox;
import helios.gui._;
import helios.system._;
import helios.model._;
import std.stdio, gfm.math;

class FloatingBox : Widget {

    private bool _closed;
    
    this (vec2f pos, vec2f size, string name) {
	this.position = pos;
	this.size = size;       
    }

    override void onClick (MouseEvent event) {
	writeln ("FloatBox clicked");
	if (event.y <= position.y + 10)
	    this._closed = !this._closed;
    }

    override void onClickRight (MouseEvent event) {
	writeln ("FloatBox clicked");
    }

    override void onHover (MouseEvent event) {
	
    }

    override void onDraw () {
	super.drawQuad (this._position, vec2f (this._size.x, 10), vec4f (1, 1, 0, 0.7));
	if (!this._closed)
	    super.drawQuad (this._position + vec2f (0, 10), this._size, vec4f (1, 1, 1, 0.7));	
    }

}
