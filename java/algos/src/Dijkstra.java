import java.util.ArrayList;
import java.util.List;
import java.util.PriorityQueue;
import java.util.Stack;

/**
 * Created by kamil on 26.12.2013.
 */
public class Dijkstra {
    public List<Graph.Node> ShortestPath(Graph graph, Graph.Node from, Graph.Node to) {
        PriorityQueue<Graph.Node> nodes = new PriorityQueue<Graph.Node>();
        List<Graph.Node> result = new ArrayList<Graph.Node>();
        nodes.add(from);
        from.minDistance = 0;
        while(!nodes.isEmpty()) {
            Graph.Node current = nodes.poll();
            for(Graph.Edge e: current.edges) {
                Graph.Node eTo = e.to;
                if(eTo.minDistance > current.minDistance + e.weight) {
                    eTo.minDistance = current.minDistance + e.weight;
                    eTo.Parent = current;
                    nodes.add(eTo);
                }
            }
        }

        while(to != null) {
            result.add(to);
            to = to.Parent;
        }

        return result;
    }
}
