module Main (main) where

import Data.Functor.CoRep
import Data.Functor.Identity

-- Test that CoRepresentable laws hold for Identity
testCoRepIdentity :: Bool
testCoRepIdentity = 
  let x = Identity 42
      -- Test round-trip: coIndex . coTabulate = id
      roundTrip1 = coIndex (coTabulate x) == x
      -- Test round-trip: coTabulate . coIndex = id
      tuple = ((), 42 :: Integer)
      roundTrip2 = coTabulate (coIndex tuple :: Identity Integer) == tuple
  in roundTrip1 && roundTrip2

-- Test that coTabulate produces tuples
testCoTabulateTuple :: Bool
testCoTabulateTuple =
  let x = Identity "hello"
      (unit, str) = coTabulate x
  in unit == () && str == "hello"

-- Test that coIndex consumes tuples
testCoIndexTuple :: Bool
testCoIndexTuple =
  let tuple = ((), 123 :: Integer)
      Identity val = coIndex tuple
  in val == 123

main :: IO ()
main = do
  putStrLn "Testing CoRepresentable for Identity..."
  
  if testCoRepIdentity
    then putStrLn "✓ CoRepresentable Identity round-trip tests passed"
    else putStrLn "✗ CoRepresentable Identity round-trip tests failed"
  
  if testCoTabulateTuple
    then putStrLn "✓ coTabulate produces correct tuples"
    else putStrLn "✗ coTabulate tuple test failed"
  
  if testCoIndexTuple
    then putStrLn "✓ coIndex consumes correct tuples"
    else putStrLn "✗ coIndex tuple test failed"
  
  if testCoRepIdentity && testCoTabulateTuple && testCoIndexTuple
    then putStrLn "\nAll tests passed!"
    else error "Some tests failed"

