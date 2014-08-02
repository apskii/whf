{-# LANGUAGE ViewPatterns #-}

module WHF.Memory (
    MemoryBasicInfo, getMemoryInfo,
    virtualQueryEx
) where

import WHF.Memory.MemoryBasicInfo as MBI
import WHF.SystemInfo as SI

import System.Win32.Types
import Foreign
import Control.Applicative

##include "windows_cconv.h"

foreign import WINDOWS_CCONV unsafe "windows.h VirtualQueryEx"
  virtualQueryEx :: HANDLE -> LPVOID -> Ptr MemoryBasicInfo -> SIZE_T -> IO DWORD

getMemoryInfo :: HANDLE -> LPVOID -> IO (Maybe MemoryBasicInfo)
getMemoryInfo hProc lpAddr =
  getSystemInfo >>= \(SI.maxAppAddr -> maxAddr) ->
    if | lpAddr > maxAddr -> pure Nothing
       | otherwise        -> alloca $ \pMemInfo -> do
         r <- virtualQueryEx hProc lpAddr pMemInfo MBI.size
         if | r == 0    -> pure Nothing
            | otherwise -> Just <$> peek pMemInfo
