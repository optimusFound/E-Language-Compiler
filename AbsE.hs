

module AbsE where

-- Haskell module generated by the BNF converter




newtype PTrue = PTrue ((Int,Int),String)
  deriving (Eq, Ord, Show, Read)
newtype PFalse = PFalse ((Int,Int),String)
  deriving (Eq, Ord, Show, Read)
newtype PReturn = PReturn ((Int,Int),String)
  deriving (Eq, Ord, Show, Read)
newtype PContinue = PContinue ((Int,Int),String)
  deriving (Eq, Ord, Show, Read)
newtype PBreak = PBreak ((Int,Int),String)
  deriving (Eq, Ord, Show, Read)
newtype PIdent = PIdent ((Int,Int),String)
  deriving (Eq, Ord, Show, Read)
newtype PInteger = PInteger ((Int,Int),String)
  deriving (Eq, Ord, Show, Read)
newtype PFloat = PFloat ((Int,Int),String)
  deriving (Eq, Ord, Show, Read)
newtype PChar = PChar ((Int,Int),String)
  deriving (Eq, Ord, Show, Read)
newtype PString = PString ((Int,Int),String)
  deriving (Eq, Ord, Show, Read)
data Program = PDefs [Decl]
  deriving (Eq, Ord, Show, Read)

data Decl
    = TypedDecl AnnotatedDecl
    | DeclFun LExpr [Arg] Guard CompStmt
    | DeclStmt Stmt
  deriving (Eq, Ord, Show, Read)

data AnnotatedDecl = ADecl Type Decl
  deriving (Eq, Ord, Show, Read)

data Arg = ArgDecl Modality PIdent Guard
  deriving (Eq, Ord, Show, Read)

data Modality = ModEmpty | ModVar | ModDef
  deriving (Eq, Ord, Show, Read)

data Guard = GuardVoid | GuardType Type
  deriving (Eq, Ord, Show, Read)

data Stmt
    = StmtExpr Expr
    | StmtVarInit PIdent Guard ComplexExpr
    | StmtDefInit PIdent Guard ComplexExpr
    | StmtReturn PReturn Expr
    | StmtNoReturn PReturn
    | SComp CompStmt
    | StmtIfThenElse Expr CompStmt CompStmt
    | StmtIfThen Expr CompStmt
    | StmtTryCatch CompStmt CompStmt
    | StmtSwitchCase Expr [NormCase] [DfltCase]
    | StmtBreak PBreak
    | StmtContinue PContinue
    | StmtWhile Expr CompStmt
    | StmtLoopUntil CompStmt Expr
    | StmtFor PIdent Range CompStmt
  deriving (Eq, Ord, Show, Read)

data ComplexExpr = ExprSimple Expr | ExprArray [ComplexExpr]
  deriving (Eq, Ord, Show, Read)

data CompStmt = StmtBlock [Decl]
  deriving (Eq, Ord, Show, Read)

data NormCase = CaseNormal Expr CompStmt
  deriving (Eq, Ord, Show, Read)

data DfltCase = CaseDefault CompStmt
  deriving (Eq, Ord, Show, Read)

data Range = ExprRange Expr Expr
  deriving (Eq, Ord, Show, Read)

data Expr
    = ExprAssign LExpr AssignOperator Expr
    | ExprLeft LExpr
    | ExprInt PInteger
    | ExprFloat PFloat
    | ExprChar PChar
    | ExprString PString
    | ExprTrue PTrue
    | ExprFalse PFalse
    | ExprFunCall PIdent [Expr]
    | ExprTernaryIf Expr Expr Expr
    | ExprBoolNot Expr
    | ExprNegation Expr
    | ExprAddition Expr
    | ExprPower Expr Expr
    | ExprMul Expr Expr
    | ExprFloatDiv Expr Expr
    | ExprIntDiv Expr Expr
    | ExprReminder Expr Expr
    | ExprModulo Expr Expr
    | ExprReference LExpr
    | ExprPlus Expr Expr
    | ExprMinus Expr Expr
    | ExprLt Expr Expr
    | ExprGt Expr Expr
    | ExprLtEq Expr Expr
    | ExprGtEq Expr Expr
    | ExprEq Expr Expr
    | ExprNeq Expr Expr
    | ExprAnd Expr Expr
    | ExprOr Expr Expr
  deriving (Eq, Ord, Show, Read)

data LExpr = LExprId PIdent | LExprRef Ref | LExprArr Arr
  deriving (Eq, Ord, Show, Read)

data Ref = LRefExpr LExpr
  deriving (Eq, Ord, Show, Read)

data Arr = LArrExpr PIdent AExpr
  deriving (Eq, Ord, Show, Read)

data AExpr = ArrSing Expr | ArrMul AExpr Expr
  deriving (Eq, Ord, Show, Read)

data AssignOperator
    = OpAssign
    | OpOr
    | OpAnd
    | OpPlus
    | OpMinus
    | OpMul
    | OpIntDiv
    | OpFloatDiv
    | OpRemainder
    | OpModulo
    | OpPower
  deriving (Eq, Ord, Show, Read)

data Type = TypeBasicType BasicType | TypeCompoundType CompoundType
  deriving (Eq, Ord, Show, Read)

data BasicType
    = TypeBool | TypeFloat | TypeInt | TypeVoid | TypeChar | TypeString
  deriving (Eq, Ord, Show, Read)

data CompoundType
    = CompoundTypeArrayType ArrayType | CompoundTypePtr Ptr
  deriving (Eq, Ord, Show, Read)

data ArrayType
    = ArrDefBase [PInteger] BasicType
    | ArrDefBaseC [PInteger] BasicType
    | ArrDefPtr [PInteger] Ptr
    | ArrDefPtrC [PInteger] Ptr
  deriving (Eq, Ord, Show, Read)

data Ptr = Pointer BasicType | Pointer2Pointer Ptr
  deriving (Eq, Ord, Show, Read)


instance Show PTrue     where show (PTrue     (_, val)) = filter (/='\"') (show val)
instance Show PFalse    where show (PFalse    (_, val)) = filter (/='\"') (show val)
instance Show PReturn   where show (PReturn   (_, val)) = filter (/='\"') (show val)
instance Show PContinue where show (PContinue (_, val)) = filter (/='\"') (show val)
instance Show PBreak    where show (PBreak    (_, val)) = filter (/='\"') (show val)
instance Show PIdent    where show (PIdent    (_, val)) = filter (/='\"') (show val)
instance Show PInteger  where show (PInteger  (_, val)) = filter (/='\"') (show val)
instance Show PFloat    where show (PFloat    (_, val)) = filter (/='\"') (show val)
instance Show PChar     where show (PChar     (_, val)) = filter (/='\"') (show val)
instance Show PString   where show (PString   (_, val)) = "\"" ++ filter (/='\\') (filter (/='\"') (show val) ) ++ "\"" 

instance Show Type where 
  show e = case e of 
    TypeBasicType    t -> show t
    TypeCompoundType c -> show c

instance Show BasicType where 
  show t = case t of 
    TypeBool   -> "bool"
    TypeFloat  -> "float"
    TypeInt    -> "int"
    TypeVoid   -> "void"
    TypeChar   -> "char"
    TypeString -> "string"

instance Show CompoundType where 
  show t = case t of 
    CompoundTypeArrayType a -> show a
    CompoundTypePtr       p -> show p

instance Show ArrayType where
  show t = case t of
    ArrDefBase dim bt -> "[]" ++ show bt
    ArrDefPtr  dim p  -> "[]" ++ show p

instance Show Ptr where
  show t = case t of
    Pointer         bt -> show bt ++ "*"
    Pointer2Pointer p  -> show p  ++ "*"