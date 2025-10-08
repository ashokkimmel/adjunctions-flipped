# adjunctions-flipped

A Haskell library providing `CoRepresentable` functors with tuple-based conversion functions.

## Overview

This library implements the dual of representable functors. While representable functors are isomorphic to `CoRep f -> a`, corepresentable functors are isomorphic to `(CoRep f, a)` - a tuple!

## The CoRepresentable Typeclass

```haskell
class Functor f => CoRepresentable f where
  type CoRep f
  
  -- | Convert from the functor to a tuple
  coTabulate :: f a -> (CoRep f, a)
  
  -- | Convert from a tuple to the functor  
  coIndex :: (CoRep f, a) -> f a
```

### Key Features

- **Tuple-based conversions**: The conversion functions work with tuples `(CoRep f, a)` rather than functions
- **Lawful**: Satisfies the isomorphism laws:
  - `coIndex . coTabulate = id`
  - `coTabulate . coIndex = id`

## Instances

### Identity
```haskell
instance CoRepresentable Identity where
  type CoRep Identity = ()
  coTabulate (Identity a) = ((), a)
  coIndex ((), a) = Identity a
```

### Tuple (,) r
The canonical example - tuples are already in the form `(CoRep f, a)`:
```haskell
instance CoRepresentable ((,) r) where
  type CoRep ((,) r) = r
  coTabulate (r, a) = (r, a)
  coIndex (r, a) = (r, a)
```

## Usage Examples

```haskell
import Data.Functor.CoRep
import Data.Functor.Identity

-- With Identity
let x = Identity 42
let (pos, val) = coTabulate x  -- ((), 42)
let y = coIndex ((), 100)      -- Identity 100

-- With tuples
let z = ("key", "value")
let (k, v) = coTabulate z      -- ("key", "value")
let w = coIndex ("a", "b")     -- ("a", "b")
```

## Building and Testing

```bash
cabal build
cabal test
```

## License

BSD-3-Clause
