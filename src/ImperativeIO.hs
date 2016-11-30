module ImperativeIO where

import qualified Data.ByteString       as B
import qualified Data.ByteString.Char8 as B8
import           Data.Char
import           System.IO

data Chunk = Chunk { chunk :: String }
           | LineEnd {chunk :: String, remainder :: String } -- when chunk contains an endline char
    deriving (Show)

--  print $ parseChunk (B8.pack "AAA\nBB")
--  print $ parseChunk (B8.pack "CCC")
parseChunk :: B8.ByteString -> Chunk
parseChunk chunk =
  if rightS == B8.pack ""
    then Chunk (toS leftS)
    else LineEnd (toS leftS) ((toS . B8.tail) rightS)
  where
    (leftS, rightS) = B8.break (=='\n') chunk
    toS = map (chr . fromEnum) . B.unpack

imperativeFileProcess :: String -> Handle -> IO ()
imperativeFileProcess accumulator fileHandle = do
  isEoF <- hIsEOF fileHandle
  if isEoF
    then do
      putStrLn accumulator
      putStrLn "DONE..."
    else do
      chunk <- B.hGet fileHandle 8     -- reads the file in chunks 8 bytes
      case parseChunk chunk of
        (Chunk chunk') -> do
          let accLine = accumulator ++ chunk'
          imperativeFileProcess accLine fileHandle
        (LineEnd chunk' remainder) -> do
          let line = accumulator ++ chunk'
          putStrLn line
          imperativeFileProcess remainder fileHandle
      return()
