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



instance Print PTrue where
  prt _ (PTrue (_,i)) = doc (showString ( i))


instance Print PFalse where
  prt _ (PFalse (_,i)) = doc (showString ( i))


instance Print PReturn where
  prt _ (PReturn (_,i)) = doc (showString ( i))


instance Print PContinue where
  prt _ (PContinue (_,i)) = doc (showString ( i))


instance Print PBreak where
  prt _ (PBreak (_,i)) = doc (showString ( i))


instance Print PIdent where
  prt _ (PIdent (_,i)) = doc (showString ( i))


instance Print PInteger where
  prt _ (PInteger (_,i)) = doc (showString ( i))
  prtList _ [] = (concatD [])
  prtList _ [x] = (concatD [prt 0 x])
  prtList _ (x:xs) = (concatD [prt 0 x, doc (showString ","), prt 0 xs])

instance Print PFloat where
  prt _ (PFloat (_,i)) = doc (showString ( i))


instance Print PChar where
  prt _ (PChar (_,i)) = doc (showString ( i))


instance Print PString where
  prt _ (PString (_,i)) = doc (showString ( i))



instance Print Program where
  prt i e = case e of
    PDefs decls -> prPrec i 0 (concatD [prt 0 decls])

instance Print Decl where
  prt i e = case e of
    TypedDecl annotateddecl -> prPrec i 0 (concatD [prt 0 annotateddecl])
    DeclFun lexpr args guard compstmt -> prPrec i 0 (concatD [doc (showString "def"), prt 0 lexpr, doc (showString "("), prt 0 args, doc (showString ")"), prt 0 guard, prt 0 compstmt])
    DeclStmt stmt -> prPrec i 0 (concatD [prt 0 stmt])
  prtList _ [] = (concatD [])
  prtList _ (x:xs) = (concatD [prt 0 x, prt 0 xs])
instance Print AnnotatedDecl where
  prt i e = case e of
    ADecl type_ decl -> prPrec i 0 (concatD [doc (showString "["), prt 0 type_, doc (showString ":]"), prt 0 decl])

instance Print Arg where
  prt i e = case e of
    ArgDecl modality pident guard -> prPrec i 0 (concatD [prt 0 modality, prt 0 pident, prt 0 guard])
  prtList _ [] = (concatD [])
  prtList _ [x] = (concatD [prt 0 x])
  prtList _ (x:xs) = (concatD [prt 0 x, doc (showString ","), prt 0 xs])
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
    StmtExpr expr -> prPrec i 0 (concatD [prt 0 expr, doc (showString ";")])
    StmtVarInit pident guard complexexpr -> prPrec i 0 (concatD [doc (showString "var"), prt 0 pident, prt 0 guard, doc (showString ":="), prt 0 complexexpr, doc (showString ";")])
    StmtDefInit pident guard complexexpr -> prPrec i 0 (concatD [doc (showString "def"), prt 0 pident, prt 0 guard, doc (showString ":="), prt 0 complexexpr, doc (showString ";")])
    StmtReturn preturn expr -> prPrec i 0 (concatD [prt 0 preturn, doc (showString "("), prt 0 expr, doc (showString ")"), doc (showString ";")])
    StmtNoReturn preturn -> prPrec i 0 (concatD [prt 0 preturn, doc (showString ";")])
    SComp compstmt -> prPrec i 0 (concatD [prt 0 compstmt])
    StmtIfThenElse expr compstmt1 compstmt2 -> prPrec i 0 (concatD [doc (showString "if"), doc (showString "("), prt 0 expr, doc (showString ")"), prt 0 compstmt1, doc (showString "else"), prt 0 compstmt2])
    StmtIfThen expr compstmt -> prPrec i 0 (concatD [doc (showString "if"), doc (showString "("), prt 0 expr, doc (showString ")"), prt 0 compstmt])
    StmtSwitchCase expr normcases dfltcases -> prPrec i 0 (concatD [doc (showString "switch"), doc (showString "("), prt 0 expr, doc (showString ")"), doc (showString "{"), prt 0 normcases, prt 0 dfltcases, doc (showString "}")])
    StmtBreak pbreak -> prPrec i 0 (concatD [prt 0 pbreak, doc (showString ";")])
    StmtContinue pcontinue -> prPrec i 0 (concatD [prt 0 pcontinue, doc (showString ";")])
    StmtWhile expr compstmt -> prPrec i 0 (concatD [doc (showString "while"), doc (showString "("), prt 0 expr, doc (showString ")"), prt 0 compstmt])
    StmtFor pident range compstmt -> prPrec i 0 (concatD [doc (showString "for"), prt 0 pident, doc (showString "in"), prt 0 range, prt 0 compstmt])

instance Print ComplexExpr where
  prt i e = case e of
    ExprSimple expr -> prPrec i 0 (concatD [prt 0 expr])
    ExprArray complexexprs -> prPrec i 0 (concatD [doc (showString "["), prt 0 complexexprs, doc (showString "]")])
  prtList _ [x] = (concatD [prt 0 x])
  prtList _ (x:xs) = (concatD [prt 0 x, doc (showString ","), prt 0 xs])
instance Print CompStmt where
  prt i e = case e of
    StmtBlock decls -> prPrec i 0 (concatD [doc (showString "{"), prt 0 decls, doc (showString "}")])

instance Print NormCase where
  prt i e = case e of
    CaseNormal expr compstmt -> prPrec i 0 (concatD [doc (showString "match"), prt 0 expr, prt 0 compstmt])
  prtList _ [] = (concatD [])
  prtList _ (x:xs) = (concatD [prt 0 x, prt 0 xs])
instance Print DfltCase where
  prt i e = case e of
    CaseDefault compstmt -> prPrec i 0 (concatD [doc (showString "match _"), prt 0 compstmt])
  prtList _ [] = (concatD [])
  prtList _ (x:xs) = (concatD [prt 0 x, prt 0 xs])
instance Print Range where
  prt i e = case e of
    ExprRange forid1 forid2 -> prPrec i 0 (concatD [prt 0 forid1, doc (showString ".."), prt 0 forid2])

instance Print ForId where
  prt i e = case e of
    ForIdent pident -> prPrec i 0 (concatD [prt 0 pident])
    ForInteger pinteger -> prPrec i 0 (concatD [prt 0 pinteger])

instance Print Expr where
  prt i e = case e of
    ExprAssign lexpr assignoperator expr -> prPrec i 0 (concatD [prt 0 lexpr, prt 0 assignoperator, prt 1 expr])
    ExprLeft lexpr -> prPrec i 17 (concatD [prt 0 lexpr])
    ExprInt pinteger -> prPrec i 16 (concatD [prt 0 pinteger])
    ExprFloat pfloat -> prPrec i 16 (concatD [prt 0 pfloat])
    ExprChar pchar -> prPrec i 16 (concatD [prt 0 pchar])
    ExprString pstring -> prPrec i 16 (concatD [prt 0 pstring])
    ExprTrue ptrue -> prPrec i 16 (concatD [prt 0 ptrue])
    ExprFalse pfalse -> prPrec i 16 (concatD [prt 0 pfalse])
    ExprFunCall pident exprs -> prPrec i 15 (concatD [prt 0 pident, doc (showString "("), prt 0 exprs, doc (showString ")")])
    ExprBoolNot expr -> prPrec i 14 (concatD [doc (showString "!"), prt 15 expr])
    ExprNegation expr -> prPrec i 14 (concatD [doc (showString "-"), prt 15 expr])
    ExprAddition expr -> prPrec i 14 (concatD [doc (showString "+"), prt 15 expr])
    ExprPower expr1 expr2 -> prPrec i 13 (concatD [prt 14 expr1, doc (showString "^"), prt 13 expr2])
    ExprMul expr1 expr2 -> prPrec i 12 (concatD [prt 12 expr1, doc (showString "*"), prt 13 expr2])
    ExprFloatDiv expr1 expr2 -> prPrec i 12 (concatD [prt 12 expr1, doc (showString "/"), prt 13 expr2])
    ExprIntDiv expr1 expr2 -> prPrec i 12 (concatD [prt 12 expr1, doc (showString "//"), prt 13 expr2])
    ExprReminder expr1 expr2 -> prPrec i 12 (concatD [prt 12 expr1, doc (showString "%"), prt 13 expr2])
    ExprModulo expr1 expr2 -> prPrec i 12 (concatD [prt 12 expr1, doc (showString "%%"), prt 13 expr2])
    ExprReference lexpr -> prPrec i 11 (concatD [doc (showString "&"), prt 0 lexpr])
    ExprPlus expr1 expr2 -> prPrec i 11 (concatD [prt 11 expr1, doc (showString "+"), prt 12 expr2])
    ExprMinus expr1 expr2 -> prPrec i 11 (concatD [prt 11 expr1, doc (showString "-"), prt 12 expr2])
    ExprLt expr1 expr2 -> prPrec i 9 (concatD [prt 9 expr1, doc (showString "<"), prt 10 expr2])
    ExprGt expr1 expr2 -> prPrec i 9 (concatD [prt 9 expr1, doc (showString ">"), prt 10 expr2])
    ExprLtEq expr1 expr2 -> prPrec i 9 (concatD [prt 9 expr1, doc (showString "<="), prt 10 expr2])
    ExprGtEq expr1 expr2 -> prPrec i 9 (concatD [prt 9 expr1, doc (showString ">="), prt 10 expr2])
    ExprEq expr1 expr2 -> prPrec i 8 (concatD [prt 8 expr1, doc (showString "=="), prt 9 expr2])
    ExprNeq expr1 expr2 -> prPrec i 8 (concatD [prt 8 expr1, doc (showString "!="), prt 9 expr2])
    ExprAnd expr1 expr2 -> prPrec i 4 (concatD [prt 4 expr1, doc (showString "&&"), prt 5 expr2])
    ExprOr expr1 expr2 -> prPrec i 3 (concatD [prt 3 expr1, doc (showString "||"), prt 4 expr2])
  prtList _ [] = (concatD [])
  prtList _ [x] = (concatD [prt 0 x])
  prtList _ (x:xs) = (concatD [prt 0 x, doc (showString ","), prt 0 xs])
instance Print LExpr where
  prt i e = case e of
    LExprId pident -> prPrec i 0 (concatD [prt 0 pident])
    LExprRef ref -> prPrec i 0 (concatD [prt 0 ref])
    LExprArr arr -> prPrec i 0 (concatD [prt 0 arr])

instance Print Ref where
  prt i e = case e of
    LRefExpr lexpr -> prPrec i 0 (concatD [doc (showString "*"), prt 0 lexpr])

instance Print Arr where
  prt i e = case e of
    LArrExpr pident aexpr -> prPrec i 0 (concatD [prt 0 pident, doc (showString "["), prt 0 aexpr, doc (showString "]")])

instance Print AExpr where
  prt i e = case e of
    ArrSing pinteger -> prPrec i 0 (concatD [prt 0 pinteger])
    ArrMul aexpr pinteger -> prPrec i 0 (concatD [prt 0 aexpr, doc (showString ","), prt 0 pinteger])

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
    OpPower -> prPrec i 0 (concatD [doc (showString "^=")])

instance Print Type where
  prt i e = case e of
    TypeBasicType basictype -> prPrec i 0 (concatD [prt 0 basictype])
    TypeCompoundType compoundtype -> prPrec i 0 (concatD [prt 0 compoundtype])

instance Print BasicType where
  prt i e = case e of
    TypeBool -> prPrec i 0 (concatD [doc (showString "bool")])
    TypeFloat -> prPrec i 0 (concatD [doc (showString "float")])
    TypeInt -> prPrec i 0 (concatD [doc (showString "int")])
    TypeVoid -> prPrec i 0 (concatD [doc (showString "void")])
    TypeChar -> prPrec i 0 (concatD [doc (showString "char")])
    TypeString -> prPrec i 0 (concatD [doc (showString "string")])

instance Print CompoundType where
  prt i e = case e of
    CompoundTypeArrayType arraytype -> prPrec i 0 (concatD [prt 0 arraytype])
    CompoundTypePtr ptr -> prPrec i 0 (concatD [prt 0 ptr])

instance Print ArrayType where
  prt i e = case e of
    ArrDefBase pintegers basictype -> prPrec i 0 (concatD [doc (showString "["), prt 0 pintegers, doc (showString "]"), prt 0 basictype])
    ArrDefPtr pintegers ptr -> prPrec i 0 (concatD [doc (showString "["), prt 0 pintegers, doc (showString "]"), prt 0 ptr])

instance Print Ptr where
  prt i e = case e of
    Pointer basictype -> prPrec i 0 (concatD [prt 0 basictype, doc (showString "*")])
    Pointer2Pointer ptr -> prPrec i 0 (concatD [prt 0 ptr, doc (showString "*")])


instance Show Program where
  show p = case p of
    --PDefs decls -> prPrec i 0 (concatD [prt 0 decls])
    TACProgram []   -> ""
    TACProgram tacs -> (show tacs)

instance Show TAC where
  show t = case t of
    {-mettere \n dopo return-}
    FuncDef (Var (name,pos@(row,col),type_))       -> "\n"++ filter (/='\"') (show name) ++ "@"++ show row ++ "-"++show col ++"\tFunction:\n\tType: " ++ show type_ ++ "\n\tStatements:\n"
    Return  temp                                   -> "\treturn_" ++ show temp ++"\n\tEnd Function\n\n"
    FuncCall (Var (name,pos@(row,col),type_)) temp -> "\t" ++ show temp ++ " = " ++ show type_ ++ " call " ++ filter (/='\"') (show name) ++ "@"++ show row ++ "-"++show col++"\n"


    AssignIntVar    var  val             -> "\t" ++ show var   ++ " = int "    ++ show val ++ "\n"
    AssignChrVar    var  val             -> "\t" ++ show var   ++ " = char "   ++ show val ++ "\n"
    AssignStrVar    var  val             -> "\t" ++ show var   ++ " = string " ++ show val ++ "\n"
    AssignTrueVar   var  val             -> "\t" ++ show var   ++ " = bool "   ++ show val ++ "\n"
    AssignFalseVar  var  val             -> "\t" ++ show var   ++ " = bool "   ++ show val ++ "\n"
    AssignFloatVar  var  val             -> "\t" ++ show var   ++ " = float "  ++ show val ++ "\n"
              
    AssignIntTemp   temp val             -> "\t" ++ show temp  ++ " = int "    ++ show val ++ "\n"
    AssignChrTemp   temp val             -> "\t" ++ show temp  ++ " = char "   ++ show val ++ "\n"
    AssignStrTemp   temp val             -> "\t" ++ show temp  ++ " = string " ++ show val ++ "\n"
    AssignTrueTemp  temp val             -> "\t" ++ show temp  ++ " = bool "   ++ show val ++ "\n"
    AssignFalseTemp temp val             -> "\t" ++ show temp  ++ " = bool "   ++ show val ++ "\n"
    AssignFloatTemp temp val             -> "\t" ++ show temp  ++ " = float "  ++ show val ++ "\n"
            
    AssignT2V       var  temp pos        -> "\t" ++ show var  ++ (if pos /= -1 then "[" ++ show pos ++ "] = " else " = ") ++ show temp ++ "\n"
    AssignT2T       tmp1 tmp2            -> "\t" ++ show tmp1 ++ " = " ++ show tmp2 ++ "\n"
    AssignV2T       temp var  pos        -> "\t" ++ show temp ++ " = " ++ show var  ++ (if pos /= -1 then "[" ++ show pos ++ "]\n" else "\n")
    AssignT2P       temp                 -> "\t" ++ "param_"  ++ show temp ++ "\n"
    
    BinOp BOpPlus      tempr temp1 temp2 -> "\t" ++ show tempr ++ " = " ++ show temp1 ++ " + " ++ show temp2  ++ "\n"
    BinOp BOpMinus     tempr temp1 temp2 -> "\t" ++ show tempr ++ " = " ++ show temp1 ++ " - " ++ show temp2  ++ "\n"
    BinOp BOpMul       tempr temp1 temp2 -> "\t" ++ show tempr ++ " = " ++ show temp1 ++ " * " ++ show temp2  ++ "\n"
    BinOp BOpIntDiv    tempr temp1 temp2 -> "\t" ++ show tempr ++ " = " ++ show temp1 ++ " // " ++ show temp2 ++ "\n"
    BinOp BOpFloatDiv  tempr temp1 temp2 -> "\t" ++ show tempr ++ " = " ++ show temp1 ++ " / " ++ show temp2  ++ "\n"
    BinOp BOpRemainder tempr temp1 temp2 -> "\t" ++ show tempr ++ " = " ++ show temp1 ++ " % " ++ show temp2  ++ "\n"
    BinOp BOpModulo    tempr temp1 temp2 -> "\t" ++ show tempr ++ " = " ++ show temp1 ++ " %% " ++ show temp2 ++ "\n"
    BinOp BOpPower     tempr temp1 temp2 -> "\t" ++ show tempr ++ " = " ++ show temp1 ++ " ^ " ++ show temp2  ++ "\n"

    UnaryOp UOpMinus         temp1 temp2 -> "\t" ++ show temp1 ++ " = 0 - " ++ show temp2 ++ "\n"       
    UnaryOp UOpPlus          temp1 temp2 -> "\t" ++ show temp1 ++ " = 0 + " ++ show temp2 ++ "\n"
    UnaryOp UOpNegate        temp1 temp2 -> "\t" ++ show temp1 ++ " = not " ++ show temp2 ++ "\n"
    UnaryOp UOpDeref         temp1 temp2 -> "\t" ++ show temp1 ++ " = &" ++ show temp2 ++ "\n"

    BoolOp BOpOr             temp1 temp2 -> show temp1 ++ " or "                  ++ show temp2
    BoolOp BOpAnd            temp1 temp2 -> show temp1 ++ " and "                 ++ show temp2
    BoolOp BOpLt             temp1 temp2 -> show temp1 ++ " less_than "           ++ show temp2
    BoolOp BOpGt             temp1 temp2 -> show temp1 ++ " greater_than "        ++ show temp2
    BoolOp BOpLtEq           temp1 temp2 -> show temp1 ++ " less_equal_than "     ++ show temp2
    BoolOp BOpGtEq           temp1 temp2 -> show temp1 ++ " greater_equal_than "  ++ show temp2
    BoolOp BOpEq             temp1 temp2 -> show temp1 ++ " equal "               ++ show temp2
    BoolOp BOpNeq            temp1 temp2 -> show temp1 ++ " not_equal "           ++ show temp2

    Goto label                           -> "\tgoto " ++ show label  ++ "\n"
    Lbl  label                           -> show label
    If      bexpr label                  ->"\tif "      ++ show bexpr ++ " goto "++show label++"\n"
    IfFalse bexpr label                  ->"\tifFalse " ++ show bexpr ++ " goto "++show label++"\n"
    _ -> "comando non trovato\n"

instance Show Var where --Var = (String,(Int,Int),Type)
  show (Var (name,pos@(row,col),type_)) = show type_ ++ "  "++   filter (/='\"') (show name) ++ "@"++ show row ++ "-"++show col

instance Show Temp where --Temp = Temp (Int,BasicType) | TempT PTrue | TempF PFalse
  show temp  = case temp of
    (Temp (num,type_)) -> show type_ ++ "  t" ++ show num
    (TempT _) -> show TypeBool ++ "  true"
    (TempF _) -> show TypeBool ++ "  false"
  
instance Show Label where --Label = (Int,Type)
  show (Label (name,id)) = filter (/='\"') (show name) ++ "@" ++ show id