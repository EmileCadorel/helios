module helios.gui.Button;
import helios._;
import std.stdio, gfm.math;

class Button (T...) : Widget {

    private Signal!(T) _clicked;
    private Signal!(T) _rightClicked;    
    
    private Text _name;
    private bool _isHover;
    private bool _isClicked;

    private T _value;
    
    this (string name, T value, int textSize = 15) {
	this._clicked = new Signal!(T);
	this._rightClicked = new Signal!(T);
	this._name = new Text (textSize);
	this._name.color = vec4f (1, 1, 1, 1);
	this._name.text = name;
	this._value = value;
    }
    
    this (vec2f pos, vec2f size, string name, T value, int textSize = 15) {
	this._clicked = new Signal! (T);
	this._rightClicked = new Signal! (T);
	this.position = pos;
	this.size = size;
	this._name = new Text (textSize);
	this._name.color = vec4f (1, 1, 1, 1);
	this._name.text = name;
	this._value = value;
    }

    void textSize (int size) {
	auto text = this._name.text;
	this._name = new Text (size);
	this._name.color = vec4f (1, 1, 1, 1);
	this._name.text = text;
    }
    
    override void onClick (MouseEvent event) {
	this._isClicked = true;
	this._clicked (this._value);
    }

    override void onClickEnd (MouseEvent event) {
	this._isClicked = false;
    }

    override void onClickRight (MouseEvent event) {
	this._rightClicked (this._value);
    }

    override void onHover (MouseEvent event) {
	this._isHover = true;
    }

    override void onHoverEnd (MouseEvent event) {
	this._isHover = false;
    }

    Signal!(T) clicked () {
	return this._clicked;
    }

    Signal!(T) rightClicked () {
	return this._rightClicked;
    }
    
    override void onDraw () {
	if (this._isClicked) {
	    super.drawQuad (this.position, this._size, vec4f (72. / 255., 136. / 255., 239. / 255., 1));
	} else if (this._isHover) {
	    super.drawQuad (this.position, this._size, vec4f (174. / 255., 167. / 255., 159. / 255., 1));
	} else {
	    super.drawQuad (this.position, this._size, vec4f (0.4, 0.4, 0.4, 1));
	}
	super.drawTextCenter (this.position, this._size, this._name);
    }
    
}
