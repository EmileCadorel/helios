module helios.system.Timer;
import gfm.sdl2;
import helios.units.Second;


class Timer {

    private int _beginTime;
    private int _tickTime;

    void start() {
	this._beginTime = SDL_GetTicks();
	this._tickTime = this._beginTime;
    }

    void tick() {
	this._tickTime = SDL_GetTicks();
    }

    void frame() {
	this.start ();
    }

    Second elapsed() {
	return Second.fromMilli(this._tickTime - this._beginTime);
    }
}
