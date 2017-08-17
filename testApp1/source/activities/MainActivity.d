module activities.MainActivity;
import helios._, gfm.opengl;
import gfm.math, std.math;
import std.container, std.conv, std.stdio;

class MainActivity : Activity {

    Widget _box;    
    Text _text;
    GridLayout _layout;
    Button!(int) _0, _1, _2, _3, _4, _5, _6, _7, _8, _9;
    Button!(Operator) _add, _sub, _mul, _div, _eq;
    Label _value;
    Operator _op = Operator.NONE;
    
    string _curNum;
    string _lastNum;
    

    enum Operator {
	ADD,
	SUB,
	DIV,
	MUL,
	EQ,
	NONE
    }
    
    override void onCreate (Application context) {
	this._layout = new GridLayout (vec2f (0, 0), vec2f (400, 600), 5);
	//	this._box = new FloatingBox (vec2f (10, 10), vec2f (200, 150), "OK");

	context.mainLayout.addWidget (this._layout);
	this._layout.setPaddings (10, 10);
	this._layout.setHeights ([0.20, 0.20, 0.20, 0.20, 0.20]);
	this._layout.describe (1, [0.25, 0.25, 0.25, 0.25]);
	this._layout.describe (2, [0.25, 0.25, 0.25, 0.25]);
	this._layout.describe (3, [0.25, 0.25, 0.25, 0.25]);
	this._layout.describe (4, [0.5, 0.25, 0.25]);
	
	
	this._layout.addWidget (this._value = new Label ("", 30));

	this._layout.addWidget (this._7 = new Button!int ("7", 7, 30));
	this._layout.addWidget (this._8 = new Button!int ("8", 8, 30));
	this._layout.addWidget (this._9 = new Button!int ("9", 9, 30));
	this._layout.addWidget (this._add = new Button!(Operator) ("+", Operator.ADD, 30));

	this._layout.addWidget (this._4 = new Button!int ("4", 4, 30));
	this._layout.addWidget (this._5 = new Button!int ("5", 5, 30));
	this._layout.addWidget (this._6 = new Button!int ("6", 6, 30));
	this._layout.addWidget (this._sub = new Button!(Operator) ("-", Operator.SUB, 30));

	this._layout.addWidget (this._1 = new Button!int ("1", 1, 30));
	this._layout.addWidget (this._2 = new Button!int ("2", 2, 30));
	this._layout.addWidget (this._3 = new Button!int ("3", 3, 30));
	this._layout.addWidget (this._mul = new Button!(Operator) ("*",  Operator.MUL, 30));

	this._layout.addWidget (this._0 = new Button!int ("0", 0, 30));
	this._layout.addWidget (this._eq = new Button!(Operator) ("=", Operator.EQ, 30));
	this._layout.addWidget (this._div = new Button!(Operator) ("/", Operator.DIV, 30));
	
	context.input.keyboard (KeyInfo (SDLK_ESCAPE, -1)).connect (&this.end);

	this._9.clicked.connect (&this.numberClicked);
	this._8.clicked.connect (&this.numberClicked);
	this._7.clicked.connect (&this.numberClicked);
	this._6.clicked.connect (&this.numberClicked);
	this._5.clicked.connect (&this.numberClicked);
	this._4.clicked.connect (&this.numberClicked);
	this._3.clicked.connect (&this.numberClicked);
	this._2.clicked.connect (&this.numberClicked);
	this._1.clicked.connect (&this.numberClicked);
	this._0.clicked.connect (&this.numberClicked);

	this._add.clicked.connect (&this.operatorClicked);
	this._sub.clicked.connect (&this.operatorClicked);
	this._mul.clicked.connect (&this.operatorClicked);
	this._div.clicked.connect (&this.operatorClicked);
	this._eq.clicked.connect (&this.operatorClicked);
	
    }

    void numberClicked (int value) {
	import std.conv;
	auto text = this._value.text;
	this._value.text = text ~ value.to!string;
	this._curNum = this._curNum ~ value.to!string;
    }

    void operatorClicked (Operator op) {
	if (this._op != Operator.NONE) {
	    switch (this._op) {
	    case Operator.ADD : this._lastNum = (this._curNum.to!long + this._lastNum.to!long).to!string; break;
	    case Operator.SUB : this._lastNum = (this._lastNum.to!long - this._curNum.to!long).to!string; break;
	    case Operator.DIV : this._lastNum = (this._lastNum.to!long / this._curNum.to!long).to!string; break;
	    case Operator.MUL : this._lastNum = (this._lastNum.to!long * this._curNum.to!long).to!string; break;
	    default : assert (false);
	    }
	    
	    if (op == Operator.EQ) {
		this._curNum = this._lastNum;
		this._lastNum = "";
		this._value.text = this._curNum;
		this._op = Operator.NONE;
	    } else {
		this._curNum = "";
		this._value.text = this._lastNum ~ stringify (op);
		this._op = op;
	    }
	} else {
	    this._op = op;
	    this._lastNum = this._curNum;
	    this._value.text = this._lastNum ~ stringify (op);
	    this._curNum = "";
	}
    }

    string stringify (Operator op) {
	switch (op) {
	case Operator.ADD : return " + ";
	case Operator.SUB : return " - ";
	case Operator.DIV : return " / ";
	case Operator.MUL : return " * ";
	default : assert (false);
	}
    }

    void end (KeyInfo info) {
	if (info.type == SDL_KEYUP) 
	    Application.currentContext.stop ();
	else
	    writeln ("Echap appuyé");
    }        
}
