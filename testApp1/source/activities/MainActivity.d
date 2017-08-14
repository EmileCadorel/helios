module activities.MainActivity;
import helios._, gfm.opengl;
import gfm.math, std.math;
import std.container, std.conv, std.stdio;

struct Light {

    vec3f pos = vec3f (4., 1., 4);

    void rotate (vec3f angle) {
	auto aux = mat4f.rotation (angle.x, vec3f (1, 0, 0));
	aux *= mat4f.rotation (angle.y, vec3f (0., 1., 0.));
	aux *= mat4f.rotation (angle.z, vec3f (0., 0., 1.));
	this.pos = (aux * vec4f (this.pos, 1.0)).xyz;
    }    

}

class MainActivity : Activity {

    Shader _shader;
    VertexSpecification!Vertex _vertBinder;
    vec3f _angles, _lightDir;
    vec3f _ambiant;
    Application _context;
    bool _zoom, _unzoom;
    Light _light;
    TPSGuide _guide;
    D3View _view;
    Widget _box;
    
    Text _text;
    
    override void onCreate (Application context) {
	this._context = context;
	this._shader = new Shader (context.openglContext,
				   "shaders/model.vs",
				   "shaders/model.fs");

	this._vertBinder = new VertexSpecification!Vertex (this._shader.program);

	this._view = new D3View (vec2f (200, 200), vec2f (400, 300), &this.draw3D);

	this._view.scenes.insertBack (new Scene ("models/rayman/Rayman3.obj", context, this._vertBinder));	
	this._view.camera = new Camera ();
	this._view.camera.perspective (70. * PI / 180, 400./300., 0.1, 99999.);
	
	this._view.camera.guide = this._guide = new TPSGuide (context);

	this._view.camera.lookAt (vec3f (0, 4, 7),
			     vec3f (0, 1.8, 0),
			     vec3f (0.0, 1, 0.));
	
	this._angles = vec3f (0.0, 1. / 60., 0.);
	this._lightDir = vec3f (-0.8, -2.0, -1.);
	this._ambiant = vec3f (0.3, 0.3, 0.3);

	this._box = new FloatingBox (vec2f (10, 10), vec2f (200, 150), "OK");
	
	context.input.keyboard (KeyInfo (SDLK_ESCAPE, -1)).connect (&this.end);
	context.input.keyboard (KeyInfo (SDLK_z, -1)).connect (&this.zoom);
	context.input.keyboard (KeyInfo (SDLK_u, -1)).connect (&this.unzoom);
	context.input.keyboard (KeyInfo (SDLK_p, SDL_KEYDOWN)).connect (&this.open);
    }

    void open (KeyInfo) {
	auto intent = new Intent (this._context);
	intent ["msg"] = "Salut";
	intent.launch ("pause");
    }
    
    void end (KeyInfo info) {
	if (info.type == SDL_KEYUP) 
	    this._context.stop ();
	else
	    writeln ("Echap appuyé");
    }

    void zoom (KeyInfo info) {
	this._zoom = info.type == SDL_KEYDOWN;
    }

    void unzoom (KeyInfo info) {
	this._unzoom = info.type == SDL_KEYDOWN;
    }

    override void onUpdate () {
	import std.conv;
	static float lastFps;
	
	if (this._zoom) this._guide.zoom ();	
	else if (this._unzoom) this._guide.unzoom ();
	this._light.rotate (this._angles);
	if (this._context.getFps != lastFps) {
	    //this._text.text = "Fps : " ~ this._context.getFps ().to!string;
	    lastFps = this._context.getFps;
	}
    }
    
    void draw3D (Camera cam, Array!Scene scenes) {	
	this._shader.uniform ("ambiant").set (this._ambiant);
	this._shader.uniform ("lightPos").set (this._light.pos);
	this._shader.uniform ("viewMatrix").set (cam.getV ());
	this._shader.uniform ("projectionMatrix").set (cam.getP ());
	this._shader.uniform ("eyePos").set (cam.eye);

	foreach (it ; scenes) 
	    it.draw (this._shader);
    }
        
}
