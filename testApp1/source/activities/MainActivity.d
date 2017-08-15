module activities.MainActivity;
import helios._, gfm.opengl;
import gfm.math, std.math;
import std.container, std.conv, std.stdio;

class MainActivity : Activity {

    Widget _box;    
    Text _text;
    
    override void onCreate (Application context) {
	this._box = new FloatingBox (vec2f (10, 10), vec2f (200, 150), "OK");
	context.mainLayout.addWidget (this._box);
	context.input.keyboard (KeyInfo (SDLK_ESCAPE, -1)).connect (&this.end);
    }
    
    void end (KeyInfo info) {
	if (info.type == SDL_KEYUP) 
	    Application.currentContext.stop ();
	else
	    writeln ("Echap appuyé");
    }        
}
