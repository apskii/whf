module WHF.SystemInfo (
  SystemInfo(..), getSystemInfo,
  processorArch, pageSize,
  minAppAddr, maxAppAddr,
  activeProcessorMask, numberOfProcessors, processorType,
  allocGranularity, processorLevel, processorRev,
  ProcessorArchitecture(..)
) where

import           System.Win32.Types
import           System.Win32.Info (ProcessorArchitecture(..), SYSTEM_INFO(..))
import qualified System.Win32.Info as W32
import           Foreign
import           Unsafe.Coerce

data SystemInfo = SystemInfo {
  _processorArch       :: ProcessorArchitecture,
  _pageSize            :: DWORD,
  _minAppAddr          :: LPVOID,
  _maxAppAddr          :: LPVOID,
  _activeProcessorMask :: DWORD,
  _numberOfProcessors  :: DWORD,
  _processorType       :: DWORD,
  _allocGranularity    :: DWORD,
  _processorLevel      :: WORD,
  _processorRev        :: WORD
}

processorArch = _processorArch
pageSize = _pageSize
minAppAddr = _minAppAddr
maxAppAddr = _maxAppAddr
activeProcessorMask = _activeProcessorMask
numberOfProcessors = _numberOfProcessors
processorType = _processorType
allocGranularity = _allocGranularity
processorLevel = _processorLevel
processorRev = _processorRev

instance Storable SystemInfo where
  sizeOf      = const 36
  alignment   = sizeOf
  poke buf si = poke (unsafeCoerce buf) (unsafeCoerce si :: SYSTEM_INFO)
  peek buf    = unsafeCoerce $ peek (unsafeCoerce buf :: Ptr SYSTEM_INFO)

getSystemInfo :: IO SystemInfo
getSystemInfo = unsafeCoerce W32.getSystemInfo
