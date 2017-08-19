module activities.MainActivity;
import helios._, gfm.opengl;
import gfm.math, std.math;
import std.container, std.conv, std.stdio;

class MainActivity : Activity {
    
    Shader _shader;
    VertexSpecification!Vertex _vertBinder;
    
    override void onCreate (Application context) {
	context.mainLayout.addWidget (GUI.layout);
	auto view = cast (D3View) context.mainLayout.D3;
	(cast (Button) context.mainLayout.FIN).clicked.connect (&this.fin);

	this._shader = new Shader (context.openglContext,
				   "shaders/model.vs",
				   "shaders/model.fs");

	this._vertBinder = new VertexSpecification!Vertex (this._shader.program);
	
	view.drawRoutine = &this.draw3D;
	view.scenes.insertBack (new Scene ("models/rayman/Rayman3.obj",
					   context, this._vertBinder));	
	view.camera = new Camera ();
	view.camera.fov (70. * PI / 180);	
	view.camera.dim (0.1, 99999.);
	
	view.camera.guide = new TPSGuide (context);
	
	view.camera.lookAt (vec3f (0, 4, 7),
			    vec3f (0, 1.8, 0),
			    vec3f (0.0, 1, 0.));
	
	context.input.keyboard (KeyInfo (SDLK_ESCAPE, -1)).connect (&this.end);
    }

    void draw3D (Camera cam, Array!Scene scenes) {	
	this._shader.uniform ("ambiant").set (vec3f (0.2, 0.2, 0.2));
	this._shader.uniform ("lightPos").set (vec3f (4, 1, 4));
	this._shader.uniform ("viewMatrix").set (cam.getV ());
	this._shader.uniform ("projectionMatrix").set (cam.getP ());
	this._shader.uniform ("eyePos").set (cam.eye);

	foreach (it ; scenes) 
	    it.draw (this._shader);
    }

    void fin () {
	Application.currentContext.stop ();
    }
    
    void end (KeyInfo info) {
	if (info.type == SDL_KEYUP) 
	    Application.currentContext.stop ();
	else
	    writeln ("Echap appuyé");
    }        
}
