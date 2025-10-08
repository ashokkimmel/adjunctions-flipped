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

-- Test CoRepresentable for tuple functor
testCoRepTuple :: Bool
testCoRepTuple =
  let x = ("key", 42 :: Integer)
      -- Test round-trip: coIndex . coTabulate = id
      roundTrip1 = coIndex (coTabulate x) == x
      -- Test round-trip: coTabulate . coIndex = id
      tuple = ("test", 99 :: Integer)
      roundTrip2 = coTabulate (coIndex tuple :: (String, Integer)) == tuple
  in roundTrip1 && roundTrip2

-- Test that tuple coTabulate/coIndex are identity
testTupleIdentity :: Bool
testTupleIdentity =
  let x = (True, "value")
      (r, a) = coTabulate x
  in r == True && a == "value" && coIndex (r, a) == x

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
  
  putStrLn "\nTesting CoRepresentable for (,) r functor..."
  
  if testCoRepTuple
    then putStrLn "✓ CoRepresentable (,) r round-trip tests passed"
    else putStrLn "✗ CoRepresentable (,) r round-trip tests failed"
  
  if testTupleIdentity
    then putStrLn "✓ Tuple coTabulate/coIndex are identity"
    else putStrLn "✗ Tuple identity test failed"
  
  let allPassed = testCoRepIdentity && testCoTabulateTuple && testCoIndexTuple 
                  && testCoRepTuple && testTupleIdentity
  
  if allPassed
    then putStrLn "\nAll tests passed!"
    else error "Some tests failed"

