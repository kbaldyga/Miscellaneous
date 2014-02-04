import java.util.ArrayList;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: kamil
 * Date: 18.12.2013
 * Time: 22:57
 * To change this template use File | Settings | File Templates.
 */
public class QuickSort {
    public List<Integer> Sort(List<Integer> input)
    {
        if(input.size() == 0)
            return new ArrayList<Integer>();
        if(input.size() == 1)
            return input;

        int pivot = input.get(0);
        input.remove(0);
        List<List<Integer>> splitted = Split(input, pivot);
        List<Integer> first = splitted.get(0);
        first.add(pivot);

        return Append(Sort(first), Sort(splitted.get(1)));
    }

    public List<Integer> Append(List<Integer> input, List<Integer> toAppend) {
        List<Integer> result = new ArrayList<Integer>();
        for(int elem: input) {
            result.add(elem);
        }
        for(int elem : toAppend) {
            result.add(elem);
        }
        return result;
    }

    public List<List<Integer>> Split(List<Integer> input, Integer pivot) {
        List<Integer> lower = new ArrayList<Integer>();
        List<Integer> greater = new ArrayList<Integer>();

        for(int elem : input ) {
            if(elem < pivot) {
                lower.add(elem);
            } else {
                greater.add(elem);
            }
        }

        List<List<Integer>> result = new ArrayList<List<Integer>>();
        result.add(lower);
        result.add(greater);
        return result;
    }

    public int[] SortImperative(int[] input) {
        return SortImperative(input, 0, input.length -1);
    }

    public int[] SortImperative(int[] input, int low, int high) {
        if(input.length == 0 || input.length == 1) {
            return input;
        }

        int medium = (low + high) / 2;
        int pivot = input[medium];

        while(low < high) {
            while(input[low] < pivot) {
                low ++;
            }
            while(input[high] >= pivot) {
                high --;
            }
            if(low < high) {
                int tmp = input[high];
                input[high] = input[low];
                input[low] = tmp;
            }
        }

        if(low < medium) {
            SortImperative(input, low, medium);
        }
        if(medium < high) {
            SortImperative(input, medium, high);
        }

        return input;
    }

}

// quick sort
// qsort [] = []
// qsort x:xs = qsort [ys | ys <- xs `filter` \y -> y < x] @ [x] @ qsort [ys | ys <- xs `filter` \y -> y >= x]


// [1,2,6,9,3,5,1] 4