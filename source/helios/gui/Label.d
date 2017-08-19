module helios.gui.Label;
import helios._;
import gfm.math, std.json, std.conv;
import std.algorithm.comparison;

class Label : LoadWidget!Label {

    private Text _text;

    private vec4f _backGround = vec4f (0.5, 0.5, 0.5, 1);

    private vec4f _textColor;
    private int _textSize;
    private float _relativeTSize;
    
    
    private this (JSONValue value) {
	string name;
	if (auto x = "position" in value) this.innerPosition = parsePos (*x);
	else this.innerPosition = vec2f (0, 0);
	if (auto h = "size" in value) this._size = parseSize (*h);
	if (auto t = "text" in value) name = t.str;
	if (auto i = "id" in value) super.setId (i.str);
	if (auto r = "relative" in value) super.setRelative (r.integer.to!bool);
	if (auto col = "textColor" in value) this._textColor = parseColor (*col);
	if (auto rts = "relativeTSize" in value) this._relativeTSize = rts.floating;
	else this._relativeTSize = 0.5;
	
	this._text = new Text (TextQuality.FAST);
	this._text.size = this._relativeTSize * this.size;
	this._text.color = this._textColor;
	this._text.text = name;
	onResize ();
    }	
    
    this (string text, int textSize = 15) {
	this._text = new Text (TextQuality.FAST);
	this._text.color = vec4f (1, 1, 1, 1);
	this._text.text = text;	
    }

    ref vec4f backColor () {
	return this._backGround;
    }
    
    string text () {
	return this._text.text;
    }

    void text (string text) {
	this._text.text = text;
    }

    override void onResize () {
	this._text.size.y = this._relativeTSize * this.size.y;
	this._text.size.x = this._text.size.y * this._text.ratioX;
    }
    
    override void onDraw () {
	super.drawQuad (this.position, this.size, this._backGround);
	super.drawTextCenter (this.position, this.size, this._text);
    }    

    static Widget load (JSONValue value) {
	return new Label (value);
    }
    
}
