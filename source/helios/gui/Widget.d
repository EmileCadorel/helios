module helios.gui.Widget;
public import helios.system._;
public import helios.model._;
public import helios.draw._;
public import helios.gui._;
public import helios.gui.MainLayout;
import gfm.math, gfm.opengl, gfm.assimp;
import std.math, std.container;
import std.json;

private auto vertColor = q{
#version 450 core

    in vec3 position;

    uniform vec2 screenSize;
    uniform vec2 screenPos;
    uniform vec2 size;
    uniform mat2 rotation;
    
    void main() {
	vec2 pos = rotation * position.xy;
	vec2 mSize = rotation * size.xy;
	
	pos.x = ((pos.x * mSize.x) + screenPos.x) - (screenSize.x / 2);
	pos.y =  (screenSize.y / 2) - ((pos.y * mSize.y) + screenPos.y);

	pos /= (screenSize / 2);
	
	gl_Position = vec4 (pos, 0.0, 1.0);
    }

};

private auto fragColor = q{
#version 450 core

    uniform vec4 color;

    out vec4 out_color;

    void main() {
	out_color = color; 
    }
};


private template WidgetInsert (T : Widget) {
    static this () {
	static if (is (typeof (&T.load) : Widget function (JSONValue))) {
	    import std.string;
	    auto name = T.classinfo.name;
	    auto begin = name.lastIndexOf (".");
	    auto end = name.lastIndexOf ("!");
	    if (begin != -1) name = name [begin + 1 .. $];
	    if (end != -1) name = name [0 .. end];
	    GUI.storeWidget (name, &T.load);
	}
    }
}


vec4f parseColor (JSONValue value) {
    vec4f colr = vec4f (1, 1, 1, 1);
    if (auto r = "r" in value) colr.x = r.floating;
    if (auto r = "g" in value) colr.y = r.floating;
    if (auto r = "b" in value) colr.z = r.floating;
    if (auto r = "a" in value) colr.w = r.floating;
    return colr;
}

vec2f parsePos (JSONValue value) {
    vec2f pos = vec2f (0, 0);
    if (auto x = "x" in value) pos.x = x.floating;
    if (auto y = "y" in value) pos.y = y.floating;
    return pos;
}

vec2f parseSize (JSONValue value) {
    vec2f size = vec2f (0, 0);
    if (auto w = "w" in value) size.x = w.floating;
    if (auto w = "h" in value) size.y = w.floating;
    return size;
}

class Widget  {

    private static Shader __color__;

    private static Mesh __quad__, __triangle__;
    
    protected vec2f _position;

    protected vec2f _relativePosition;
    
    protected vec2f _size;

    protected vec2f _relativeSize;

    protected bool _isRelative;
    
    private bool _clicked = false;

    private static Array!Widget __widgets__;

    private static Array!Widget __widgets3D__;

    private static bool __init__ = false;

    protected static Widget __focused__, __hovered__;

    private Widget _parent;

    private static MainLayout __GUI__;

    private string _id;

    protected bool _isFloating;

    this () {
	if (this.is3D)
	    __widgets3D__.insertBack (this);
	else
	    __widgets__.insertBack (this);
	
	if (!__init__) {
	    __init__ = true;
	    __GUI__ = new MainLayout ();
	    alias context = Application.currentContext;
	    context.input.mouse (MouseInfo (SDL_BUTTON_LEFT, SDL_MOUSEBUTTONDOWN)).connect (&clickSlot);
	    context.input.mouse (MouseInfo (SDL_BUTTON_RIGHT, SDL_MOUSEBUTTONDOWN)).connect (&clickRightSlot);
	    context.input.mouse (MouseInfo (SDL_BUTTON_LEFT, SDL_MOUSEBUTTONUP)).connect (&clickStopSlot);
	    context.input.motion ().connect (&motionSlot);
	}
    }

    static void clickRightSlot (int x, int y, MouseInfo info) {
	__GUI__.clickRightSlot (x, y, info);
    }   

    static void clickSlot (int x, int y, MouseInfo info) {
	if (__focused__ !is null) {
	    if (__focused__.position.x <= x && __focused__.position.x + __focused__._size.x >= x) {
		if (__focused__.position.y <= y && __focused__.position.y + __focused__._size.y >= y) {
		    __focused__._clicked = true;
		    __focused__.onClick (MouseEvent (x, y, info));
		    return;
		}
	    }
	}

	__GUI__.clickSlot (x, y, info);	
    }
    
    static void clickStopSlot (int x, int y, MouseInfo info) {
	if (__focused__ !is null) {
	    if (__focused__._clicked) {
		__focused__.onClickEnd (MouseEvent (x, y, info));
	    }
	    __focused__._clicked = false;
	    if (__focused__.is3D) Widget.setFocus (null);
	}
    }

    static void motionSlot (int x, int y, MouseInfo info) {
	if (__hovered__ !is null) {
	    if (__hovered__.position.x > x || __hovered__.position.x + __hovered__._size.x < x ||
		__hovered__._position.y > y || __hovered__._position.y + __hovered__._size.y < y) {
	    
		__hovered__.onHoverEnd (MouseEvent (x, y, info));
		__hovered__ = null;
	    }
	}
	
	__GUI__.motionSlot (x, y, info);	
    }

    static void drawGUI () {
	__GUI__.onDraw ();
	if (__focused__ && !__focused__.is3D)  __focused__.onDraw ();
    }

    static void draw3D () {
	__GUI__.onDraw3D ();
	if (__focused__ && __focused__.is3D) __focused__.onDraw3D ();
    }

    static MainLayout mainLayout () {
	return __GUI__;
    }
    
    final static void setFocus (Widget widget) {
	if (__focused__) __focused__.onFocusLose ();
	__focused__ = widget;
	if (__focused__) __focused__.onFocusGain ();
    }

    final static void setHover (Widget widget, MouseEvent event) {
	if (__hovered__) __hovered__.onHoverEnd (event);
	__hovered__ = widget;
	if (__hovered__) __hovered__.onHover (event);
    }

    final bool isFocused (Widget widget) {
	return __focused__ is widget;
    }
    
    final void draw () {
	if (this.is3D) this.onDraw3D ();
	else this.onDraw ();
    }

           
    final bool isClicked () {
	return this._clicked;
    }

    final void isClicked (bool value) {
	this._clicked = value;
    }

    final protected void setId (string id) {
	this._id = id;
    }
    
    final string id () {
	return this._id;
    }

    
    
    void onClick (MouseEvent) {}

    void onClickEnd (MouseEvent) {}
    
    void onClickRight (MouseEvent) {}

    void onHover (MouseEvent) {}

    void onHoverEnd (MouseEvent) {}

    void onFocusGain () {}
    
    void onFocusLose () {}

    bool is3D () { return false; }

    void onResize () {}

    Widget getFromId (string name) {
	if (name == this.id) return this;
	return null;
    }
    
    final void parent (Widget parent) {
	this._parent = parent;
    }

    final Widget parent () {
	return this._parent;
    }
    
    abstract void onDraw ();

    void onDraw3D () {}
    
    final void release () {
	import std.algorithm;
	auto it = __widgets__[].find!("a is b") (this);
	if (!it.empty) {
	    __widgets__.linearRemove (it);
	}
    }

    final protected void setRelative (bool relative) {
	this._isRelative = relative;
	if (this._isRelative) {
	    this._relativeSize = this._size;
	    this._relativePosition = this._position;
	}
    }

    final bool isRelative () {
	return this._isRelative;
    }

    final bool isFloating () {
	return this._isFloating;
    }
    
    private static void initColor () {
	__color__ = new Shader (Application.currentContext.openglContext,
				vertColor,
				fragColor,
				true);				    
    }

    private static Matrix!(float, 2, 2) rotation (float angle) {
	Matrix!(float, 2, 2) mat;
	mat.rows [0][0] = cos (angle);
	mat.rows [0][1] = -sin (angle);

	mat.rows [1][0] = sin (angle);
	mat.rows [1][1] = cos (angle);
	return mat;
    }
    
    protected static void drawQuad (vec2f pos, vec2f size, vec4f color, float angle = 0.0f) {
	if (__color__ is null) initColor ();
	
	if (__quad__ is null) {
	    __quad__ = Mesh.createQuad (Application.currentContext,
					new VertexSpecification!Vertex (__color__.program),
					vec2f (1, 1));
	    
	}
	
	auto mat = rotation (angle * PI / 180.0);
	
	__color__.uniform ("screenSize").set (vec2f (Application.currentContext.window.width,
					       Application.currentContext.window.height));
	__color__.uniform ("screenPos").set (pos);
	__color__.uniform ("size").set (size);
	__color__.uniform ("color").set (color);
	__color__.uniform ("rotation").set (mat);
	
	__color__.use ();
	__quad__.draw ();
	__color__.unuse ();
	
    }

    protected static void drawTriangle (vec2f pos, float size, vec4f color, float angle = 0.0f) {
	if (__color__ is null) initColor ();
	if (!__triangle__) {
	    __triangle__ = Mesh.createTriangle (Application.currentContext,
						new VertexSpecification!Vertex (__color__.program),
						1.0f
	    );
	}
	auto mat = rotation (angle * PI / 180.0);
	
	__color__.uniform ("screenSize").set (vec2f (Application.currentContext.window.width, 
						     Application.currentContext.window.height));
	__color__.uniform ("screenPos").set (pos);
	__color__.uniform ("size").set (vec2f (size, size));
	__color__.uniform ("color").set (color);
	__color__.uniform ("rotation").set (mat);
	
	__color__.use ();
	__triangle__.draw ();
	__color__.unuse ();
	
    }
    

    protected static void drawTextCenter (vec2f pos, vec2f size, Text text) {
	text.position.x = pos.x + (size.x / 2) - (text.size.x / 2);
	text.position.y = pos.y + (size.y / 2) - (text.size.y / 2);
	text.draw ();
    }

    void position (vec2f position) {
	this._position = position;
    }
    
    vec2f position () {
	if (this._parent !is null) {
	    auto pos = this._position + this._parent.position;
	    return pos;
	} else {
	    return this._position;
	}
    }

    ref vec2f innerPosition () {
	return this._position;
    }
    
    const (vec2f) size () {
	return this._size;
    }

    void size (vec2f size) {
	this._size = size;
    }

    vec2f relativeSize () {
	return this._relativeSize;
    }

    vec2f relativePosition () {
	return this._relativePosition;
    }
    
}


class LoadWidget (T) : Widget {
    mixin WidgetInsert!T;
}
