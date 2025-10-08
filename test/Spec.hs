module Main where

import Test.Hspec
import Data.Functor.Codistributive
import Data.Functor.Corepresentable
import Data.Functor.Adjunct
import Data.Functor.Identity

main :: IO ()
main = hspec $ do
  describe "Codistributive" $ do
    it "Identity coDistribute works" $ do
      let result = coDistribute (Identity [1, 2, 3])
      result `shouldBe` [Identity 1, Identity 2, Identity 3]
    
    it "Function coDistribute works" $ do
      let f = \x -> if x then Just 1 else Just 2
      let result = coDistribute f True
      result `shouldBe` Just 1

  describe "Corepresentable" $ do
    it "Function cotabulate/coindex roundtrip" $ do
      let f = cotabulate (+1) :: Int -> Int
      coindex f 5 `shouldBe` 6
