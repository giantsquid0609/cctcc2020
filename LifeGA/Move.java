/*
 */
package tech.metacontext.ocnhfa.antsomg.model;

/**
 *
 * @param <E>
 */
public interface Move<E extends Edge<? extends Vertex>> {

    boolean isExploring();

    E getSelected();
}
