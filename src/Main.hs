module Main where

import           ImperativeIO
import           System.IO

main :: IO ()
main = do
  fileHandle <- openFile "jabberwocky.txt" ReadMode
  imperativeFileProcess "" fileHandle
  hClose fileHandle
