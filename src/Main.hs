module Main where

import           ImperativeIO
import           System.IO

main :: IO ()
main = do
--  print $ parseChunk (B8.pack "AAA\nBB")
--  print $ parseChunk (B8.pack "CCC")
  fileHandle <- openFile "jabberwocky.txt" ReadMode
  imperativeFileProcess "" fileHandle
  hClose fileHandle
