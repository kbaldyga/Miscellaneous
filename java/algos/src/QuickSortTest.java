import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: kamil
 * Date: 18.12.2013
 * Time: 22:58
 * To change this template use File | Settings | File Templates.
 */
public class QuickSortTest {
    @Test
    public void SortWorks() {
        List<Integer> input = new ArrayList<Integer>();
        for(int i = 100 ; i > 0 ; i --) {
            input.add(i);
        }
        List<Integer> sorted = new QuickSort().Sort(input);
        for(int i= 0 ; i < input.size()-1; i ++) {
            assert(sorted.get(i) <= sorted.get(i+1));
        }
    }
    @Test
    public void AppendWorksForBase() {
        List<Integer> result = new QuickSort().Append(new ArrayList<Integer>(), new ArrayList<Integer>());
        assert(result.size() == 0);
    }

    @Test
    public void AppendWorks() {
        List<Integer> input = new ArrayList<Integer>() ;
        input.add(1);input.add(3); input.add(4); input.add(7);
        List<Integer> toAppend = new ArrayList<Integer>();
        toAppend.add(2);toAppend.add(9);toAppend.add(0);

        List<Integer> result = new QuickSort().Append(input, toAppend);
        for(int i = 0 ; i < result.size() ; i ++) {
            if(i < input.size()) {
                assert (result.get(i) == input.get(i));
            } else {
                assert(result.get(i) == toAppend.get(i - input.size()));
            }
        }
    }

    @Test
    public void SplitWorksForBaseCases() {
        List<List<Integer>> result = new QuickSort().Split(new ArrayList<Integer>(), 10);
        assert (result.size() == 2);
        assert (result.get(0).size() == 0);
        assert (result.get(1).size() == 0);
    }

    @Test
    public void SplitWorks() {
        List<Integer> input = new ArrayList<Integer>();
        for(int i = 100 ; i > 0 ; i --) {
            input.add(i);
        }

        List<List<Integer>> result = new QuickSort().Split(input, 50);
        for(int elem: result.get(0))  {
            assert (elem < 50);
        }
        for(int elem: result.get(1)) {
            assert (elem >= 50);
        }
    }

    @Test
    public void SortImperativeWorks() {
        int[] input = new int[101];
        for(int i = 100 ; i >= 0 ; i --) {
            input[100-i] = i;
        }
        int[] sorted = new QuickSort().SortImperative(input);
        for(int i= 0 ; i < input.length-1; i ++) {
            assert(sorted[i] <= sorted[i+1]);
        }
    }
}
