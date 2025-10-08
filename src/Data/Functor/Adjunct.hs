{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE RankNTypes #-}

-- | Adjunctions where the left adjoint is Corepresentable and right is Representable
module Data.Functor.Adjunct
  ( Adjunct(..)
  , AdjunctT(..)
  , runAdjunctT
  ) where

import Control.Monad (ap, liftM)
import Control.Comonad
import Data.Functor.Corepresentable
import Data.Functor.Rep (Representable(..), index, tabulate)

-- | Adjunctions with Corepresentable left adjoint and Representable right adjoint
--
-- Laws (adjunction laws):
-- @
-- leftAdjunct unit = id
-- rightAdjunct counit = id
-- unit . leftAdjunct f = fmap f
-- counit . rightAdjunct g = fmap g
-- @
class (Corepresentable f, Representable u) => Adjunct f u where
  -- | The unit of the adjunction
  unit :: a -> u (f a)
  
  -- | The counit of the adjunction
  counit :: f (u a) -> a
  
  -- | Left adjunct
  leftAdjunct :: (f a -> b) -> a -> u b
  leftAdjunct f = fmap f . unit
  
  -- | Right adjunct
  rightAdjunct :: (a -> u b) -> f a -> b
  rightAdjunct f = counit . fmap f

-- | The adjunction monad transformer
--
-- This is similar to the standard adjunction monad, but using our Adjunct class
newtype AdjunctT f u m a = AdjunctT { getAdjunctT :: u (f (m a)) }

-- | Run the AdjunctT transformer
runAdjunctT :: AdjunctT f u m a -> u (f (m a))
runAdjunctT = getAdjunctT

-- Functor instance
instance (Functor f, Functor u, Functor m) => Functor (AdjunctT f u m) where
  fmap f (AdjunctT ufa) = AdjunctT (fmap (fmap (fmap f)) ufa)

-- Applicative instance
instance (Adjunct f u, Monad m) => Applicative (AdjunctT f u m) where
  pure a = AdjunctT (unit (pure a))
  (<*>) = ap

-- Monad instance using the Adjunct class
instance (Adjunct f u, Monad m) => Monad (AdjunctT f u m) where
  return = pure
  AdjunctT ufa >>= f = AdjunctT $ fmap bind ufa
    where
      -- bind :: f (m a) -> f (m b)
      bind fma = fma >>= \ma -> ma >>= \a -> counit (fmap (\b -> return b) (getAdjunctT (f a)))

-- Comonad instance using the Adjunct class
instance (Adjunct f u, Comonad m) => Comonad (AdjunctT f u m) where
  extract (AdjunctT ufa) = counit (fmap extract ufa)
  
  duplicate (AdjunctT ufa) = AdjunctT $ fmap extend' ufa
    where
      extend' fa = unit (fmap (\ma -> AdjunctT (unit (fmap (const ma) fa))) fa)
