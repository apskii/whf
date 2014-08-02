{-# LANGUAGE PolymorphicComponents #-}

module WHF.Memory.MemoryBasicInfo where

import WHF.Memory.MemoryState as MS
import WHF.Memory.MemoryProtectionOptions as MPO

import System.Win32.Types
import Control.Applicative
import Foreign
import Foreign.C.Types
import Unsafe.Coerce

#include <windows.h>

data MemoryBasicInfo = forall k . MemoryBasicInfo {
  _baseAddress       :: Addr,
  _allocationBase    :: Addr,
  _allocationProtect :: DWORD,
  _regionSize        :: SIZE_T,
  _state             :: MemoryState,
  _protect           :: MemoryProtectionOptions k,
  _pageType          :: DWORD
}

baseAddress = _baseAddress
allocationBase = _allocationBase
allocationProtect = _allocationProtect
regionSize = _regionSize
state = _state
pageType = _pageType

protect :: MemoryBasicInfo -> MemoryProtectionOptions k
protect MemoryBasicInfo { _protect = p } = unsafeCoerce p

size :: SIZE_T
size = #size MEMORY_BASIC_INFORMATION

instance Storable MemoryBasicInfo where
    sizeOf _ = #size MEMORY_BASIC_INFORMATION
    alignment = sizeOf
    poke buf mbi = do
      (#poke MEMORY_BASIC_INFORMATION, BaseAddress) buf (baseAddress mbi)
      (#poke MEMORY_BASIC_INFORMATION, AllocationBase) buf (allocationBase mbi)
      (#poke MEMORY_BASIC_INFORMATION, AllocationProtect) buf (allocationProtect mbi)
      (#poke MEMORY_BASIC_INFORMATION, RegionSize) buf (regionSize mbi)
      (#poke MEMORY_BASIC_INFORMATION, State) buf (MS.toDWORD (state mbi))
      (#poke MEMORY_BASIC_INFORMATION, Protect) buf (MPO.toDWORD (protect mbi))
      (#poke MEMORY_BASIC_INFORMATION, Type) buf (pageType mbi)
    peek buf = MemoryBasicInfo
      <$> (#peek MEMORY_BASIC_INFORMATION, BaseAddress) buf
      <*> (#peek MEMORY_BASIC_INFORMATION, AllocationBase) buf
      <*> (#peek MEMORY_BASIC_INFORMATION, AllocationProtect) buf
      <*> (#peek MEMORY_BASIC_INFORMATION, RegionSize) buf
      <*> fmap MS.fromDWORD ((#peek MEMORY_BASIC_INFORMATION, State) buf)
      <*> fmap MPO.fromDWORD ((#peek MEMORY_BASIC_INFORMATION, Protect) buf)
      <*> (#peek MEMORY_BASIC_INFORMATION, Type) buf