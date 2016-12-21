module model.Scene;
import model.Mesh, model.Vertex, system.Application;
import gfm.math, gfm.opengl, system.Shader;


class Scene {

    private mat4f _world;
    private Mesh _mesh;

    this (string src, Application context, VertexSpecification!Vertex binder) {
	this._mesh = new Mesh (src, context, binder);
	this._world = mat4f.identity ();
    }
    
    this (Mesh mesh) {
	this._mesh = mesh;
    }   

    
    Mesh mesh () {
	return this._mesh;
    }
    
    public void rotate (float x, float y, float z) {
	auto aux = mat4f.rotation (x, vec3f (1., 0., 0.));
	aux *= mat4f.rotation (y, vec3f (0., 1., 0.));
	aux *= mat4f.rotation (z, vec3f (0., 0., 1.));
	this._world = aux * this._world;
    }

    void rotate (vec3f rotation) {
	auto aux = mat4f.rotation (rotation.x, vec3f (1., 0., 0.));
	aux *= mat4f.rotation (rotation.y, vec3f (0., 1., 0.));
	aux *= mat4f.rotation (rotation.z, vec3f (0., 0., 1.));
	this._world = aux * this._world;
    }

    void translate (vec3f trans) {
	auto aux = mat4f.translation (trans);
	this._world = aux * this._world;
    }

    void translate (float x, float y, float z) {
	auto aux = mat4f.translation (vec3f (x, y, z));
	this._world = aux * this._world;
    }

    void scale (vec3f scale) {
	auto aux = mat4f.scaling (scale);
	this._world = aux * this._world;
    }

    void scale (float x, float y, float z) {
	auto aux = mat4f.scaling (vec3f (x, y, z));
	this._world = aux * this._world;
    }
    
    mat4f getWorld () {
	 return this._world;
    }

    void draw (Shader shader) {
	shader.uniform ("worldMatrix").set (this._world);
	if (this._mesh.tex !is null) {
	    this._mesh.tex.use (shader);
	}
	shader.use ();
	this._mesh.draw ();
	shader.unuse ();
    }
   
}
