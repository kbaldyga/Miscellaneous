import org.junit.Test;

import java.util.List;

/**
 * Created by kamil on 26.12.2013.
 */
public class DijkstraTest {
    @Test
    public void EmptySetWorks() {
        Graph g = new Graph(true);
        Dijkstra d = new Dijkstra();
        List<Graph.Node> shortestPath = d.ShortestPath(g, g.new Node("a"), g.new Node("b"));
        assert(shortestPath.size() == 1);
    }

    @Test
    public void OneEdgeWorks() {
        Graph g = new Graph(true);
        Graph.Node n1 = g.addNode("london");
        Graph.Node n2 = g.addNode("amsterdam");
        n1.addEdge(n2, 6);

        Dijkstra d = new Dijkstra();
        List<Graph.Node> path = d.ShortestPath(g, n1, n2);
        assert (path.size() == 2 );
    }

    @Test
    public void MultipleNodesWorks() {
        Graph g = new Graph(true);
        Graph.Node london = g.addNode("london");
        Graph.Node amsterdam = g.addNode("amsterdam");
        Graph.Node wroclaw = g.addNode("wroclaw");
        Graph.Node paris = g.addNode("paris");
        Graph.Node rome = g.addNode("rome");

        london.addEdge(amsterdam, 10);
        london.addEdge(paris, 5);
        london.addEdge(rome, 15);

        amsterdam.addEdge(wroclaw, 9);
        amsterdam.addEdge(rome, 4);
        amsterdam.addEdge(paris, 3);

        wroclaw.addEdge(amsterdam, 5);
        wroclaw.addEdge(rome, 5);
        wroclaw.addEdge(london, 5);

        paris.addEdge(rome, 3);
        paris.addEdge(amsterdam, 3);

        rome.addEdge(wroclaw, 5);

        Dijkstra d = new Dijkstra();
        List<Graph.Node> shortestPath = d.ShortestPath(g, london, amsterdam);
        assert(shortestPath.size() == 3);
        assert (shortestPath.get(0) == amsterdam);
        assert (shortestPath.get(1) == paris);
        assert (shortestPath.get(2) == london);

        shortestPath = d.ShortestPath(g, london, wroclaw);
        assert(shortestPath.size() == 4);
        assert (shortestPath.get(0) == wroclaw);
        assert (shortestPath.get(1) == rome);
        assert (shortestPath.get(2) == paris);
        assert (shortestPath.get(3) == london);

    }

}
