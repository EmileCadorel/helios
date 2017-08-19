module helios.gui.FloatingBox;
import helios.draw._;
import helios.gui._;
import helios.system._;
import helios.model._;
import std.stdio, gfm.math, std.datetime;
import std.json, std.conv;
import std.algorithm;

class FloatingBox : LoadWidget!FloatingBox {

    private bool _closed;
    private Text _name;

    private SysTime _lastClicked;
    private bool _needClose = false;

    private vec2f _lastPos;
    private static immutable int ROD_SIZE = 20;

    private int _textSize;
    private float _relativeTextSize;
    private vec4f _textColor;

    private this (JSONValue value) {
	this._isFloating = true;
	string name;
	if (auto x = "position" in value) this.innerPosition = parsePos (*x);
	else this.innerPosition = vec2f (0, 0);
	if (auto h = "size" in value) this._size = parseSize (*h);
	if (auto t = "text" in value) name = t.str;
	if (auto i = "id" in value) super.setId (i.str);
	if (auto r = "relative" in value) super.setRelative (r.integer.to!bool);
	if (auto col = "textColor" in value) this._textColor = parseColor (*col);
	this._relativeTextSize = 0.9;
	this._name = new Text (TextQuality.FAST);
	this._name.color = this._textColor;
	this._name.text = name;

	auto ratio = this._name.size.x / this._name.size.y;
	this._name.size.y = this._relativeTextSize * ROD_SIZE;
	this._name.size.x = this._name.size.y * ratio;
	
    }
    
    this (vec2f pos, vec2f size, string name) {
	this._isFloating = true;
	this.position = pos;
	this.size = size;
	this._name = new Text (TextQuality.FAST);
	this._name.text = name;
	this._relativeTextSize = 0.9;
	
	auto ratio = this._name.size.x / this._name.size.y;
	this._name.size.y = this._relativeTextSize * ROD_SIZE;
	this._name.size.x = this._name.size.y * ratio;
    }

    override void onClick (MouseEvent event) {
	if (event.y <= position.y + 30) {
	    this._lastClicked = Clock.currTime;
	    this._needClose = true;
	    this._lastPos = vec2f (event.x, event.y) - this._position;
	    Application.currentContext.input.motion.connect (&this.move);	    
	}
    }

    override void onClickEnd (MouseEvent event) {
	if (Clock.currTime - this._lastClicked <= 1.seconds && this._needClose) {
	    this._closed = !this._closed;	    
	    if (!this._closed && this._position.y + this._size.y > this.parent.size.y) {
		this._position.y = this.parent.size.y - this._size.y;
	    }
	}
	Application.currentContext.input.motion.disconnect (&this.move);
    }

    override void onFocusLose () {
	Application.currentContext.input.motion.disconnect (&this.move);
    }
    
    final void move (int x, int y, MouseInfo info) {
	this._needClose = false;
	this._position = vec2f (x, y) - this._lastPos;
	if (this.innerPosition.x < 0) this.innerPosition.x = 0;
	else if (this.innerPosition.x + this._size.x > this.parent.size.x) {
	    this.innerPosition.x = this.parent.size.x - this._size.x;
	}

	if (this.innerPosition.y < 0) this.innerPosition.y = 0;
	else if (this.innerPosition.y + this._size.y > this.parent.size.y) {
	    if (!this._closed) {
		this.innerPosition.y = this.parent.size.y - this._size.y;
	    } else if (this.innerPosition.y + ROD_SIZE > this.parent.size.y) {
		this.innerPosition.y = this.parent.size.y - ROD_SIZE;
	    }
	}	
       
    }
    
    override void onClickRight (MouseEvent event) {
    }

    override void onHover (MouseEvent event) {
	
    }

    override void onDraw () {
	super.drawQuad (this.position, vec2f (this.size.x, ROD_SIZE), vec4f (93. / 255., 89. / 255, 166. / 255., 1));
	super.drawTextCenter (this.position, vec2f (this.size.x, ROD_SIZE), this._name);
	if (!this._closed) {
	    super.drawQuad (this.position + vec2f (0, ROD_SIZE), vec2f (this.size.x, this.size.y - ROD_SIZE), vec4f (1, 1, 219. / 255., 1));
	    super.drawTriangle (this.position + vec2f (ROD_SIZE / 2., ROD_SIZE / 4.), ROD_SIZE / 2, vec4f (1, 1, 1, 1));
	} else {
	    super.drawTriangle (this.position + vec2f (ROD_SIZE / 2., ROD_SIZE / 4.), ROD_SIZE / 2, vec4f (1, 1, 1, 1), 180);
	}
    }

    static Widget load (JSONValue value) {
	return new FloatingBox (value);
    }
    
}
