module helios.draw.Text;
import gfm.sdl2, helios.system._;
import std.stdio;
import helios.model._;
import gfm.math, gfm.opengl, gfm.assimp;
import helios.utils.Singleton;

private auto vert = q{
#version 450 core

    in vec3 position;
    in vec2 texcoord;

    uniform vec2 screenSize;
    uniform vec2 screenPos;
    uniform vec2 size;

    out vec2 textureCoord;

    void main() {
	vec2 pos = vec2(0.0, 0.0);	
	pos.x = ((position.x * size.x) + screenPos.x) - (screenSize.x / 2);
	pos.y =  (screenSize.y / 2) - ((position.y * size.y) + screenPos.y);

	pos /= (screenSize / 2);

	gl_Position = vec4(pos, 0.0, 1.0);
	textureCoord = texcoord;
    }

};

private auto frag = q{
#version 450 core

    in vec2 textureCoord;

    uniform sampler2D diffuse;
    uniform vec4 in_color;
    
    out vec4 out_color;

    void main() {
	out_color = texture(diffuse, textureCoord);
	out_color.xyz = in_color.xyz;
    }
};

private class Font {

    private SDLFont [string] _fonts;

    SDLFont getFast (string name) {
	auto it = (name ~ "fast") in this._fonts;
	if (it is null) {
	    auto font = new SDLFont (Application.currentContext.sdlTtf, name, 50);
	    this._fonts[name ~ "fast"] = font;
	    return font;
	} else return *it;
    }
    
    SDLFont getHighQuality (string name) {
	auto it = (name ~ "high") in this._fonts;
	if (it is null) {
	    auto font = new SDLFont (Application.currentContext.sdlTtf, name, 255);
	    this._fonts[name ~ "high"] = font;
	    return font;
	} else return *it;
    }
    
    mixin Singleton;
}


enum TextQuality {
    HIGH,
    FAST
}

class Text {

    private static Mesh __mesh__;
    private static Shader __shader__;
    
    private Texture _texture;
    private vec2f _position;
    private vec2f _surfSize;
    private vec4f _color = vec4f (1, 1, 1, 1);
    private string _text;
    private string _fontName;
    private TextQuality _quality;
    private float _ratioX, _ratioY;
    
    this (TextQuality quality) {
	this._fontName = Application.currentContext.systemFont;
	this._quality = quality;
    }
    
    this (string fontName) {
	this._fontName = fontName;
    }

    void text (string other) {
	this._text = other;
	computeText ();
    }

    void color (vec4f color) {
	this._color = color;
    }

    string text () {
	return this._text;
    }
    
    ref vec2f position () {
	return this._position;
    }

    ref vec2f size () {
	return this._surfSize;
    }

    float ratioX () {
	return this._ratioX;
    }

    float ratioY () {
	return this._ratioY;
    }

    private void computeText () {
	if (this._texture) {
	    this._texture.release ();
	    this._texture = null;
	}
	SDLFont font;
	if (this._quality == TextQuality.HIGH)
	    font = Font.instance.getHighQuality (this._fontName);
	else font = Font.instance.getFast (this._fontName);
	
	if (this._text != "") {
	    auto surface = font.renderTextSolid (this._text, SDL_Color (255, 255, 255));
	    surface = surface.convert (SDL_AllocFormat (SDL_PIXELFORMAT_RGBA8888));
	    this._surfSize = vec2f (surface.width, surface.height);
	    this._ratioX = this._surfSize.x / this._surfSize.y;
	    this._ratioY = this._surfSize.y / this._surfSize.x;
	    
	    this._texture = new Texture ("diffuse", surface, Application.currentContext);	    
	} 	
	if (__shader__ is null) {
	    __shader__ = new Shader (Application.currentContext.openglContext,
				     vert, frag, true);
	    __mesh__ = Mesh.createQuad (Application.currentContext,
					new VertexSpecification!Vertex (__shader__.program),
					vec2f (1, 1));
	}
       
    }
    
    void draw () {
	if (this._texture !is null) {
	    __shader__.uniform ("screenSize").set (vec2f (Application.currentContext.window.width,
							  Application.currentContext.window.height));
	    
	    __shader__.uniform ("screenPos").set (this._position);
	    __shader__.uniform ("size").set (this._surfSize);
	    __shader__.uniform ("in_color").set (this._color);
	    
	    this._texture.use (__shader__);
	    __shader__.use ();	
	    __mesh__.draw ();
	    __shader__.unuse ();
	    this._texture.unuse ();
	}
    }    
    
}
