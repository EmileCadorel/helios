module system.Shader;
import system.Window;
import gfm.opengl, gfm.math;
import std.stdio, std.algorithm, std.conv, std.array;

class Shader {

    private string _vertFile;
    private string _fragFile;
    private OpenGL _context;
    private GLProgram _program;
    
    this (OpenGL context, string vertFile, string fragFile) {
	this._vertFile = vertFile;
	this._fragFile = fragFile;
	this._context = context;
	this.compile ();
    }

    private void compile () {
	string [] vertSource = this.readLines (this._vertFile);
	string [] fragSource = this.readLines (this._fragFile);
	auto vertShader = new GLShader (this._context, GL_VERTEX_SHADER);
	vertShader.load (vertSource);
	vertShader.compile ();
	
	auto fragShader = new GLShader (this._context, GL_FRAGMENT_SHADER);
	fragShader.load (fragSource);
	fragShader.compile ();	
	
	auto shaders = [vertShader, fragShader];
	this._program = new GLProgram (this._context, shaders);
    }
        
    private string [] readLines (string path) {
	return File(path, "r").byLine.map!(to!string).array;
    }

    auto uniform (string what) {
	return this._program.uniform (what);
    }

    void use () {
	this._program.use ();
    }

    void unuse () {
	this._program.unuse ();
    }    

    ref GLProgram program () {
	return this._program;
    }
    
}
