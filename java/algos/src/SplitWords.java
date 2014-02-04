import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

/**
 * Created by kamil on 08.01.2014.
 */
public class SplitWords {
    public List<List<String>> SplitPerWordMultipleSolutions(HashSet<String> dictionary, String inputWord) {
         return null;
    }

    public void SplitPerWord2(HashSet<String> dictionary, String inputWord, int startIndex, List<List<String>> solutions) {
        List<String> words = new ArrayList<String>();
        int i = startIndex;
        while(true) {
            if(inputWord.length() == 0 || inputWord.length() <= i-1) {
                if(words.size() > 0) {
                    solutions.add(words);
                }
                return;
            }
            String word = inputWord.substring(0, i);
            if(dictionary.contains(word)) {
                words.add(word);
                SplitPerWord2(dictionary, inputWord, word.length()+1, solutions);
                inputWord = inputWord.substring(i);
                i=0;
            }
            i++;
        }
    }

}
