/*
 */
package art.cctcc.c1635.antsomg.demo;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import art.cctcc.c1635.antsomg.demo.x.Edge_X;
import art.cctcc.c1635.antsomg.demo.x.Vertex_X;
//import art.cctcc.c1635.antsomg.demo.y.Edge_Y;
//import art.cctcc.c1635.antsomg.demo.y.Vertex_Y;
import java.util.Map;
import tech.metacontext.ocnhfa.antsomg.impl.StandardMove;
import tech.metacontext.ocnhfa.antsomg.model.Ant;
import tech.metacontext.ocnhfa.antsomg.model.Vertex;

/**
 *
 */
public class LifeAnt implements Ant<LifeTrace> {

  LifeTrace currentTrace;
  List<LifeTrace> route;
  private boolean completed;

  public LifeAnt(Vertex_X x) {

    this.currentTrace = new LifeTrace(
      new StandardMove<>(new Edge_X(x)) 
      //new StandardMove<>(new Edge_Y(y))
      );
    this.route = new ArrayList<>();
  }

  boolean isBalanced() {
    /*int cnt = 0;
    for (LifeTrace t : route) {
      switch(t.getDimension("x").getName()) {
      case "SPREAD":
      case "SHRINK":
      case "CHANGE":
      case "FIND":
      case "ESCAPE":
      case "SPEED_UP":
      case "SPEED_DOWN":
      case "IDLE":
      default:
      ++cnt;
      }
    }

    if ( cnt > 100) {
        return true;
    }*/
    
    return false;
  }

  @Override
    public List<LifeTrace> getRoute() {

    return this.route;
  }

  @Override
    public void addCurrentTraceToRoute() {

    this.route.add(this.currentTrace);
  }

  @Override
    public LifeTrace getCurrentTrace() {

    return this.currentTrace;
  }

  @Override
    public void setCurrentTrace(LifeTrace trace) {

    if (Objects.nonNull(this.currentTrace)) {
      this.addCurrentTraceToRoute();
    }
    this.currentTrace = trace;
  }

  public boolean isCompleted() {

    return completed;
  }

  public void setCompleted(boolean completed) {

    this.completed = completed;
  }
}
