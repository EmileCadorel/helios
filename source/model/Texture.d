module model.Texture;
import system.Application;
import gfm.opengl, std.typecons, system.Shader;
import gfm.sdl2, std.conv;

class Texture {
    

    private GLTexture2D _texture;
    private Tuple!(int, "w", int, "h") _texSize;
    private static int _lastUnit_ = 0;
    private int _texUnit;
    private string _type;

    this (string type, string name, string path, Application context) {
	this._type = type;
	this.setTexture (name, path, context);
	this._texUnit = _lastUnit_;
	_lastUnit_++;
    }
    
    this (string type) {
	this._type = type;
    }    
    
    void setTexture (string name, string path, Application context) {
	SDL2Surface image;
	loadImage (path, image,  context);
	this._texture = new GLTexture2D (context.openglContext);
	this._texture.setMinFilter(GL_LINEAR_MIPMAP_LINEAR);
	this._texture.setMagFilter(GL_LINEAR);
	this._texture.setWrapS(GL_REPEAT);
	this._texture.setWrapT(GL_REPEAT);
	this._texture.setImage (0, GL_RGB, image.width, image.height, 0, GL_RGB,  GL_UNSIGNED_BYTE, image.pixels);
	this._texture.generateMipmap ();
    }

    void use (Shader shader) {
	this._texture.use (this._texUnit);
	shader.uniform (this._type).set (this._texUnit);
    }

    void unuse () {	
    }
    
    private void loadImage (string path, ref SDL2Surface image, Application context) {
	/*	auto file = SDL_RWFromFile (path.ptr, "r".ptr);
	if (file is null) assert (false, "Fichier de texture " ~ path ~ " n'existe pas");
	image = IMG_Load_RW (file, 1);
	if (image is null) assert (false, to!(char[])(SDL_GetError ()));
	*/
	SDLImage loader = new SDLImage (context.sdlContext, IMG_INIT_PNG);
	image = loader.load (path);
	
    }
    
    
}
