module system.Configuration;
import std.json, std.file, std.conv, std.stdio;

struct Configuration {

    string name;
    int  width;
    int height;
    string [] activities;
    string mainAct = null;    
    
    this (string file) {
	auto j = parseJSON (readText (file));
	foreach (string key, value ; j) {
	    if (key == "name") {
		this.name = value.str;
	    } else if (key == "size") {
		this.parseSize (value);
	    } else if (key == "activities") {
		parseActivities (value);
	    }
	}
    }

    private void parseSize (JSONValue value) {
	if (!("width" in value) || !("height" in value)) {
	    assert (false, "Fichier de config malformé");
	} else {
	    this.width = to!int (value["width"].integer);
	    this.height = to!int (value["height"].integer);
	}
    }
    
    private void parseActivities (JSONValue _value) {	
	foreach (string key, value ; _value) {
	    auto array = value.array ();
	    if (array.length > 0 && array[0].str == "main") {
		if (this.mainAct !is null) assert (false, "Plusieurs activité principale");
		else this.mainAct = key;
	    }
	    this.activities ~= [key];
	}
    }


    
}
