/*
 */
package tech.metacontext.ocnhfa.antsomg.impl;

import java.util.Objects;
import tech.metacontext.ocnhfa.antsomg.model.Vertex;

/**
 *
 */
public class StandardVertex implements Vertex {

    private final String name;

    public StandardVertex(String name) {

        this.name = name;
    }

    @Override
    public String getName() {

        return this.name;
    }

    @Override
    public String toString() {

        return this.name;
    }

    @Override
    public int hashCode() {

        int hash = 7;
        hash = 73 * hash + Objects.hashCode(this.name);
        return hash;
    }

    @Override
    public boolean equals(Object obj) {

        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final StandardVertex other = (StandardVertex) obj;
        return Objects.equals(this.name, other.name);
    }

}
