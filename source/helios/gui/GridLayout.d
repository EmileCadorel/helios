module helios.gui.GridLayout;
import helios.gui._;
import std.container, gfm.math;


final class GridLayout : Layout {

    private float [][] _desc;
    private float [] _height;
    
    private int _currentCol = 0;
    private int _currentRow = 0;

    private int _paddingWidth;
    private int _paddingHeight;
    
    this (vec2f position, vec2f size, int nbRows) {
	this._position = position;
	this._size = size;
	this._desc = new float [][nbRows];
	this._height = new float [nbRows];

	foreach (it ; 0 .. nbRows) {
	    this._height [it] = 1.0 / cast (float) nbRows;
	    this._desc [it] = [1.0];
	}
    }

    void describe (int row, float [] weight) {
	this._desc [row] = weight;
    }

    void setHeights (float [] percent) {
	if (percent.length != this._height.length)
	    assert (false);
	
	this._height = percent;
    }

    void setPaddings (int width, int height) {
	this._paddingWidth = width;
	this._paddingHeight = height;
    }
    
    override void addWidget (Widget widget) {
	if (this._currentRow >= this._height.length)
	    assert (false, "Plus de place");
	
	auto pos = vec2f (0, 0);
	auto size = vec2f (this._desc [this._currentRow][this._currentCol] * this._size.x,
			   this._height [this._currentRow] * this._size.y
	);
	
	foreach (it ; 0 .. this._currentRow) {
	    pos.y += this._height [it] * this._size.y;
	}

	foreach (it ; 0 .. this._currentCol) {
	    pos.x += this._desc [this._currentRow][it] * this._size.x;
	}
	
	this._currentCol ++;
	if (this._currentCol >= this._desc [this._currentRow].length) {
	    this._currentCol = 0;
	    this._currentRow ++;
	}

	widget.innerPosition = pos + vec2f (this._paddingWidth / 2., this._paddingHeight / 2.);
	widget.size = size - vec2f (this._paddingWidth, this._paddingHeight);
	super.addWidget (widget);	
    }


    override void onDraw () {
	super.drawQuad (this.position, this.size, vec4f (0.3, 0.2, 0.2, 0.2));
	super.onDraw ();
    }


}
  
