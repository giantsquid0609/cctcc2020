/*
 */
package art.cctcc.c1635.antsomg.demo.x;

import tech.metacontext.ocnhfa.antsomg.impl.StandardEdge;

/**
 *
 */
public class Edge_X extends StandardEdge<Vertex_X> {

    public Edge_X(Vertex_X from, Vertex_X to, Double cost) {

        super(from, to, cost);
    }

    public Edge_X(Vertex_X to) {

        this(null, to, 0.0);
    }
}
