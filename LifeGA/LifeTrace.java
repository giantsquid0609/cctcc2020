/*
 */
package art.cctcc.c1635.antsomg.demo;

import art.cctcc.c1635.antsomg.demo.x.Edge_X;
//import art.cctcc.c1635.antsomg.demo.y.Edge_Y;
import tech.metacontext.ocnhfa.antsomg.impl.StandardMove;
import tech.metacontext.ocnhfa.antsomg.model.Trace;
import tech.metacontext.ocnhfa.antsomg.model.Vertex;


public class LifeTrace implements Trace {

    private final StandardMove<Edge_X> x;
    //private final StandardMove<Edge_Y> y;

    public LifeTrace(
            StandardMove<Edge_X> x) { //StandardMove<Edge_Y> y
        this.x = x;
        //this.y = y;
    }

    @Override
    public Vertex getDimension(String dimension) {

        Vertex result = this.x.getSelected().getTo();
                        //"x".equals(dimension)
                        // ? this.x.getSelected().getTo(): this.y.getSelected().getTo();
        return result;
    }

    public StandardMove<Edge_X> getX() {

        return this.x;
    }
/*
    public StandardMove<Edge_Y> getY() {

        return this.y;
    }
*/
    @Override
    public String toString() {

        return String.format("DemoTrace{%s, %s}",
                x.getSelected().getTo());
                //y.getSelected().getTo());
    }

}
