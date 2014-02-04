import java.util.*;

/**
 * Created by kamil on 25.12.2013.
 */
public class DFS {
    class Edge {
        public Node from;
        public Node to;
        public Edge(Node from, Node to) {
            this.to = to;
            this.from = from;
        }
        @Override
        public String toString() {
            return from.Name + " ==> " + to.Name;
        }
    }

    class Node implements Comparable {
        public String Name ;
        public HashSet<Edge> edges;
        public Boolean Visited;

        public Node(String name) {
            this.Name = name;
            edges = new HashSet<Edge>();
            Visited = false;
        }

        public Node addEdge(Node to) {
            Edge edge = new Edge(this, to);
            Edge toEdge = new Edge(to, this);
            to.edges.add(toEdge);
            this.edges.add(edge);
            return this;
        }

        @Override
        public String toString() {
            return this.Name ;//+ "(visited:" + Visited + ")";
        }

        @Override
        public int compareTo(Object o) {
            return this.Name == ((Node)o).Name ? 0 : 1;
        }
    }

    public void TestRun() {
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
        Node k = new Node("k");
        Node l = new Node("l");
        Node m = new Node("m");
        Node n = new Node("n");
        Node o = new Node("o");
        Node p = new Node("p");
        Node q = new Node("q");
        Node r = new Node("r");
        Node s = new Node("s");
        Node t = new Node("t");
        Node u = new Node("u");

        a.addEdge(b);
        b.addEdge(c);
        c.addEdge(d).addEdge(f);
        d.addEdge(r);
        r.addEdge(s);s.addEdge(t);
        f.addEdge(g);
        f.addEdge(h);
        h.addEdge(i);
        i.addEdge(j);
        j.addEdge(k);
        k.addEdge(l).addEdge(m);
        m.addEdge(n);
        n.addEdge(o);
        o.addEdge(p);
        p.addEdge(q);
        q.addEdge(u);

        DFS(a, u);
        System.out.println("result");
        for(Node node: result) {
            System.out.println(node);
        }
    }

    public void DFS(Node node, Node finish) {
        //Queue<Node> queue = new PriorityQueue<Node>() ;
        Stack<Node> queue = new Stack<Node>();
        queue.add(node);
        while(!queue.isEmpty()) {
            System.out.print(node.Name);
            node.Visited = true;
            if(node == finish) {
                while(!queue.isEmpty()) {
                    result.add(queue.pop());
                }
                return;
            }
            for(Edge e: node.edges) {
                if(!e.to.Visited) {
                    queue.add(e.to);
                }
            }
            node = queue.pop();
        }
    }

//    public Boolean DFS(Node node, Node finish) {
//        node.Visited = true;
//        for(Edge edge: node.edges) {
//            if(edge.to == finish) {
//                return true;
//            }
//            if(edge.to != finish && !edge.to.Visited) {
//                result.add(edge.to);
//                Boolean exit = DFS(edge.to, finish);
//                if(exit) { return true;}
//            }
//        }
//        result.remove(node);
//        return false;
//    }

    List<Node> result = new ArrayList<Node>();
}

// start a
// end u
/*
AxB  RxxxS
  CxxD   x           QxU
  x      T       OxxxP
  FxxxG       MxN
  x      JxxxxK
  x      xx   x
  HxxxxxxI    L



   */