{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE RankNTypes #-}

module Data.Functor.CoRep
  ( CoRepresentable(..)
  ) where

import Data.Functor.Identity

-- | A 'CoRepresentable' functor is the dual of a representable functor.
-- While representable functors are isomorphic to @CoRep f -> a@,
-- corepresentable functors are isomorphic to @(CoRep f, a)@.
--
-- The key insight is that the conversion functions work with tuples:
-- * 'coTabulate' converts from @f a@ to @(CoRep f, a)@
-- * 'coIndex' converts from @(CoRep f, a)@ to @f a@
--
-- Laws:
-- @
-- coIndex . coTabulate = id
-- coTabulate . coIndex = id
-- @
class Functor f => CoRepresentable f where
  type CoRep f
  
  -- | Convert from the functor to a tuple
  coTabulate :: f a -> (CoRep f, a)
  
  -- | Convert from a tuple to the functor
  coIndex :: (CoRep f, a) -> f a

-- | Identity is corepresentable with unit as its corep
instance CoRepresentable Identity where
  type CoRep Identity = ()
  coTabulate (Identity a) = ((), a)
  coIndex ((), a) = Identity a

