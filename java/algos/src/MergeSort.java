import java.util.ArrayList;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: kamil
 * Date: 18.12.2013
 * Time: 19:49
 * To change this template use File | Settings | File Templates.
 */
public class MergeSort {
    public List<Integer> Sort(List<Integer> input) {
        if(input.size() == 0)
            return new ArrayList<Integer>();
        if(input.size() == 1)
            return input;
        List<List<Integer>> splitted = Split(input);
        return Merge(Sort(splitted.get(0)), Sort(splitted.get(1)));
    }

    public List<Integer> Merge(List<Integer> first, List<Integer> second) {
        if(first.size() == 0)
            return second;
        if(second.size() == 0)
            return first;
        List<Integer> result = new ArrayList<Integer>();
        int i = 0, j = 0;
        while(i+j < first.size() + second.size()) {
            if(i == first.size()) {
                result.add(second.get(j++));
            } else if(j == second.size()) {
                result.add(first.get(i++));
            } else if(first.get(i) < second.get(j)) {
                result.add(first.get(i++));
            } else {
                result.add(second.get(j++));
            }
        }

        return result;
    }

    public List<List<Integer>> Split(List<Integer> input) {
        List<Integer> first = new ArrayList<Integer>();
        List<Integer> second = new ArrayList<Integer>();

        for(int i = 0 ; i < input.size() ; i ++) {
            if(i%2 == 0) {
                first.add(input.get(i));
            } else {
                second.add(input.get(i));
            }
        }

        List<List<Integer>> result = new ArrayList<List<Integer>>();
        result.add(first);
        result.add(second);
        return result;
    }

}
