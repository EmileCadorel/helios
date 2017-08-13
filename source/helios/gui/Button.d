module helios.gui.Button;
import helios._;
import std.stdio, gfm.math;

class Button : Widget {

    private Signal!() _clicked;
    private Signal!() _rightClicked;    
    
    private Text _name;
    private bool _isHover;
    private bool _isClicked;
    
    this (vec2f pos, vec2f size, string name) {
	this._clicked = new Signal! ();
	this._rightClicked = new Signal! ();
	this.position = pos;
	this.size = size;
	this._name = new Text (15);
	this._name.color = vec4f (1, 0, 0, 1);
	this._name.text = name;
    }

    override void onClick (MouseEvent event) {
	this._isClicked = true;
	this._clicked ();
    }

    override void onClickEnd (MouseEvent event) {
	this._isClicked = false;
    }

    override void onClickRight (MouseEvent event) {
	this._rightClicked ();
    }

    override void onHover (MouseEvent event) {
	this._isHover = true;
    }

    override void onHoverEnd (MouseEvent event) {
	this._isHover = false;
    }

    Signal!() clicked () {
	return this._clicked;
    }

    Signal!() rightClicked () {
	return this._rightClicked;
    }
    
    override void onDraw () {
	if (this._isClicked) {
	    super.drawQuad (this._position, this._size, vec4f (72. / 255., 136. / 255., 239. / 255., 1));
	} else if (this._isHover) {
	    super.drawQuad (this._position, this._size, vec4f (174. / 255., 167. / 255., 159. / 255., 1));
	} else {
	    super.drawQuad (this._position, this._size, vec4f (210. / 255., 218. / 255., 174. / 255., 1));
	}
	super.drawTextCenter (this._position, this._size, this._name);
    }
    

}
