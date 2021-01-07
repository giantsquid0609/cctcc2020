/*
 */
package tech.metacontext.ocnhfa.antsomg.model;

import java.util.List;

/**
 *
 * @param <E>
 * @param <V>
 * @param <H>
 */
public interface Graph<E extends Edge<V>, V extends Vertex, H extends Move<E>> {

    void init_graph();

    H move(V current, double pheromone_deposit, double explore_chance, double... parameters);

    List<E> queryByVertex(V vertex);
    
}
