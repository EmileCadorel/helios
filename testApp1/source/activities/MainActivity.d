module activities.MainActivity;
import system.Activity, system.Shader, gfm.opengl;
import system.Camera;
import gfm.math, std.math;
import model.Vertex, model.Scene, std.stdio;

class MainActivity : Activity {

    Shader _shader;
    VertexSpecification!Vertex _vertBinder;
    Scene _scene;
    Camera _camera;
    vec3f _angles, _lightDir;
    
    override void onCreate (Application context) {
	writeln (context.openglContext ());
	this._shader = new Shader (context.openglContext,
				   "shaders/model.vs",
				   "shaders/model.fs");

	this._vertBinder = new VertexSpecification!Vertex (this._shader.program);
	this._scene = new Scene ("models/Rock.blend", context.openglContext, this._vertBinder);
	this._camera = new Camera ();
	this._camera.perspective (90. * PI / 180, 600./800., 0.1, 99999.);
	
	this._camera.lookAt (vec3f (0.0, 1.0, 4.0),
			     vec3f (0.0, 1.0, 0.0),
			     vec3f (0.0, 1., 0.));
	
	this._angles = vec3f (0.0, 1. / 120., 0.);
	this._lightDir = vec3f (-0.8, 0.0, -1.);
	context.input.winResize.connect (&this.resize);
    }

    void resize (int width, int height) {
	glViewport (0, 0, width, height);
	this._camera.perspective (90. * PI / 180, cast(float)height / cast(float)width, 0.1, 99999.);
	writeln ("ici", width, height);
    }
    
    override void onUpdate () {
	this._scene.rotate (this._angles);
    }
    
    override void onDraw () {
	this._shader.uniform ("lightDir").set (this._lightDir);
	this._shader.uniform ("viewMatrix").set (this._camera.getV ());
	this._shader.uniform ("projectionMatrix").set (this._camera.getP ());
	this._scene.draw (this._shader);
    }

    override void onClose () {
	
    }
        
}
