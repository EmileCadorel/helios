module units.Second;

struct Second {

    private int _data;

    this (int nb) {
	this._data = nb * 1000;
    }    

    static Second fromMilli(int nb) {
	return Second (nb / 1000);
    }

    Second opBinary (string s) (float other) const {
	switch (s) {
	case "*" : return Second(((this._data / 1000)* other));
	case "/" : return Second(((this._data / 1000) / other));
	case "+" : return Second((this._data + other._data) / 1000);
	case "-" : return Second((this._data - other._data) / 1000);
	default : static assert (false);
	}
    }

    int opCmp (Second other) const {
	return this._data - other._data;
    }
    
    bool opEquals (ref const Second other) const {
	return this._data == other._data;
    }

    int opCmp (ref const Second other) const {
	return this._data - other._data;
    }
    
};
