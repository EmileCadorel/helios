module helios.draw.Text;
import gfm.sdl2, helios.system._;
import std.stdio;
import helios.model._;
import gfm.math, gfm.opengl, gfm.assimp;

private auto vert = q{
#version 450 core

    in vec3 position;
    in vec2 texcoord;

    uniform vec2 size;
    uniform vec2 screenPos;

    out vec2 textureCoord;

    void main() {
	vec2 pos = vec2(0.0, 0.0);	
	pos.x = (position.x + screenPos.x) - (size.x / 2);
	pos.y =  (size.y / 2) - (position.y + screenPos.y);

	pos /= (size / 2);

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
    
    private Texture _texture;
    private Mesh _mesh;
    static Shader _shader_;
    private Application _context;
    private vec2f _position;
    private string _text;
    private string _fontName;
    private int _size;
    
    this (Application context, string fontName, int size) {
	this._context = context;
	this._fontName = fontName;
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
	auto font = new SDLFont (this._context.sdlTtf, this._fontName, 15);
	auto surface = font.renderTextSolid (this._text, SDL_Color (255, 255, 255));
	surface = surface.convert (SDL_AllocFormat (SDL_PIXELFORMAT_RGBA8888));
	if (_shader_ is null) {
	    _shader_ = new Shader (this._context.openglContext,
				   vert, frag, true);
	}
	
	this._texture = new Texture ("diffuse", surface, this._context);
	createMesh (surface.width, surface.height);
    }
    
    private void createMesh (int width, int height) {
	writeln (width, height);
	auto model = [
	    Vertex (vec3f (0, 0, 0), vec3f (), vec2f (0, 0)),
	    Vertex (vec3f (0, height, 0), vec3f (), vec2f (0, 1)),	    
	    Vertex (vec3f (width, 0, 0), vec3f (), vec2f (1, 0)),
	    Vertex (vec3f (width, 0, 0), vec3f (), vec2f (1, 0)),
	    Vertex (vec3f (width, height, 0), vec3f (), vec2f (1, 1)),
	    Vertex (vec3f (0, height, 0), vec3f (), vec2f (0, 1))
	];

	this._mesh = new Mesh (model, this._context, new VertexSpecification!Vertex (_shader_.program));
	this._mesh.tex = this._texture;
    }
    
    void draw () {
	_shader_.uniform ("size").set (vec2f (this._context.window.width,
					      this._context.window.height));

	_shader_.uniform ("screenPos").set (this._position);

	this._texture.use (_shader_);
	_shader_.use ();	
	this._mesh.draw ();
	_shader_.unuse ();	
    }    
    
}
