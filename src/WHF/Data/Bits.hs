{-# LANGUAGE TypeSynonymInstances #-}

module WHF.Data.Bits where

import qualified Data.Bits as B
import System.Win32.Types

class ZeroBits b where
  zeroBits :: b

class BitAnd b where
  (.&.) :: b -> b -> b

class BitOr b where
  (.|.) :: b -> b -> b

(.||.) :: (Eq a, ZeroBits a, BitOr a) => a -> a -> Bool
x .||. y = x /= zeroBits || y /= zeroBits

(.&&.) :: (Eq a, ZeroBits a, BitAnd a) => a -> a -> Bool
x .&&. y = (x .&. y) /= zeroBits

instance ZeroBits DWORD where
  zeroBits = 0

instance BitAnd DWORD where
  (.&.) = (B..&.)

instance BitOr DWORD where
  (.|.) = (B..|.)