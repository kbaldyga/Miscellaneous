import java.security.InvalidAlgorithmParameterException;

/**
 * Created by kamil on 22.12.2013.
 */
public class BST {
    class Node {

        Node(int val) {
            value = val;
        }
        public int value;
        public Node left;
        public Node right;

        @Override
        public String toString() {
            return (left != null ? "(" + left.toString() + ")" : "" ) + value + (right != null ? "(" + right.toString() + ")" : "");
        }
    }

    public Node Root;

    public void Insert(int value) {
        if(Root == null) {
            Root = new Node(value);
        } else {
            Insert(new Node(value), Root);
        }
    }

    public void Insert(Node value, Node node) {
        if(value.value < node.value) {
            if(node.left == null) {
                node.left = value;
            } else {
                Insert(value, node.left);
            }
        } else {
            if(node.right == null) {
                node.right = value;
            } else {
                Insert(value, node.right);
            }
        }
    }

    public void Delete(int value) {
        if(Root.left == null && Root.right == null && Root.value == value) {
            Root = null;
        } else {
            Delete(value, Root);
        }
    }

    public void Delete(int value, Node node) {

        if(value < node.value && node.left != null) {
            Delete(value, node.left);
        } else if(value > node.value && node.right != null) {
            Delete(value, node.right);
        } else {
            if(node.left == null) {
                node = node.right;
            } else if(node.right == null) {
                node = node.left;
            } else {
                Insert(node.left, node.right);
            }
        }
//        if(node.left.value == value) {
//            if(node.left.left == null && node.left.right == null) {
//                node.left = null;
//            }
//        } else if(node.right.value == value) {
//            if(node.right.left == null && node.right.right == null) {
//                node.right = null;
//            }
//        } else if(value < node.value && node.left != null) {
//            Delete(value, node.left);
//        } else if(value > node.value && node.right != null){
//            Delete(value, node.right);
//        }
    }

    @Override
    public String toString() {
        return Root != null ? Root.toString() : "";
    }
}

