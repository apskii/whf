{-# LANGUAGE DataKinds, KindSignatures, GeneralizedNewtypeDeriving #-}

module WHF.Memory.MemoryProtectionOptions (
    AccessModifier(..),
    OptionKind(..),
    MemoryProtectionOptions,
    fromDWORD, toDWORD,
    pageNoAccess, pageExecute, pageExecuteRead, pageExecuteReadWrite, pageExecuteWriteCopy,
    pageReadOnly, pageReadWrite, pageWriteCopy, pageGuard, pageNoCache, pageWriteCombine,
    writable
) where

import WHF.Data.Bits

import System.Win32.Types (DWORD)

data AccessModifier =
    Guard
  | NoCache
  | WriteCombine

data OptionKind a =
    NoAccess
  | SomeAccess a

newtype MemoryProtectionOptions (k :: OptionKind a) =
  MPO DWORD deriving (Eq, ZeroBits, BitAnd, BitOr)

fromDWORD :: DWORD -> MemoryProtectionOptions k
fromDWORD = MPO

toDWORD :: MemoryProtectionOptions k -> DWORD
toDWORD (MPO dword) = dword

pageNoAccess :: MemoryProtectionOptions NoAccess
pageNoAccess = MPO 0x01

pageExecute, pageExecuteRead, pageExecuteReadWrite, pageExecuteWriteCopy :: MemoryProtectionOptions (SomeAccess a)
pageExecute          = MPO 0x10
pageExecuteRead      = MPO 0x20
pageExecuteReadWrite = MPO 0x40
pageExecuteWriteCopy = MPO 0x80

pageReadOnly, pageReadWrite, pageWriteCopy :: MemoryProtectionOptions (SomeAccess a)
pageReadOnly  = MPO 0x02
pageReadWrite = MPO 0x04
pageWriteCopy = MPO 0x08

pageGuard :: MemoryProtectionOptions (SomeAccess Guard)
pageGuard = MPO 0x100

pageNoCache :: MemoryProtectionOptions (SomeAccess NoCache)
pageNoCache = MPO 0x200

pageWriteCombine :: MemoryProtectionOptions (SomeAccess WriteCombine)
pageWriteCombine = MPO 0x400

writable :: MemoryProtectionOptions (SomeAccess a)
writable = pageReadWrite .|. pageWriteCopy .|. pageExecuteReadWrite .|. pageExecuteWriteCopy