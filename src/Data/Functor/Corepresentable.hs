{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RankNTypes #-}

-- | Corepresentable functors - the dual of Representable
--
-- A corepresentable functor is one that is isomorphic to @(->) r@ for some type @r@.
-- This is the dual of Representable functors.
module Data.Functor.Corepresentable
  ( Corepresentable(..)
  , cotabulate
  , coindex
  ) where

-- | Corepresentable functors - dual to Representable
--
-- A functor @f@ is Corepresentable if it is isomorphic to @(->) (CorRep f)@
--
-- Laws:
-- @
-- cotabulate . coindex ≡ id
-- coindex . cotabulate ≡ id
-- @
class Functor f => Corepresentable f where
  -- | The representation type
  type CorRep f
  
  -- | Convert from the representation
  -- The dual of 'tabulate'
  cotabulate :: (CorRep f -> a) -> f a
  
  -- | Convert to the representation
  -- The dual of 'index'
  coindex :: f a -> CorRep f -> a

-- | Instance for functions - they are trivially Corepresentable
instance Corepresentable ((->) r) where
  type CorRep ((->) r) = r
  cotabulate = id
  coindex = id
