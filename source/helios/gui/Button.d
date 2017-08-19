module helios.gui.Button;
import helios._;
import std.stdio, gfm.math;
import std.json, std.conv;
import std.algorithm;

class Button : LoadWidget!Button {

    private Signal!(Button) _clicked;
    private Signal!(Button) _rightClicked;    
    
    private Text _name;
    private bool _isHover;
    private bool _isClicked;

    private float _relativeTextSize;
    private vec4f _textColor;


    private this (JSONValue value) {
	string name;
	if (auto x = "position" in value) this._position = parsePos (*x);
	if (auto h = "size" in value) this._size = parseSize (*h);
	if (auto t = "text" in value) name = t.str;
	if (auto i = "id" in value) super.setId (i.str);
	if (auto r = "relative" in value) super.setRelative (r.integer.to!bool);
	if (auto col = "textColor" in value) this._textColor = parseColor (*col);
	if (auto rts = "relativeTSize" in value) this._relativeTextSize = rts.floating;
	else this._relativeTextSize = 0.5;
	
	this._name = new Text (TextQuality.HIGH);
	this._name.color = this._textColor;
	this._name.text = name;
	
	this._clicked = new Signal!(Button);
	this._rightClicked = new Signal!(Button);
    }

    
    this (string name, int textSize = 15) {
	this._clicked = new Signal!(Button);
	this._rightClicked = new Signal!(Button);
	this._name = new Text (TextQuality.HIGH);
	this._name.color = vec4f (1, 1, 1, 1);
	this._name.text = name;
	onResize ();
    }

    this (vec2f pos, vec2f size, string name, int textSize = 15) {
	this._clicked = new Signal! (Button);
	this._rightClicked = new Signal! (Button);
	this.position = pos;
	this.size = size;
	this._name = new Text (TextQuality.HIGH);
	this._name.color = vec4f (1, 1, 1, 1);
	this._name.text = name;
	onResize ();
    }
        
    override void onClick (MouseEvent event) {
	this._isClicked = true;
	this._clicked (this);
    }

    override void onClickEnd (MouseEvent event) {
	this._isClicked = false;
    }

    override void onClickRight (MouseEvent event) {
	this._rightClicked (this);
    }

    override void onHover (MouseEvent event) {
	this._isHover = true;
    }

    override void onHoverEnd (MouseEvent event) {
	this._isHover = false;
    }

    override void onResize () {	
	this._name.size.y = this._relativeTextSize * this.size.y;
	this._name.size.x = this._name.size.y * this._name.ratioX;
	if (this._name.size.x > this.size.x) {
	    this._name.size.x = this.size.x * 0.9;
	    this._name.size.y = this._name.size.x * this._name.ratioY;
	}
    }
    
    Signal!(Button) clicked () {
	return this._clicked;
    }

    Signal!(Button) rightClicked () {
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

