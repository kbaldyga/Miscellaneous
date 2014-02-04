import org.junit.Test;

/**
 * Created by kamil on 26.12.2013.
 */
public class GraphTest {
    @Test
    public void EdgeComparatorWorks() {
        Graph g = new Graph(true);
        Graph.Node n1 = g.new Node("a");
        Graph.Node n2 = g.new Node("b");
        Graph.Node n3 = g.new Node("c");

        Graph.Edge e1 = g.new Edge(n1, n2, 1);
        Graph.Edge e2 = g.new Edge(n1, n3, 2);
        assert(e1.compareTo(e2) == -1);
        assert(e1.compareTo(e1) == 0);
        assert(e2.compareTo(e1) == 1);
    }

//    @Test
//    public void NodeComparatorWorks() {
//        Graph g = new Graph();
//        Graph.Node n1 = g.new Node("a");
//        Graph.Node n2 = g.new Node("b");
//
//        assert(n1.compareTo(n2) == -1);
//        assert(n1.compareTo(n1) == 0);
//        assert(n2.compareTo(n1) == 1);
//    }
}
