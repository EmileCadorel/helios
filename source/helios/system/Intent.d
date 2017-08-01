module helios.system.Intent;
import helios.system.Application;

class Intent {

    private Application _context;
    private void* [string] datas;
    private Object [string] _objData;
    private string [string] _stringData;
    
    this (Application context) {	
	this._context = context;
	context.intent = this;	
    }
    
    void opIndexAssign (T : Object) (T elem, string name) {
     	_objData[name] = elem;
    }
    
    void opIndexAssign (T) (T * elem, string name) {
    	datas[name] = (elem);
    }

    void opIndexAssign (T : string) (T elem, string name) {
	_stringData [name] = (elem);
    }
    
    T get (T : Object) (string name) {
	auto elem = (name in _objData);
	if (elem is null) return null;
	else return cast (T) (*elem);
    }

    T get (T : string) (string name) {
	auto elem = (name in _stringData);
	if (elem is null) return null;
	else return (*elem);
    }
    
    T * get (T) (string name) {
	auto elem = (name in datas);
	if (elem is null) return null;
	else return  (*cast (T**)elem);
    }

    void launch (string act) {
	this._context.launch (act);
    }
    
}
