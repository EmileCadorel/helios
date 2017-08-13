module helios.system.Signal;
import std.container;
import std.algorithm;

class Signal (Type...) {
    alias SlotDel = void delegate (Type);
    alias SlotFunc = void function (Type);
	
    Array! (SlotDel) _slotDels;
    Array! (SlotFunc) _slotFuncs;
	
    void connect (SlotDel slot) {
	this._slotDels.insertBack (slot);
    }

    void connect (SlotFunc slot) {
	this._slotFuncs.insertBack (slot);
    }

    void disconnect (SlotDel slot) {
	auto it = this._slotDels[].find!"a is b" (slot);
	if (!it.empty) {
	    this._slotDels.linearRemove (it);
	}
    }

    void disconnect (SlotFunc slot) {
	auto it = this._slotFuncs[].find!"a is b" (slot);
	if (!it.empty) {
	    this._slotFuncs.linearRemove (it);
	}
    }
	
    void opCall (Type elem) {
	foreach (it ; this._slotFuncs)
	    it (elem);
	foreach (it ; this._slotDels)
	    it (elem);
    }		
}
