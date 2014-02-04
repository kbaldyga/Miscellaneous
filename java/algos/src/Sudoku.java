import java.awt.*;

/**
 * Created by kamil on 27.12.2013.
 */
public class Sudoku {
    public int[][] Solve(int[][] input) {
        if(SolveBacktrack(input)) {
            return input;
        }
        return null;
    }

    public Point FindUnassignedField(int[][] grid) {
        for(int i = 0 ; i < 9 ; i ++) {
            for(int j = 0 ; j < 9 ; j ++) {
                if(grid[i][j] == 0) {
                    return new Point(i,j);
                }
            }
        }
        return null;
    }

    private Boolean SolveBacktrack(int[][] grid) {
        Point point = FindUnassignedField(grid);
        if(point == null) {
            return true;
        }

        for(int i = 1 ; i <= 9; i ++) {
            if(NoConflicts(point, grid, i)) {
                grid[point.row][point.col] = i;
                if(SolveBacktrack(grid)) {
                    return true;
                }
                grid[point.row][point.col] = 0;
            }
        }
        return false;
    }

    public Boolean NoConflicts(Point point, int[][] grid, int value) {
        for(int i = 0 ; i < 9 ; i ++) {
            if(grid[i][point.col] == value) return false;
            if(grid[point.row][i] == value) return false;
        }

        int initRow = (point.row / 3) * 3;
        int initCol = (point.col / 3) * 3;

        boolean taken[] = new boolean[10];
        for(int i = initRow ; i < initRow + 3;i++) {
            for(int j = initCol ; j < initCol + 3 ; j ++) {
                taken[grid[i][j]] = true;
            }
        }
        if(taken[value]) return false;
        return true;
    }

    public int[][] ParseProblem(String input) {
        int row = 0, col;
        int[][] grid = new int[9][9];
        for(String line: input.split("\n")) {
            col = 0;
            for(String number: line.split(" ")) {
                int value = Integer.parseInt(number);
                grid[row][col++] = value;
            }
            row ++;
        }
        return grid;
    }

    public class Point {
        int col, row;
        public Point(int row, int col) {
            this.col = col;
            this.row = row;
        }
    }
}
