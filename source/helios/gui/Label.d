module helios.gui.Label;
import helios._;
import gfm.math;

class Label : LoadWidget!Label {

    private Text _text;

    private vec4f _backGround = vec4f (0.5, 0.5, 0.5, 1);
    
    this (string text, int textSize = 15) {
	this._text = new Text (textSize);
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

    override void onDraw () {
	super.drawQuad (this.position, this.size, this._backGround);
	super.drawTextCenter (this.position, this.size, this._text);
    }    

}
