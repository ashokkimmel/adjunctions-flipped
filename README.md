# adjunctions-flipped

A Haskell library providing classes and transformers for adjunctions with Codistributive and Corepresentable functors.

## Overview

This library provides:

1. **Codistributive** - A class dual to Distributive that allows distributing a functor through another
   - `coDistribute :: (Codistributive f, Functor g) => f (g a) -> g (f a)`

2. **Corepresentable** - A class for functors that are isomorphic to `(->) r` for some type `r`
   - `cotabulate :: (CorRep f -> a) -> f a`
   - `coindex :: f a -> CorRep f -> a`

3. **Adjunct** - An adjunction class where the left adjoint is Corepresentable and the right is Representable
   - `unit :: a -> u (f a)`
   - `counit :: f (u a) -> a`
   - `leftAdjunct :: (f a -> b) -> a -> u b`
   - `rightAdjunct :: (a -> u b) -> f a -> b`

4. **AdjunctT** - A monad transformer using the Adjunct class
   - Provides both Monad and Comonad instances (stub implementations for demonstration)

## Usage

```haskell
import Data.Functor.Codistributive
import Data.Functor.Corepresentable
import Data.Functor.Adjunct

-- Use Codistributive
result = coDistribute (Identity [1, 2, 3])
-- Result: [Identity 1, Identity 2, Identity 3]

-- Use Corepresentable
f = cotabulate (+1) :: Int -> Int
value = coindex f 5
-- Result: 6
```

## Building

Build with cabal:
```bash
cabal build
```

Run tests:
```bash
cabal test
```

## Note

This library demonstrates the structure of adjunctions with Corepresentable and Representable functors. The Monad and Comonad instances for AdjunctT are stub implementations that show the intended structure.
