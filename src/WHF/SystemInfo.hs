module WHF.SystemInfo (
  SystemInfo, getSystemInfo,
  processorArch, pageSize,
  minAppAddr, maxAppAddr,
  activeProcessorMask, numberOfProcessors, processorType,
  allocGranularity, processorLevel, processorRev,
  ProcessorArchitecture(..)
) where

import System.Win32.Info (ProcessorArchitecture(..), SYSTEM_INFO(..), getSystemInfo)

type SystemInfo = SYSTEM_INFO

processorArch = siProcessorArchitecture
pageSize = siPageSize
minAppAddr = siMinimumApplicationAddress
maxAppAddr = siMaximumApplicationAddress
activeProcessorMask = siActiveProcessorMask
numberOfProcessors = siNumberOfProcessors
processorType = siProcessorType
allocGranularity = siAllocationGranularity
processorLevel = siProcessorLevel
processorRev = siProcessorRevision