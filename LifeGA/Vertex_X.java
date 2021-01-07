/*
 */
package art.cctcc.c1635.antsomg.demo.x;

import java.util.HashMap;
import java.util.Map;
import tech.metacontext.ocnhfa.antsomg.impl.StandardVertex;

/**
 *
 */
public class Vertex_X extends StandardVertex {

    private static Map<X, Vertex_X> instances
            = new HashMap<>();

    public static enum X {
        SPREAD, SHRINK, CHANGE,
        FIND, ESCAPE,
        SPEED_UP, SPEED_DOWN, IDLE;
        X() {
            instances.put(this, new Vertex_X(this));
        }
    }

    private Vertex_X(X name) {

        super(name.toString());
    }

    public static Vertex_X get(X name) {

        return instances.get(name);
    }
}
