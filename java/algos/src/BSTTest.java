import org.junit.Test;

/**
 * Created by kamil on 22.12.2013.
 */
public class BSTTest {
    @Test
    public void InsertWorks() {
        BST tree = new BST() ;
        tree.Insert(10);
        tree.Insert(9);
        tree.Insert(12);
        tree.Insert(11);
        assert(tree.Root.value == 10);
        assert(tree.Root.left.value == 9);
        assert(tree.Root.right.value == 12);
    }

    @Test
    public void DeleteWorks() {
        BST tree = new BST() ;
        tree.Insert(10);
        tree.Insert(9);
        tree.Insert(12);
        tree.Insert(11);
        tree.Delete(12);
        System.out.println(tree.Root.toString());
        assert(tree.Root.value == 10);
        assert(tree.Root.left.value == 9);
        assert(tree.Root.right.value == 11);
    }
}
