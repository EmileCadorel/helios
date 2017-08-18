module helios.gui.GridLayout;
import helios.gui._;
import std.container, gfm.math;
import std.json, std.conv;


final class GridLayout : Layout!GridLayout {

    private float [][] _desc;
    private float [] _height;
    private Widget [][] _content;
    
    private int _currentCol = 0;
    private int _currentRow = 0;

    private int _paddingWidth;
    private int _paddingHeight;

    private this (JSONValue value) {
	if (auto x = "pos" in value) this._position = parsePos (*x);
	if (auto h = "size" in value) this._size = parseSize (*h);
	if (auto id = "id" in value) super.setId (id.str);
	if (auto relative = "relative" in value) super.setRelative (relative.integer.to!bool);
	if (auto desc = "desc" in value) {
	    auto values = desc.array;
	    this._height = new float [values.length];
	    this._desc = new float [][values.length];
	    this._content = new Widget [][values.length];
	    foreach (line ; 0 .. values.length) {
		if (auto h = "height" in values [line]) this._height [line] = h.floating;
		if (auto r = "rows" in values [line]) {
		    auto rows = r.array;
		    this._desc [line] = new float [rows.length];
		    this._content [line] = new Widget [rows.length];
		    foreach (it ; 0 .. rows.length)
			this._desc [line][it] = rows[it].floating;
		} else {
		    this._desc [line] = [1.0];
		    this._content [line] = new Widget [1];
		}
	    }
	}
	
	if (auto padding = "padding" in value) {
	    auto padd = parseSize (*padding);
	    this._paddingHeight = cast (int) padd.y;
	    this._paddingWidth = cast (int) padd.x;
	}

	if (auto child = "childs" in value) {
	    foreach (it ; child.array) {
		this.addWidget (GUI.load (it));
	    }
	}	
    }
    
    this (vec2f position, vec2f size, int nbRows) {
	this._position = position;
	this._size = size;
	this._desc = new float [][nbRows];
	this._height = new float [nbRows];
	this._content = new Widget [][nbRows];
	
	foreach (it ; 0 .. nbRows) {
	    this._height [it] = 1.0 / cast (float) nbRows;
	    this._desc [it] = [1.0];
	    this._content[it] = new Widget [1];
	}
    }

    void describe (int row, float [] weight) {
	this._desc [row] = weight;
	this._content [row] = new Widget [weight.length];
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

    override void onResize () {
	foreach (row ; 0 .. this._content.length) {
	    foreach (col ; 0 .. this._content[row].length) {
		auto widg = this._content [row][col];
		if (widg) {
		    auto pos = vec2f (0, 0);
		    foreach (it ; 0 .. row) pos.y += this._height [it] * this.size.y;
		    foreach (it ; 0 .. col) pos.x += this._desc [row][it] * this.size.x;
		    
		    widg.size = vec2f (this._desc[row][col], this._height [row]) * this.size - vec2f (this._paddingWidth, this._paddingHeight);
		    widg.position = pos + vec2f (this._paddingWidth / 2., this._paddingHeight / 2.);
		    widg.onResize ();
		}
		
	    }
	}
    }
    
    override void addWidget (Widget widget) {
	super.addWidget (widget);
	if (this._currentRow >= this._height.length)
	    assert (false, "Plus de place");
	
	auto pos = vec2f (0, 0);
	auto size = vec2f (this._desc [this._currentRow][this._currentCol] * this._size.x,
			   this._height [this._currentRow] * this._size.y
	);
	
	this._content [this._currentRow][this._currentCol] = widget;
	
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
    }


    override void onDraw () {
	// super.drawQuad (this.position, this.size, vec4f (0.3, 0.2, 0.2, 0.2));
	super.onDraw ();
    }

    static Widget load (JSONValue value) {
	return new GridLayout (value);
    }
        
}
  
