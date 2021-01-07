/*
 */
package tech.metacontext.ocnhfa.antsomg.model;

import java.util.List;
import java.util.Map;

/**
 *
 */
public interface AntsOMGSystem<A extends Ant> {

    void init_graphs();

    void init_population();

    void navigate();

    void evaporate();

    boolean isAimAchieved();

    Map<String, ? extends Graph> getGraphs();

    List<A> getAnts();   
}
