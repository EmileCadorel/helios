import std.stdio;
import system.Window, model.Scene, system.Shader, system.Camera;
import gfm.sdl2, model.Vertex, gfm.opengl, gfm.math, std.math;
import std.experimental.logger;

void main() {
    auto log = new FileLogger ("helios.txt");
    auto window = new Window (log);
    auto shader = new Shader(window.context, "shaders/model.vs", "shaders/model.fs");
    auto vertBinder = new VertexSpecification!Vertex (shader.program);
    auto scene = new Scene ("models/Rock.blend", window.context, vertBinder);
    auto camera = new Camera ();
    
    camera.perspective (90. * PI / 180, 600./800., 0.1, 99999.);
    camera.lookAt (vec3f (0.0, 1.0, 4.0), vec3f (0.0, 1.0, 0.0), vec3f (0.0, 1., 0.));
    auto lightDir = vec3f(-0.8, -5.0, -1.0).normalized();    
    
    mainLoop: while (true) {
	SDL_Event event;
	window.clear ();
	while (SDL_PollEvent (&event)) {
	    if (event.type == SDL_QUIT)  break mainLoop;
	    else if (event.type == SDL_KEYDOWN) {
		glPolygonMode( GL_FRONT_AND_BACK, GL_LINE );
	    } else if (event.type == SDL_KEYUP) {
		glPolygonMode( GL_FRONT_AND_BACK, GL_FILL );
	    }
	}
	
	shader.uniform ("lightDir").set (lightDir);
	shader.uniform ("viewMatrix").set (camera.getV());
	shader.uniform ("projectionMatrix").set (camera.getP ());
	scene.draw (shader);
	
	window.swap ();
    }
}
