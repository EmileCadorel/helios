module helios.gui.GuiLoader;
import helios.gui._;
import helios.utils.Singleton;
import std.json, std.stdio, std.file;


class GuiLoader {

    private Widget function (JSONValue) [string] _elements;
    
    Widget load (string file) {
	auto j = parseJSON (readText (file));
	return load (j);
    }

    package Widget load (JSONValue value) {
	auto key = "type" in value;
	if (key is null) assert (false);
	auto it = key.str in this._elements;
	if (it !is null) return (*it) (value);
	else assert (false, key.str);
    }
    
    void storeWidget (string name, Widget function (JSONValue) func) {
	this._elements [name] = func;
    }

    Widget opDispatch (string name) () {
	auto file = "ressources/" ~ name ~ ".json";
	if (exists (file)) return load (file);
	else assert (false);
    }

    mixin Singleton;
}

alias GUI = GuiLoader.instance;
