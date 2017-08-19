module helios.gui.Button;
import helios._;
import std.stdio, gfm.math;
import std.json, std.conv;
import std.algorithm;

class Button : LoadWidget!Button {

    private Signal!() _clicked;
    private Signal!() _rightClicked;    
    
    private Text _name;
    private bool _isHover;
    private bool _isClicked;

    private int _textSize;
    private float _relativeTextSize;
    private vec4f _textColor;


    private this (JSONValue value) {
	string name;
	if (auto x = "pos" in value) this._position = parsePos (*x);
	if (auto h = "size" in value) this._size = parseSize (*h);
	if (auto t = "text" in value) name = t.str;
	if (auto i = "id" in value) super.setId (i.str);
	if (auto r = "relative" in value) super.setRelative (r.integer.to!bool);
	if (auto col = "textColor" in value) this._textColor = parseColor (*col);
	if (auto ts = "textSize" in value) {
	    this._textSize = cast (int) ts.integer;
	    this._name = new Text (this._textSize);
	    this._name.color = this._textColor;
	    this._name.text = name;
	} else if (auto rts = "relativeTSize" in value) {
	    this._textSize = -1;
	    this._relativeTextSize = rts.floating;
	    this._name = new Text (cast (int) (this._relativeTextSize * min (this._size.y, this._size.x)));
	    this._name.color = this._textColor;
	    this._name.text = name;
	}

	this._clicked = new Signal!();
	this._rightClicked = new Signal!();
    }

    
    this (string name, int textSize = 15) {
	this._clicked = new Signal!();
	this._rightClicked = new Signal!();
	this._name = new Text (textSize);
	this._name.color = vec4f (1, 1, 1, 1);
	this._name.text = name;
    }

    this (vec2f pos, vec2f size, string name, int textSize = 15) {
	this._clicked = new Signal! ();
	this._rightClicked = new Signal! ();
	this.position = pos;
	this.size = size;
	this._name = new Text (textSize);
	this._name.color = vec4f (1, 1, 1, 1);
	this._name.text = name;
    }
    
    void textSize (int size) {
	auto text = this._name.text;
	this._name = new Text (size);
	this._name.color = vec4f (1, 1, 1, 1);
	this._name.text = text;
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

    override void onResize () {	
	if (this._textSize == -1) {
	    auto text = this._name.text;
	    this._name = new Text (cast (int) (this._relativeTextSize * min (this.size.y, this.size.x)));
	    this._name.text = text;
	}
    }
    
    Signal!() clicked () {
	return this._clicked;
    }

    Signal!() rightClicked () {
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

    static Widget load (JSONValue value) {
	return new Button (value);
    }
    
}

class ValButton (T...) : LoadWidget!Button {

    private Signal!(T) _clicked;
    private Signal!(T) _rightClicked;    
    
    private Text _name;
    private bool _isHover;
    private bool _isClicked;

    private int _textSize;
    private float _relativeTextSize;
    private vec4f _textColor;
    
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
