import org.junit.Test;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * Created with IntelliJ IDEA.
 * User: kamil
 * Date: 18.12.2013
 * Time: 19:53
 * To change this template use File | Settings | File Templates.
 */
public class MergeSortTest {
    @Test
    public void SortWorks() {
        List<Integer> input = new ArrayList<Integer>();
        for(int i = 100 ; i > 0 ; i --) {
            input.add(i);
        }
        List<Integer> sorted = new MergeSort().Sort(input);
        for(int i= 0 ; i < input.size()-1; i ++) {
            assert(sorted.get(i) <= sorted.get(i+1));
        }
    }
    @Test
    public void MergeNotBoundException2() {
        List<Integer> first = new ArrayList<Integer>();
        List<Integer> second = new ArrayList<Integer>();

        first.add(1);first.add(2);first.add(3);

        second.add(3);second.add(4);second.add(5);second.add(6);second.add(9);

        List<Integer> merged = new MergeSort().Merge(second, first);

        for(int i = 0 ; i < merged.size()-1 ; i ++) {
            assert(merged.get(i) <= merged.get(i));
        }
    }

    @Test
    public void MergeNotBoundException() {
        List<Integer> first = new ArrayList<Integer>();
        List<Integer> second = new ArrayList<Integer>();

        first.add(1);first.add(2);first.add(3);

        second.add(3);second.add(4);second.add(5);second.add(6);second.add(9);

        List<Integer> merged = new MergeSort().Merge(first, second);

        for(int i = 0 ; i < merged.size()-1 ; i ++) {
            assert(merged.get(i) <= merged.get(i));
        }
    }


    @Test
    public void MergeWorks() {
        List<Integer> first = new ArrayList<Integer>();
        List<Integer> second = new ArrayList<Integer>();

        first.add(2);first.add(5);first.add(7);

        second.add(3);second.add(4);second.add(5);second.add(6);second.add(9);

        List<Integer> merged = new MergeSort().Merge(first, second);

        for(int i = 0 ; i < merged.size()-1 ; i ++) {
            assert(merged.get(i) <= merged.get(i));
        }
    }

    @Test
    public void MergeWorksForSimpleElements() {
        List<Integer> merged = new MergeSort().Merge(new ArrayList<Integer>(), new ArrayList<Integer>());
        assert(merged.size() == 0);
    }

    @Test
    public void SplitWorks() {
        List<Integer> input = new ArrayList<Integer>();
        for(int i = 100 ; i > 0 ; i --) {
            input.add(i);
        }

        List<List<Integer>> split = new MergeSort().Split(input);
        assert(split.size() == 2);
        assert(Math.abs(split.get(0).size()-split.get(1).size()) <= 1);
    }

    @Test
    public void SplitWorksOnEmptyList() {
        List<Integer> empty = new ArrayList<Integer>();
        List<List<Integer>> splitted = new MergeSort().Split(empty);
        assert(splitted.size() == 2);
        assert(splitted.get(0).size() == 0);
        assert(splitted.get(1).size() == 0);

    }
}
