/*
 */
package tech.metacontext.ocnhfa.antsomg.impl;

import java.lang.reflect.InvocationTargetException;
import java.util.logging.Level;
import java.util.logging.Logger;
import tech.metacontext.ocnhfa.antsomg.model.Edge;

/**
 *
 * @param <V>
 */
public class StandardEdge<V extends StandardVertex> implements Edge<V> {

    private double pheromoneTrail;
    private double cost;
    private V from, to;

    public StandardEdge(V from, V to, double cost) {

        this.from = from;
        this.to = to;
        this.cost = cost;
    }

    public <E extends StandardEdge> E getReverse() {

        try {
            return (E) this.getClass()
                    .getConstructor(this.getTo().getClass(), this.getFrom().getClass(), Double.class)
                    .newInstance(to, from, cost);
        } catch (NoSuchMethodException | SecurityException | InstantiationException
                | IllegalAccessException | IllegalArgumentException | InvocationTargetException ex) {
            Logger.getLogger(StandardEdge.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    @Override
    public void addPheromoneDeposit(double pheromoneDeposit) {

        this.pheromoneTrail += pheromoneDeposit;
    }

    @Override
    public double getPheromoneTrail() {

        return this.pheromoneTrail;
    }

    public void setPheromoneTrail(double pheromoneTrail) {

        this.pheromoneTrail = pheromoneTrail;
    }

    @Override
    public double getCost() {

        return this.cost;
    }

    public void setCost(double cost) {
        this.cost = cost;
    }

    @Override
    public V getFrom() {

        return this.from;
    }

    @Override
    public void evaporate(double rate) {

        this.pheromoneTrail *= (1.0 - rate);
    }

    @Override
    public void setFrom(V from) {

        this.from = from;
    }

    @Override
    public void setTo(V to) {

        this.to = to;
    }

    @Override
    public V getTo() {

        return this.to;
    }

}
