-- Kamil Ba³dyga, 209184
import Monad (mzero)
import List (delete,(\\))
import System(getArgs)

-- sasiadami elementu na planszy, s± inne elementy, które nale¿± do
-- listy plansza (w przypadku programu bêd± to pola jeszcze nie zajête),
-- które le¿± na lewo,prawo,góra,dó³ od danego elementu (warunek parzystosc)
sasiad plansza (x,y) =
  [ (a,b) | (a,b) <-plansza, abs(a-x)<=1, abs(b-y)<=1,
    parzystosc (a+b) (x+y) ] where parzystosc a b = (even a&&odd b)||(odd a&&even b)
-- plansza to lista par wspolrzednych, takich, które nie znajduj± siê na li¶cie wejscie
-- wejscie jest w formacie [ ((x1,y1),(x2,y2)) ]
plansza wejscie n m =
  [ (x,y) | x<-[1..n], y<-[1..m], not ((x,y) `elem` zajete) ]
  where
    zajete = let (g1,g2) = unzip wejscie in g1++g2

-- rozwi±zanie zaczyna siê od wygenerowania planszy
-- wtedy stosujemy prostego dfs'a
-- dla ka¿dego elementu z listy wej¶ciowej, bierzemy pierwszy element pary
-- i przechodzimy ca³± planszê, a¿ natrafimy na drugi element pary.
-- ca³± ¶cie¿kê zapisujemy i wywo³ujemy na kolejnej parze wej¶ciowej, oraz na
-- planszy pomniejszonej o przed chwil± wygenerowan± ¶cie¿kê
solve pary n m =
  wszystkie pary (plansza pary n m) []
  where
    dfs _ [] _ acc = return acc
    dfs start wolne finisz acc =
       do
         s <- sasiad wolne start
         if s==finisz then return (reverse $ s:acc)
           else (dfs s (delete s wolne) finisz (s:acc))
    wszystkie [] [] acc = return acc
    wszystkie _  [] acc = mzero
    wszystkie pary wolne acc =
      do
        p@(start,finisz) <- pary
        dfs' <- dfs start (finisz:wolne) finisz [start]
        wszystkie (delete p pary) (wolne \\ dfs') (dfs':acc)

maly_test =
  let pary = [ ((5,1),(1,2)),((2,2),(1,3)),((2,3),(4,3))]
      in
   solve pary 5 4
---------------------------------------------------------
-- wczytywanie danych z pliku oparte na
-- http://ii.yebood.com/viewtopic.php?p=93192#93192
usunKropke :: String -> String
usunKropke s = init s

type ListaCzegosTam = [((Integer, Integer),(Integer, Integer))]

foo :: String -> (Integer, Integer,  [((Integer, Integer),(Integer, Integer))])
foo s = (read n, read k, read lista)
    where linijki     = map usunKropke (lines s)
          [n,k,lista] = linijki

main = do {
        args <- getArgs ;
        s <- readFile $ head args;
        let (n,m,l) = (foo s) in
        print $ solve l n m
      }
