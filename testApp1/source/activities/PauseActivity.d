module activities.PauseActivity;
import helios._;
import gfm.math, std.math;
import std.container, std.conv;
import std.stdio;

class PauseActivity : Activity {

    override void onCreate (Application context) {
	context.input.keyboard (KeyInfo (SDLK_d, SDL_KEYDOWN)).connect (&this.close);
	auto intent = context.intent;	
    }

    void close (KeyInfo) {
	super.close ();
    }
    
    override void onUpdate () {
    }

    override void onDraw () {
    }

    override void onClose () {
	writeln ("Close " ~ typeid (this).toString);
    }    

}
