module WHF.Utilities where

import Foreign

nop :: Monad m => m ()
nop = return ()

(@+) :: Integral offset => Ptr a -> offset -> Ptr b
ptr @+ offset = plusPtr ptr (fromIntegral offset)

