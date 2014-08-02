{-# LANGUAGE LambdaCase #-}

module WHF.Memory.MemoryState where

import System.Win32.Types (DWORD)

data MemoryState = MemCommit | MemFree | MemReserve
  deriving (Eq, Show, Read)

fromDWORD :: DWORD -> MemoryState
fromDWORD = \case
  0x1000  -> MemCommit
  0x10000 -> MemFree
  0x2000  -> MemReserve
  _       -> error "MemoryState.fromDWORD: unknown code!"

toDWORD :: MemoryState -> DWORD
toDWORD = \case
  MemCommit  -> 0x1000
  MemFree    -> 0x10000
  MemReserve -> 0x2000