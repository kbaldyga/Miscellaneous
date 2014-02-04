import org.junit.Test;

/**
 * Created by kamil on 27.12.2013.
 */
public class SudokuTest {
    @Test
    public void testSolve() throws Exception {
        Sudoku s = new Sudoku() ;
        int[][] solution = s.Solve(s.ParseProblem(Sample2));

        for(int i = 0 ; i < 9 ; i ++) {
            for(int j = 0 ; j < 9  ; j ++ ) {
                System.out.print(solution[i][j] + " ");
            }
            System.out.println();
        }
    }

    @Test
    public void testNoConflicts() throws Exception {
        Sudoku s = new Sudoku();
        int[][] grid = s.ParseProblem(Sample1);

        assert(!s.NoConflicts(s.new Point(1,0), grid, 1));
        assert(!s.NoConflicts(s.new Point(1,0), grid, 3));
        assert(s.NoConflicts(s.new Point(1,0), grid, 8));
        assert(!s.NoConflicts(s.new Point(1,0), grid, 2));

        assert(!s.NoConflicts(s.new Point(8,8), grid, 1));
    }

    @Test
    public void testParseProblem() {
        Sudoku s = new Sudoku();
        int[][] grid = s.ParseProblem(Sample1);
        assert(grid[0][0] == 1);
        assert(grid[0][8] == 9);
        assert(grid[6][0] == 4);
        assert(grid[6][8] == 3);

    }

    private static final String Sample1 =
            "1 2 3 4 5 6 7 8 9\n"+
            "0 6 0 0 0 0 0 3 0\n"+
            "0 7 0 0 0 0 0 4 0\n"+
            "7 8 9 1 2 3 4 5 6\n"+
            "0 0 0 0 0 0 0 0 0\n"+
            "0 0 0 0 0 0 0 0 0\n"+
            "4 5 6 7 8 9 1 2 3\n"+
            "0 0 0 0 0 0 0 0 0\n"+
            "0 0 0 0 0 0 0 0 0";

    private static final String Sample2 =
            "0 6 0 1 0 4 0 5 0\n" +
            "0 0 8 3 0 5 6 0 0\n" +
            "2 0 0 0 0 0 0 0 1\n" +
            "8 0 0 4 0 7 0 0 6\n" +
            "0 0 6 0 0 0 3 0 0\n" +
            "7 0 0 9 0 1 0 0 4\n" +
            "5 0 0 0 0 0 0 0 2\n" +
            "0 0 7 2 0 6 9 0 0\n" +
            "0 4 0 5 0 8 0 7 0";
}
