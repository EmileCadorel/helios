module activities.MainActivity;
import system.Activity, system.Shader, gfm.opengl;
import system.Camera, system.Input;
import gfm.math, std.math;
import model.Vertex, model.Scene, std.stdio;
import std.container, std.conv, std.stdio;
import draw.PostProcessing, draw.Text;

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
    Array!Scene _scenes;
    Camera _camera;
    vec3f _angles, _lightDir;
    vec3f _ambiant;
    Application _context;
    bool _zoom, _unzoom;
    Light _light;
    TPSGuide _guide;

    Text _text;
    
    override void onCreate (Application context) {
	this._context = context;
	this._shader = new Shader (context.openglContext,
				   "shaders/model.vs",
				   "shaders/model.fs");

	this._vertBinder = new VertexSpecification!Vertex (this._shader.program);
	this._scenes.insertBack (new Scene ("models/rayman/Rayman3.obj", context, this._vertBinder));	
		
	this._camera = new Camera ();
	this._camera.perspective (70. * PI / 180, 800./600., 0.1, 99999.);
	
	this._camera.guide = this._guide = new TPSGuide (context);

	this._camera.lookAt (vec3f (0, 4, 7),
			     vec3f (0, 1, 0),
			     vec3f (0.0, 1., 0.));
	
	this._angles = vec3f (0.0, 1. / 60., 0.);
	this._lightDir = vec3f (-0.8, -2.0, -1.);
	this._ambiant = vec3f (0.3, 0.3, 0.3);

	this._text = new Text (context, "fonts/Font.ttf", 15);
	this._text.text = "Hello World!!";
	this._text.position = vec2f (15, 100);
	
	context.input.winResize.connect (&this.resize);
	context.input.keyboard (KeyInfo (SDLK_ESCAPE, -1)).connect (&this.end);
	context.input.keyboard (KeyInfo (SDLK_z, -1)).connect (&this.zoom);
	context.input.keyboard (KeyInfo (SDLK_u, -1)).connect (&this.unzoom);
	context.input.keyboard (KeyInfo (SDLK_p, SDL_KEYDOWN)).connect (&this.open);
    }

    void resize (int width, int height) {
	glViewport (0, 0, width, height);
	this._camera.perspective (70. * PI / 180, cast(float)width / cast(float)height, 0.1, 99999.);
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
	    this._text.text = "FPS : " ~ this._context.getFps ().to!string;
	    lastFps = this._context.getFps;
	}
    }
    
    override void onPause () {
	writeln ("Pause " ~ typeid (this).toString);
    }

    override void onResume () {
	writeln ("Pause " ~ typeid (this).toString);
    }

    override void onDraw2D () {
	this._text.draw ();
    }
    
    override void onDraw () {	
	this._shader.uniform ("ambiant").set (this._ambiant);
	this._shader.uniform ("lightPos").set (this._light.pos);
	this._shader.uniform ("viewMatrix").set (this._camera.getV ());
	this._shader.uniform ("projectionMatrix").set (this._camera.getP ());
	this._shader.uniform ("eyePos").set (this._camera.eye);

	foreach (it ; this._scenes) 
	it.draw (this._shader);
    }

    override void onClose () {
	writeln ("Close " ~ typeid (this).toString);
    }
        
}
