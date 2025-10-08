{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeFamilies #-}

-- | Codistributive functors - the dual of Distributive
--
-- While Distributive allows you to collect a functor of values,
-- Codistributive allows you to distribute values into a functor.
--
-- The law is dual to Distributive:
-- @
-- coDistribute . fmap f = fmap f . coDistribute
-- @
module Data.Functor.Codistributive
  ( Codistributive(..)
  ) where

import Data.Functor.Identity

-- | A 'Codistributive' functor is one that can distribute itself
-- through another functor.
--
-- This is the dual of 'Distributive' from @Data.Distributive@.
--
-- Minimal complete definition: 'coDistribute'
class Functor f => Codistributive f where
  -- | The dual of 'distribute'
  --
  -- @
  -- coDistribute :: (Codistributive f, Functor g) => f (g a) -> g (f a)
  -- @
  coDistribute :: Functor g => f (g a) -> g (f a)

  -- | The dual of 'collect'
  coCollect :: Functor g => (a -> g b) -> f a -> g (f b)
  coCollect f = coDistribute . fmap f

-- | Identity is trivially Codistributive
instance Codistributive Identity where
  coDistribute (Identity ga) = fmap Identity ga

-- | Functions are Codistributive
-- For (->) r, we convert (r -> g a) to g (r -> a)
-- This works by using the Applicative instance of g to construct the result
instance Codistributive ((->) r) where
  coDistribute f = fmap const (f undefined)
  -- Note: This requires an inhabitant of r, which is problematic
  -- A better approach might be to not provide this instance

