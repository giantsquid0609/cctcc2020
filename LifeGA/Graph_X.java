/*
 */
package art.cctcc.c1635.antsomg.demo.x;

import art.cctcc.c1635.antsomg.demo.x.Vertex_X.*;
import tech.metacontext.ocnhfa.antsomg.impl.StandardGraph;


public class Graph_X extends StandardGraph<Edge_X, Vertex_X> {

    public Graph_X(double alpha, double beta) {

        super(alpha, beta);
        setFraction_mode(StandardGraph.FractionMode.Power);
    }

    @Override
    public void init_graph() {

        Vertex_X spread = Vertex_X.get(X.SPREAD);
        Vertex_X shrink = Vertex_X.get(X.SHRINK);
        Vertex_X change_color = Vertex_X.get(X.CHANGE);
        Vertex_X find = Vertex_X.get(X.FIND);
        Vertex_X escape = Vertex_X.get(X.ESCAPE);
        Vertex_X speed_up = Vertex_X.get(X.SPEED_UP);
        Vertex_X speed_down = Vertex_X.get(X.SPEED_DOWN);
        Vertex_X idle = Vertex_X.get(X.IDLE);
        
        this.setStart(idle);
        
        // SP: spread, SH: shrink, FI: find, ES: escape, UP: speed_up, DN: speed_down, CH: change_color, ID: idle
        
        Edge_X SP_SH = new Edge_X(spread, shrink, 20.0);
        Edge_X SP_SP = new Edge_X(spread, spread, 100.0);
        Edge_X SP_ID = new Edge_X(spread, idle, 10.0);
        Edge_X SH_SP = new Edge_X(shrink, spread, 20.0);
        Edge_X SH_SH = new Edge_X(shrink, shrink, 100.0);
        Edge_X SH_ID = new Edge_X(shrink, idle, 10.0);
        
        Edge_X ES_FI = new Edge_X(escape, find, 100.0);
        Edge_X ES_ID = new Edge_X(escape, idle, 1.0);
        Edge_X FI_ES = new Edge_X(find, escape, 100.0);
        Edge_X FI_ID = new Edge_X(find, idle, 1.0);
        
        Edge_X UP_DN = new Edge_X(speed_up, speed_down, 10.0);
        Edge_X UP_ID = new Edge_X(speed_up, idle, 1.0);
        Edge_X UP_UP = new Edge_X(speed_up, speed_up, 10000.0);
        Edge_X DN_UP = new Edge_X(speed_down, speed_up, 10000.0);
        Edge_X DN_ID = new Edge_X(speed_down, idle, 1.0);
        Edge_X DN_DN = new Edge_X(speed_down, speed_down, 100.0);
        
        Edge_X CH_ID = new Edge_X(change_color, idle, 1.0);
        
        Edge_X ID_SP = new Edge_X(idle, spread, 100.0);
        Edge_X ID_SH = new Edge_X(idle, shrink, 100.0);
        Edge_X ID_FI = new Edge_X(idle, find, 3000.0);
        Edge_X ID_ES = new Edge_X(idle, escape, 1000.0);
        Edge_X ID_UP = new Edge_X(idle, speed_up, 500.0);
        Edge_X ID_DN = new Edge_X(idle, speed_down, 300.0);
        Edge_X ID_CH = new Edge_X(idle, change_color, 5000.0);
        Edge_X ID_ID = new Edge_X(idle, idle, 1.0);
        
        this.addEdges(
                SP_SH, SP_SP, SP_ID, SH_SP, SH_SH, SH_ID,
                ES_FI, ES_ID, FI_ES, FI_ID,
                UP_DN, UP_ID, UP_UP, DN_UP,
                DN_ID, DN_DN, CH_ID, ID_SP,
                ID_SH, ID_FI, ID_ES, ID_UP,
                ID_DN, ID_CH, ID_ID
                );
    }
}
