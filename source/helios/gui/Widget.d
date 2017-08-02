module helios.gui.Widget;
public import helios.system._;
public import helios.model._;
import gfm.math, gfm.opengl, gfm.assimp;

private auto vertColor = q{
#version 450 core

    in vec3 position;

    uniform vec2 screenSize;
    uniform vec2 screenPos;
    uniform vec2 size;

    void main() {
	vec2 pos = vec2(0.0, 0.0);	
	pos.x = ((position.x * size.x) + screenPos.x) - (screenSize.x / 2);
	pos.y =  (screenSize.y / 2) - ((position.y * size.y) + screenPos.y);

	pos /= (screenSize / 2);

	gl_Position = vec4(pos, 0.0, 1.0);
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


class Widget {

    private static Shader __color__;

    private static Mesh __quad__;
    
    protected vec2f _position;

    protected vec2f _size;
    
    this () {
	alias context = Application.currentContext;
	context.input.mouse (MouseInfo (SDL_BUTTON_LEFT, SDL_MOUSEBUTTONDOWN)).connect (&this.clickSlot);
	context.input.mouse (MouseInfo (SDL_BUTTON_RIGHT, SDL_MOUSEBUTTONDOWN)).connect (&this.clickRightSlot);
	context.input.motion ().connect (&this.motionSlot);
    }

    final void clickRightSlot (int x, int y, MouseInfo info) {
	if (this._position.x <= x && this._position.x + this._size.x >= x) {
	    if (this._position.y <= y && this._position.y + this._size.y >= y) {
		this.onClickRight (MouseEvent (x, y, info));
	    }
	}
    }
    
    final void clickSlot (int x, int y, MouseInfo info) {
	if (this._position.x <= x && this._position.x + this._size.x >= x) {
	    if (this._position.y <= y && this._position.y + this._size.y >= y) {
		this.onClick (MouseEvent (x, y, info));
	    }
	}
    }

    final void motionSlot (int x, int y, MouseInfo info) {
	if (this._position.x <= x && this._position.x + this._size.x >= x) {
	    if (this._position.y <= y && this._position.y + this._size.y >= y) {
		this.onHover (MouseEvent (x, y, info));
	    }
	}
    }

    final void draw () {
	this.onDraw ();
    }
    
    abstract void onClick (MouseEvent);
    
    abstract void onClickRight (MouseEvent);

    abstract void onHover (MouseEvent);
    
    abstract void onDraw ();

    protected static void drawQuad (vec2f pos, vec2f size, vec4f color) {
	if (__color__ is null) {
	    __color__ = new Shader (Application.currentContext.openglContext,
				    vertColor,
				    fragColor,
				    true);				    
	}
	
	if (__quad__ is null) {
	    __quad__ = Mesh.createQuad (Application.currentContext,
					new VertexSpecification!Vertex (__color__.program),
					vec2f (1, 1));
	    
	}

	__color__.uniform ("screenSize").set (vec2f (Application.currentContext.window.width,
					       Application.currentContext.window.height));
	__color__.uniform ("screenPos").set (pos);
	__color__.uniform ("size").set (size);
	__color__.uniform ("color").set (color);
	__color__.use ();
	__quad__.draw ();
	__color__.unuse ();
	
    }

    
    ref vec2f position () {
	return this._position;
    }

    ref vec2f size () {
	return this._size;
    }
    
}
