# Windows Hacking Foundation

## Conceptually interesting stuff here

* Scheme of phantom type ascriptions for constraints on MemoryProtectionOptions combinations

## Example memory scanner (only dumps info atm)

```haskell
import WHF.Utilities
import WHF.Data.Bits
import WHF.Memory
import WHF.Memory.MemoryState as MS
import WHF.Memory.MemoryBasicInfo as MBI
import WHF.Memory.MemoryProtectionOptions as MPO

import System.IO
import System.Win32
import Control.Applicative

getActiveMemblocks :: HANDLE -> Addr -> IO [MemoryBasicInfo]
getActiveMemblocks hProc lpAddr =
  getMemoryInfo hProc lpAddr >>= \case
    Nothing  -> pure []
    Just mbi -> if
        | size == 0 -> pure []
        | isActive  -> fmap (mbi :) rest
        | otherwise -> rest
      where
        size = MBI.regionSize mbi
        isActive = (MBI.protect mbi .&&. MPO.writable) && (MBI.state mbi == MemCommit)
        rest = getActiveMemblocks hProc (lpAddr @+ size)

dump :: MemoryBasicInfo -> IO ()
dump mbi = do
  putStrLn $ "# Block at " ++ show (MBI.baseAddress mbi)
  putStrLn $ "- Region size: " ++ show (MBI.regionSize mbi)

main = do
  hSetBuffering stdout NoBuffering
  putStr "Input PID: "
  pid <- readLn
  putStrLn "Trying to open process..."
  handle <- openProcess pROCESS_ALL_ACCESS False pid
  putStrLn "Trying to retrieve active memory blocks..."
  memblocks <- getActiveMemblocks handle nullPtr
  mapM_ dump memblocks
  putStrLn "Sucess!"
```
