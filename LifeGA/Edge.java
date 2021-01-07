/*
 */
package tech.metacontext.ocnhfa.antsomg.model;

/**
 */
public interface Edge<V extends Vertex> {

    double getPheromoneTrail();

    void addPheromoneDeposit(double pheromoneDeposit);

    void evaporate(double rate);

    double getCost();

    void setFrom(V from);

    V getFrom();

    void setTo(V to);

    V getTo();

}
