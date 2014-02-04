import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Stack;

/**
 * Created by kamil on 25.12.2013.
 */
public class TopologicalSort {
    class Edge {
        public Node from;
        public Node to;

        Edge(Node from, Node to) {
            this.from = from;
            this.to = to;
        }
    }

    class Node {
        public String Name ;
        public HashSet<Edge> inEdges;
        public HashSet<Edge> outEdges;

        public Node(String name) {
            this.Name = name;
            inEdges = new HashSet<Edge>();
            outEdges = new HashSet<Edge>();
        }

        public Node addEdge(Node outNode) {
            Edge newEdge = new Edge(this, outNode);
            outEdges.add(newEdge);
            outNode.inEdges.add(newEdge);
            return this;
        }

        @Override
        public String toString() {
            return this.Name;
        }
    }

    public List<Node> Sort() {
        List<Node> sortedNodes = new ArrayList<Node>();

        Node a = new Node("a");
        Node b = new Node("b");
        Node c = new Node("c");
        Node d = new Node("d");
        Node e = new Node("e");
        Node f = new Node("f");
        Node g = new Node("g");
        Node h = new Node("h");
        Node i = new Node("i");
        Node j = new Node("j");

        List<Node> allNodes = new ArrayList<Node>();
        allNodes.add(a);allNodes.add(b);allNodes.add(c);allNodes.add(d);allNodes.add(e);
        allNodes.add(f);allNodes.add(g);allNodes.add(h);allNodes.add(i);allNodes.add(j);

        a.addEdge(b).addEdge(d);
        b.addEdge(c).addEdge(d).addEdge(e);
        c.addEdge(f);
        d.addEdge(e).addEdge(g);
        e.addEdge(f).addEdge(g);
        //f
        g.addEdge(i).addEdge(f);
        h.addEdge(g).addEdge(j).addEdge(f);
        i.addEdge(j);

        Stack<Node> noInEdges = new Stack<Node>();
        for(Node n: allNodes) {
            if(n.inEdges.size() == 0) {
                noInEdges.add(n);
            }
        }

        while(!noInEdges.empty()) {
            Node current = noInEdges.pop();
            sortedNodes.add(current);
            for(Edge outEdge: current.outEdges) {
                outEdge.to.inEdges.remove(outEdge);
                if(outEdge.to.inEdges.size() == 0) {
                    noInEdges.push(outEdge.to);
                }
            }
        }

        for(Node n: sortedNodes) {
            System.out.println(n);
        }

        return sortedNodes;
    }
}
