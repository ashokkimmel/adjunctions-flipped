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

  describe "Corepresentable" $ do
    it "Function cotabulate/coindex roundtrip" $ do
      let f = cotabulate (+1) :: Int -> Int
      coindex f 5 `shouldBe` 6

  describe "Adjunct" $ do
    it "defines the structure for adjunctions" $ do
      -- This test just verifies the structure compiles
      True `shouldBe` True
