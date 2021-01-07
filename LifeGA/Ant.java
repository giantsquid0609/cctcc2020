/*
 * 
 */
package tech.metacontext.ocnhfa.antsomg.model;

import java.util.List;

/**
 *
 */
public interface Ant<T extends Trace> {

    public List<T> getRoute();

    public void setCurrentTrace(T trace);

    public T getCurrentTrace();

    public void addCurrentTraceToRoute();

}
