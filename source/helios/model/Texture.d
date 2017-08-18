module helios.model.Texture;
import helios.system._;
import gfm.opengl, std.typecons;
import gfm.sdl2, std.conv;
import helios.utils.Singleton;

class Texture {
    
    private GLTexture2D _texture;
    private Tuple!(int, "w", int, "h") _texSize;
    private static int _lastUnit_ = 0;
    private static int _inUsage_ = 0;
    private int _texUnit;
    private string _type;

    this (string type, SDL2Surface surface, Application context) {
	this._type = type;
	this.setTexture (surface, context);
    }
    
    this (string type, string name, string path, Application context) {
	this._type = type;
	this.setTexture (name, path, context);
    }
    
    this (string type) {
	this._type = type;
    }    
    
    void setTexture (string name, string path, Application context) {
	SDL2Surface image;
	GLint color; GLenum format;
	loadImage (path, image,  context);
	getFormat (color, format, image);
	this._texture = new GLTexture2D (context.openglContext);
	this._texture.setMinFilter(GL_LINEAR_MIPMAP_LINEAR);
	this._texture.setMagFilter(GL_LINEAR);
	this._texture.setWrapS(GL_REPEAT);
	this._texture.setWrapT(GL_REPEAT);
	this._texture.setImage (0, color, image.width, image.height, 0, format,  GL_UNSIGNED_BYTE, image.pixels);
	this._texture.generateMipmap ();
    }

    void setTexture (SDL2Surface image, Application context) {
	GLint color; GLenum format;
	getFormat (color, format, image);
	this._texture = new GLTexture2D (context.openglContext);       
	this._texture.setMinFilter(GL_LINEAR_MIPMAP_LINEAR);
	this._texture.setMagFilter(GL_LINEAR);
	this._texture.setWrapS(GL_REPEAT);
	this._texture.setWrapT(GL_REPEAT);
	this._texture.setImage (0, GL_RGBA, image.width, image.height, 0, GL_RGBA,  GL_UNSIGNED_BYTE, image.pixels);

	this._texture.generateMipmap ();
	
    }

    void getFormat (ref GLint color, ref GLenum format, SDL2Surface surf) {
	color = surf.pixelFormat.BytesPerPixel;
	if (color == 4)
	    {
		if (surf.pixelFormat.Rmask == 0x000000ff) {
		    format = GL_RGBA;
		} else {
		    format = GL_BGRA;
		}
	    }
	else if (color == 3)
	    {
		if (surf.pixelFormat.Rmask == 0x000000ff) {
		    format = GL_RGB;
		    color = GL_RGB;
		} else {
		    format = GL_BGR;
		    color = GL_BGR;
		}
	    }
    }
    
    void use (Shader shader) {
	this._texUnit = _lastUnit_;
	_lastUnit_ ++;	
	_inUsage_ ++;
	this._texture.use (this._texUnit);
	shader.uniform (this._type).set (this._texUnit);
    }

    void unuse () {
	_inUsage_ --;
	if (_inUsage_ == 0) 
	    _lastUnit_ = 0;
	
	this._texUnit = -1;
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

    void release () {
	delete this._texture;
    }        
}
