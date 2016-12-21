module activities.MainActivity;
import system.Activity, system.Shader, gfm.opengl;
import system.Camera, system.Input;
import gfm.math, std.math;
import model.Vertex, model.Scene, std.stdio;
import std.container, std.conv;

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
    Application _context;
    Light _light;

    
    override void onCreate (Application context) {
	this._context = context;
	this._shader = new Shader (context.openglContext,
				   "shaders/model.vs",
				   "shaders/model.fs");

	this._vertBinder = new VertexSpecification!Vertex (this._shader.program);
	this._scenes.insertBack (new Scene ("models/rayman/Rayman3.obj", context, this._vertBinder));	
		
	this._camera = new Camera ();
	this._camera.perspective (70. * PI / 180, 800./600., 0.1, 99999.);
	
	this._camera.lookAt (vec3f (0, 4, 7),
			     vec3f (0, 1, 0),
			     vec3f (0.0, 1., 0.));
	
	this._angles = vec3f (0.0, 1. / 60., 0.);
	this._lightDir = vec3f (-0.8, -2.0, -1.);
	context.input.winResize.connect (&this.resize);
	context.input.keyboard (KeyInfo (SDLK_ESCAPE, SDL_KEYDOWN)).connect (&this.end);
    }

    void resize (int width, int height) {
	glViewport (0, 0, width, height);
	this._camera.perspective (70. * PI / 180, cast(float)width / cast(float)height, 0.1, 99999.);
    }

    void end (KeyInfo) {
	this._context.stop ();
    }
    
    override void onUpdate () {
	foreach (it ; this._scenes)
	    it.rotate (this._angles);
	this._light.rotate (this._angles);
    }
    
    override void onDraw () {
	this._shader.uniform ("lightPos").set (this._light.pos);
	this._shader.uniform ("viewMatrix").set (this._camera.getV ());
	this._shader.uniform ("projectionMatrix").set (this._camera.getP ());
	this._shader.uniform ("eyePos").set (this._camera.eye);

	foreach (it ; this._scenes) 
	    it.draw (this._shader);
	
    }

    override void onClose () {
	
    }
        
}
