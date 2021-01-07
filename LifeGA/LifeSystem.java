/*
 */
package art.cctcc.c1635.antsomg.demo;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import art.cctcc.c1635.antsomg.demo.x.Graph_X;
import art.cctcc.c1635.antsomg.demo.x.Vertex_X;
//import art.cctcc.c1635.antsomg.demo.y.Graph_Y;
//import art.cctcc.c1635.antsomg.demo.y.Vertex_Y;
import java.util.HashMap;
import tech.metacontext.ocnhfa.antsomg.impl.StandardEdge;
import tech.metacontext.ocnhfa.antsomg.impl.StandardGraph;
import tech.metacontext.ocnhfa.antsomg.impl.StandardMove;
import tech.metacontext.ocnhfa.antsomg.model.AntsOMGSystem;

/**
 *
 */
public class LifeSystem implements AntsOMGSystem<LifeAnt> {

  int ant_population;
  Map<String, StandardGraph> graphs;
  List<LifeAnt> ants;
  double pheromone_deposit = 0.5;
  double explore_chance = 0.03;
  double evaporate_rate = 0.05;
  double alpha = 1.0, beta = 1.0;

  public LifeSystem(int ant_population) {

    this.ant_population = ant_population;
  }

  @Override
    public void init_graphs() {

    this.graphs = new HashMap<>();
    this.graphs.put("x", new Graph_X(alpha, beta));
    //this.graphs.put("y", new Graph_Y(alpha, beta));
  }

  Graph_X getX() {

    return (Graph_X) this.graphs.get("x");
  }

  /*Graph_Y getY() {

    return (Graph_Y) this.graphs.get("y");
  }*/

  @Override
    public void init_population() {

    this.ants = new ArrayList<>();
    for (int i=0; i<ant_population; i++) {
      ants.add(new LifeAnt(
        getX().getStart())); 
        //getY().getStart()));
    }
  }

  @Override
    public void navigate() {

    for (LifeAnt ant : this.ants) {
      if (!ant.isCompleted()) {
        LifeTrace trace = ant.getCurrentTrace();
        StandardMove x = getX().move((Vertex_X) trace.getDimension("x"), 
          this.pheromone_deposit, this.explore_chance);
        //StandardMove y = getY().move((Vertex_Y) trace.getDimension("y"), 
          //this.pheromone_deposit, this.explore_chance);
        LifeTrace new_trace = new LifeTrace(x); //y
        ant.setCurrentTrace(new_trace);
        if (ant.isBalanced()) {
          ant.addCurrentTraceToRoute();
          ant.setCompleted(true);
        }
      }
    }
    this.evaporate();
  }

  @Override
    public void evaporate() {

    for (StandardGraph graph : this.graphs.values()) {
      for (Object edge : graph.getEdges()) {
        ((StandardEdge)edge).evaporate(evaporate_rate);
      }
    }
  }

  @Override
    public boolean isAimAchieved() {

    for (LifeAnt ant : this.ants) {
      if (!ant.isCompleted()) return false;
    }
    return true;
  }

  @Override
    public List<LifeAnt> getAnts() {

    return this.ants;
  }

  @Override
    public Map<String, StandardGraph> getGraphs() {

    return this.graphs;
  }
}
