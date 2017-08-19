module activities.MainActivity;
import helios._, gfm.math;

class MainActivity : Activity {

    override void onCreate (Application context) {
	context.mainLayout.addWidget (GUI.layout);
    }
       
}
