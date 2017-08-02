module helios.draw.Text;
import gfm.sdl2, helios.system._;
import std.stdio;
import helios.model._;
import gfm.math, gfm.opengl, gfm.assimp;

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

    out vec4 out_color;

    void main() {
	out_color = texture(diffuse, textureCoord);
    }
};

class Text {

    private static Mesh __mesh__;
    private static Shader __shader__;
    
    private Texture _texture;
    private vec2f _position;
    private vec2f _surfSize;
    private string _text;
    private string _fontName;
    private int _size;
    
    
    this (string fontName, int size) {
	this._fontName = fontName;
	this._size = size;
    }

    void text (string other) {
	this._text = other;
	computeText ();
    }

    string text () {
	return this._text;
    }
    
    ref vec2f position () {
	return this._position;
    }

    private void computeText () {
	auto font = new SDLFont (Application.currentContext.sdlTtf, this._fontName, this._size);
	auto surface = font.renderTextSolid (this._text, SDL_Color (255, 255, 255));
	surface = surface.convert (SDL_AllocFormat (SDL_PIXELFORMAT_RGBA8888));
	if (__shader__ is null) {
	    __shader__ = new Shader (Application.currentContext.openglContext,
				     vert, frag, true);
	    __mesh__ = Mesh.createQuad (Application.currentContext,
					new VertexSpecification!Vertex (__shader__.program),
					vec2f (1, 1));
	}
	
	this._surfSize = vec2f (surface.width, surface.height);
	this._texture = new Texture ("diffuse", surface, Application.currentContext);
    }
    
    
    void draw () {
	__shader__.uniform ("screenSize").set (vec2f (Application.currentContext.window.width,
						      Application.currentContext.window.height));

	__shader__.uniform ("screenPos").set (this._position);
	__shader__.uniform ("size").set (this._surfSize);
	
	this._texture.use (__shader__);
	__shader__.use ();	
	__mesh__.draw ();
	__shader__.unuse ();	
    }    
    
}
