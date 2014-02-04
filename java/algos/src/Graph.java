import com.sun.tools.hat.internal.util.Comparer;

import java.util.HashSet;

/**
 * Created by kamil on 26.12.2013.
 */
public class Graph {
    public class Edge implements Comparable{
        public Node from;
        public Node to;
        public int weight;
        public Edge(Node from, Node to, int weight) {
            this.to = to;
            this.from = from;
            this.weight = weight;
        }
        @Override
        public String toString() {
            return from.Name + " ==> " + to.Name;
        }

        @Override
        public int compareTo(Object o) {
            return Double.compare(this.weight, ((Edge)o).weight);
        }
    }

    public class Node implements Comparable {
        public String Name ;
        public HashSet<Edge> edges;
        public Boolean Visited;
        public Node Parent;
        public int minDistance = Integer.MAX_VALUE;

        public Node(String name) {
            this.Name = name;
            edges = new HashSet<Edge>();
            Visited = false;
        }

        public Node addEdge(Node to, int weight) {
            Edge edge = new Edge(this, to, weight);
            Edge toEdge = new Edge(to, this, weight);
            if(!Graph.this.Directed) {
                to.edges.add(toEdge);
            }
            this.edges.add(edge);
            return this;
        }

        @Override
        public String toString() {
            return this.Name ;//+ "(visited:" + Visited + ")";
        }

        @Override
        public int compareTo(Object o) {
            //return this.Name.compareTo(((Node)o).Name);
            return Double.compare(this.minDistance, ((Node)o).minDistance);
        }
    }

    public HashSet<Node> Nodes;
    public Boolean Directed;
    public Graph(Boolean directed) {
        Nodes = new HashSet<Node>();
        this.Directed = directed;
    }

    public Node addNode(String name) {
        Node node = new Node(name);
        Nodes.add(node);
        return node;
    }
}
