module Main where


import System.IO ( stdin, hGetContents )
import System.Environment ( getArgs, getProgName )
import System.Exit ( exitFailure, exitSuccess )
import Control.Monad (when)

import LexE
import ParE
import SkelE
import PrintE
import AbsE

import TypeChecker


import ErrM

type ParseFun a = [Token] -> Err a

myLLexer = myLexer

type Verbosity = Int

putStrV :: Verbosity -> String -> IO ()
putStrV v s = when (v > 1) $ putStrLn s

runFile :: Verbosity -> ParseFun Program -> FilePath -> IO ()
runFile v p f = putStrLn f >> readFile f >>= run v p

run :: Verbosity -> ParseFun Program -> String -> IO ()
run v p s = let ts = myLLexer s in case p ts of
           Bad s    -> do putStrLn "\nParse              Failed...\n"
                          putStrV v "Tokens:"
                          putStrV v $ show ts
                          putStrLn s
                          exitFailure
           Ok  tree -> do putStrLn "\nParsing successful!"
                          showTree v tree
                          putStrLn "### [Type checker]"
                          case typeCheck tree of
                              Bad err -> do putStrLn err
                                            exitFailure
                              Ok (env,prog) -> do putStrLn "\nType checking successful!"
                                                  showAnnotatedTree v prog
                                                  exitSuccess
                                               --where
                                               --   rev = foldl (flip (:)) []


showTree :: (Show a, Print a) => Int -> a -> IO ()
showTree v tree
 = do
      putStrV v $ "\n### [SYNTAX TREE]\n\n" ++ show tree
      putStrV v $ "\n### [LINEARIZED TREE]\n\n" ++ printTree tree

showAnnotatedTree :: (Show a, Print a) => Int -> a -> IO()
showAnnotatedTree v prog = do
  putStrV v $ "\n### [ANNOTATED SYNTAX TREE]\n\n" ++ show prog
  putStrV v $ "\n### [ANNOTATED LINEARIZED TREE]\n\n" ++ printTree prog

usage :: IO ()
usage = do
  putStrLn $ unlines
    [ "usage: Call with one of the following argument combinations:"
    , "  --help          Display this help message."
    , "  (no arguments)  Parse stdin verbosely."
    , "  (files)         Parse content of files verbosely."
    , "  -s (files)      Silent mode. Parse content of files silently."
    ]
  exitFailure

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["--help"] -> usage
    [] -> getContents >>= run 2 pProgram
    "-s":fs -> mapM_ (runFile 0 pProgram) fs
    fs -> mapM_ (runFile 2 pProgram) fs
