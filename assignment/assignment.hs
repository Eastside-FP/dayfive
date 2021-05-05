import Data.Char(intToDigit)

-- In the first part of this assignment you'll be implementing 
-- functions that mimic the behavior of standard Haskell
-- library functions. Each section will make use of `foldl`
-- (remembering that `foldl` can return a list if you pass it a list
-- as the initial value, and build that list in the reducing function)

-- Remember to uncomment the tests for each section.

-------
-- 1 --
-------
-- The build in function `reverse` takes a list and returns
-- a new list with the elements in reverse order.
--
-- Implement a version called `myreverse` using `foldl`.

swap :: [a] -> a -> [a] 
swap h r = [r] ++ h
myreverse :: [a] -> [a]
myreverse [] = []
myreverse (l:ls) = foldl swap [l] ls


-------
-- 2 --
-------
-- The `filter` function takes a predicate function and a list. It returns
-- a new list containing only the elements of the original for which the
-- predicate returns `True`. Implement `myfilter` using `foldl`. (Hint: you 
-- might need to use `++` rather than `:` to build the result)

--conditionalAttach creates functions with 
conditionalAttach :: (a -> Bool) -> [a] -> a -> [a]
conditionalAttach condition lis a = 
  if(condition a)
    then lis ++ [a] 
    else lis
myfilter :: (a -> Bool) -> [a] -> [a]
myfilter check items = foldl (conditionalAttach check) [] items 


-------
-- 3 --
-------
-- The `and` and `or` functions take a list of booleans.
-- `and` returns true only if all the values are true.
-- `or` returns true if any are true.
--
-- (Side note: when implementing your functions, did you get a wavy
-- line suggestion say that you could replace your code with the
-- library function. Stop for a minute and see if you can work
-- out how Haskell worked this out.)

stillTrue :: Bool -> Bool -> Bool
stillTrue old curr = 
  if(old && curr)
    then True
    else False
myand:: [ Bool ] -> Bool
myand bools = foldl stillTrue True bools   

anyTrue :: Bool -> Bool -> Bool
anyTrue old curr =
  if(old || curr)
    then True
    else False

myor:: [ Bool ] -> Bool
myor bools = foldl anyTrue False bools


----------------------------------------------
--
-- Now we're going to play with some simple data types.


-------
-- 4 --
-------
-- Our application handles measurements in both millimeters (MM) and inches (IN)
-- write a data type named Measure that lets you specify a measurement using
-- either unit. Be sure to derive Eq and Show.

data Measure = MM Float| IN Float 
                  deriving (Show, Eq)

-- Now write a function that takes a measurement. If it is already in millimeters,
-- return it. Otherwise convert the measurement in inches to millimeters and
-- return a new metric Measure value. (Use 25.4 as the conversion factor)

ensureMetric:: Measure -> Measure
ensureMetric (MM distance) = MM distance
ensureMetric (IN distance) = (MM (distance*25.4))

-- Finally use `map` to take a list of Measure values, and return a new
-- list where all measurements are in metric.

listToMetric:: [ Measure ] -> [ Measure ]
listToMetric measurements = map ensureMetric measurements


-----------------------------------
-- don't change below this point --

test :: (Eq a, Show a) => [Char] -> a -> a -> IO ()
test testNo got expected
  | got == expected =
      print (testNo ++ " OK   got expected value " ++ show expected)
  | otherwise =
      print (testNo ++ " FAIL expected " ++ show expected ++ " but got " ++ show got)


main = do

  test "1a" (myreverse []::[Int]) []
  test "1b" (myreverse [1])       [1]
  test "1c" (myreverse [1,2])     [2,1]
  test "1d" (myreverse "cat")     "tac"

  test "2a" (myfilter (>3) [1..6]) [4,5,6]
  test "2b" (myfilter even [1..6]) [2,4,6]
  test "2c" (myfilter (<0) [1..6]) []
  
  test "3a" (myand [True, True])   True
  test "3b" (myand [True, False])  False
  test "3c" (myand [False, True])  False
  test "3d" (myand [False, False]) False
  test "3e" (myand [True])         True

  test "3m" (myor  [True, True])   True
  test "3n" (myor  [True, False])  True
  test "3o" (myor  [False, True])  True
  test "3p" (myor  [False, False]) False
  test "3q" (myor  [True])         True

  test "4a" (ensureMetric (MM 16)) (MM 16)
  test "4b" (ensureMetric (IN 0))  (MM 0)
  test "4c" (ensureMetric (IN 1))  (MM 25.4)
  test "4c" (ensureMetric (IN 8))  (MM (8*25.4))
  test "4d" (listToMetric [ MM 1, IN 2, MM 3, IN 4]) [ MM 1, MM 50.8, MM 3, MM 101.6]
  print "Done"

  