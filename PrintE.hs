{-# OPTIONS_GHC -fno-warn-incomplete-patterns #-}
module PrintE where

-- pretty-printer generated by the BNF converter

import AbsE
import Data.Char


-- the top-level printing method
printTree :: Print a => a -> String
printTree = render . prt 0

type Doc = [ShowS] -> [ShowS]

doc :: ShowS -> Doc
doc = (:)

render :: Doc -> String
render d = rend 0 (map ($ "") $ d []) "" where
  rend i ss = case ss of
    "["      :ts -> showChar '[' . rend i ts
    "("      :ts -> showChar '(' . rend i ts
    "{"      :ts -> showChar '{' . new (i+1) . rend (i+1) ts
    "}" : ";":ts -> new (i-1) . space "}" . showChar ';' . new (i-1) . rend (i-1) ts
    "}"      :ts -> new (i-1) . showChar '}' . new (i-1) . rend (i-1) ts
    ";"      :ts -> showChar ';' . new i . rend i ts
    t  : "," :ts -> showString t . space "," . rend i ts
    t  : ")" :ts -> showString t . showChar ')' . rend i ts
    t  : "]" :ts -> showString t . showChar ']' . rend i ts
    t        :ts -> space t . rend i ts
    _            -> id
  new i   = showChar '\n' . replicateS (2*i) (showChar ' ') . dropWhile isSpace
  space t = showString t . (\s -> if null s then "" else (' ':s))

parenth :: Doc -> Doc
parenth ss = doc (showChar '(') . ss . doc (showChar ')')

concatS :: [ShowS] -> ShowS
concatS = foldr (.) id

concatD :: [Doc] -> Doc
concatD = foldr (.) id

replicateS :: Int -> ShowS -> ShowS
replicateS n f = concatS (replicate n f)

-- the printer class does the job
class Print a where
  prt :: Int -> a -> Doc
  prtList :: Int -> [a] -> Doc
  prtList i = concatD . map (prt i)

instance Print a => Print [a] where
  prt = prtList

instance Print Char where
  prt _ s = doc (showChar '\'' . mkEsc '\'' s . showChar '\'')
  prtList _ s = doc (showChar '"' . concatS (map (mkEsc '"') s) . showChar '"')

mkEsc :: Char -> Char -> ShowS
mkEsc q s = case s of
  _ | s == q -> showChar '\\' . showChar s
  '\\'-> showString "\\\\"
  '\n' -> showString "\\n"
  '\t' -> showString "\\t"
  _ -> showChar s

prPrec :: Int -> Int -> Doc -> Doc
prPrec i j = if j<i then parenth else id


instance Print Integer where
  prt _ x = doc (shows x)


instance Print Double where
  prt _ x = doc (shows x)



instance Print PIdent where
  prt _ (PIdent (_,i)) = doc (showString ( i))



instance Print Program where
  prt i e = case e of
    PDefs decls -> prPrec i 0 (concatD [prt 0 decls])
    PTDefs anndecls -> prPrec i 0 (concatD [prt 0 anndecls])

instance Print AnnDecl where
  prt i e = case e of
    LabeledDecl decl -> prPrec i 0 (concatD [prt 0 decl])
  prtList _ [] = (concatD [])
  prtList _ (x:xs) = (concatD [prt 0 x, prt 0 xs])
instance Print Arg where
  prt i e = case e of
    ArgDecl modality pident guard -> prPrec i 0 (concatD [prt 0 modality, prt 0 pident, prt 0 guard])

instance Print Modality where
  prt i e = case e of
    ModEmpty -> prPrec i 0 (concatD [])
    ModVar -> prPrec i 0 (concatD [doc (showString "var")])
    ModDef -> prPrec i 0 (concatD [doc (showString "def")])

instance Print Guard where
  prt i e = case e of
    GuardVoid -> prPrec i 0 (concatD [])
    GuardType type_ -> prPrec i 0 (concatD [doc (showString ":"), prt 0 type_])

instance Print Stmt where
  prt i e = case e of
    StmtExpr expr endline -> prPrec i 0 (concatD [prt 0 expr, prt 0 endline])
    StmtDecl lexpr guard endline -> prPrec i 0 (concatD [doc (showString "var"), prt 0 lexpr, prt 0 guard, prt 0 endline])
    StmtVarInit lexpr guard expr endline -> prPrec i 0 (concatD [doc (showString "var"), prt 0 lexpr, prt 0 guard, doc (showString ":="), prt 0 expr, prt 0 endline])

instance Print Expr where
  prt i e = case e of
    StmtAssign lexpr assignoperator expr -> prPrec i 0 (concatD [prt 0 lexpr, prt 0 assignoperator, prt 1 expr])
    LeftExpr lexpr -> prPrec i 17 (concatD [prt 0 lexpr])
    ExprInt n -> prPrec i 16 (concatD [prt 0 n])
    ExprNegation expr -> prPrec i 14 (concatD [doc (showString "-"), prt 15 expr])
    ExprAddition expr -> prPrec i 14 (concatD [doc (showString "+"), prt 15 expr])
    ExprPlus expr1 expr2 -> prPrec i 11 (concatD [prt 11 expr1, doc (showString "+"), prt 12 expr2])
    ExprMinus expr1 expr2 -> prPrec i 11 (concatD [prt 11 expr1, doc (showString "-"), prt 12 expr2])
  prtList _ [] = (concatD [])
  prtList _ [x] = (concatD [prt 0 x])
  prtList _ (x:xs) = (concatD [prt 0 x, doc (showString ","), prt 0 xs])
instance Print Decl where
  prt i e = case e of
    DeclStmt stmt -> prPrec i 0 (concatD [prt 0 stmt])
  prtList _ [] = (concatD [])
  prtList _ (x:xs) = (concatD [prt 0 x, prt 0 xs])
instance Print LExpr where
  prt i e = case e of
    LExprId pident -> prPrec i 0 (concatD [prt 0 pident])

instance Print AssignOperator where
  prt i e = case e of
    OpAssign -> prPrec i 0 (concatD [doc (showString ":=")])
    OpOr -> prPrec i 0 (concatD [doc (showString "|=")])
    OpAnd -> prPrec i 0 (concatD [doc (showString "&=")])
    OpPlus -> prPrec i 0 (concatD [doc (showString "+=")])
    OpMinus -> prPrec i 0 (concatD [doc (showString "-=")])
    OpMul -> prPrec i 0 (concatD [doc (showString "*=")])
    OpIntDiv -> prPrec i 0 (concatD [doc (showString "//=")])
    OpFloatDiv -> prPrec i 0 (concatD [doc (showString "/=")])
    OpRemainder -> prPrec i 0 (concatD [doc (showString "%=")])
    OpModulo -> prPrec i 0 (concatD [doc (showString "%%=")])
    OpPower -> prPrec i 0 (concatD [doc (showString "**=")])

instance Print Type where
  prt i e = case e of
    TypeInt -> prPrec i 0 (concatD [doc (showString "int")])

instance Print EndLine where
  prt i e = case e of
    Semicolon -> prPrec i 0 (concatD [doc (showString ";")])


