module activities.MainActivity;
import helios._, gfm.opengl;
import gfm.math, std.math;
import std.container, std.conv, std.stdio;

class MainActivity : Activity {
    

    override void onCreate (Application context) {
	context.mainLayout.addWidget (GUI.layout);
	
	context.input.keyboard (KeyInfo (SDLK_ESCAPE, -1)).connect (&this.end);
    }

    
    void end (KeyInfo info) {
	if (info.type == SDL_KEYUP) 
	    Application.currentContext.stop ();
	else
	    writeln ("Echap appuyé");
    }        
}
