module activities.MainActivity;
import helios._, gfm.opengl;
import gfm.math, std.math;
import std.container, std.conv, std.stdio;

class MainActivity : Activity {

    Widget _box;    
    Text _text;
    LinearLayout _layout;
    
    override void onCreate (Application context) {
	this._layout = new LinearLayout (vec2f (30, 30), vec2f (730, 530), LinearLayout.Gravity.RIGHT);
	this._box = new FloatingBox (vec2f (10, 10), vec2f (200, 150), "OK");
	
	context.mainLayout.addWidget (this._layout);
	this._layout.addWidget (this._box);
	this._layout.addWidget (new Button (vec2f (0, 0), vec2f (100, 50), "OK"));
	context.input.keyboard (KeyInfo (SDLK_ESCAPE, -1)).connect (&this.end);
    }
    
    void end (KeyInfo info) {
	if (info.type == SDL_KEYUP) 
	    Application.currentContext.stop ();
	else
	    writeln ("Echap appuyé");
    }        
}
