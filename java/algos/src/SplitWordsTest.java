import org.junit.Test;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

/**
 * Created by kamil on 09.01.2014.
 */
public class SplitWordsTest {
    @Test
    public void SimpleSplitPerWord() {
        HashSet<String> dictionary = new HashSet<String>();
        dictionary.add("peanut");
        dictionary.add("butter");
        dictionary.add("pea");
        dictionary.add("nut");
        String input = "peanutbutter";

        List<List<String>> solutions = new ArrayList<List<String>>();
        new SplitWords().SplitPerWord2(dictionary, input, 0, solutions);
        for(int i = 0 ; i < solutions.size() ; i ++) {
            System.out.print("Solution ");
            System.out.println(i);
            for(int j = 0 ; j < solutions.get(i).size() ; j ++) {
                System.out.println(solutions.get(i).get(j));
            }
        }
    }
}
