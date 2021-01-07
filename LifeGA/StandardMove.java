/*
 */
package tech.metacontext.ocnhfa.antsomg.impl;

import java.util.AbstractMap.SimpleEntry;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;
import tech.metacontext.ocnhfa.antsomg.model.Move;

/**
 *
 * @param <E>
 */
public class StandardMove<E extends StandardEdge<? extends StandardVertex>>
  implements Move<E> {

  private final boolean exploring;
  private final E selected;
  private final Map<E, Double> pheromoneRecords;

  public static <E extends StandardEdge<? extends StandardVertex>>
    StandardMove<E> getInstance(boolean exploring, List<E> edges, E selected) {

    return new StandardMove<>(exploring, edges, selected);
  }

  public StandardMove(boolean exploring, List<E> edges, E selected) {

    this.exploring = exploring;
    this.selected = selected;
    this.pheromoneRecords = new HashMap<E, Double>();
    for (E edge:edges) {
      this.pheromoneRecords.put(edge, edge.getPheromoneTrail());
    }
  }

  public StandardMove(E selected) {

    this.exploring = false;
    this.selected = selected;
    this.pheromoneRecords = null;
  }

  public Double getPheromoneTrail(E edge) {

    return this.pheromoneRecords.get(edge);
  }

  @Override
    public boolean isExploring() {

    return this.exploring;
  }

  @Override
    public E getSelected() {

    return this.selected;
  }

  public Map<E, Double> getPheromoneRecords() {

    return this.pheromoneRecords;
  }
}
