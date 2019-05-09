

module AbsE where

-- Haskell module generated by the BNF converter




newtype PIdent = PIdent ((Int,Int),String)
  deriving (Eq, Ord, Show, Read)
data Program = PDefs [Decl]
  deriving (Eq, Ord, Show, Read)

data Decl = DeclFun LExpr [Arg] Guard [Stmt] | DeclStmt Stmt
  deriving (Eq, Ord, Show, Read)

data Guard = GuardVoid | GuardType Type
  deriving (Eq, Ord, Show, Read)

data Arg = ArgDecl PIdent Guard
  deriving (Eq, Ord, Show, Read)

data Stmt
    = StmtExpr Expr EndLine
    | StmtDecl LExpr Guard EndLine
    | StmtIterDecl LExpr Guard EndLine
    | StmtVarInit LExpr Guard Expr EndLine
    | StmtDefInit LExpr Guard Expr EndLine
    | StmtVarIterInit LExpr Guard TypeIter EndLine
    | StmtDefIterInit LExpr Guard TypeIter EndLine
    | StmtReturn [Expr] EndLine
    | StmtBlock [Decl]
    | StmtIfElse Expr Stmt Stmt
    | StmtIfNoElse Expr Stmt
    | SSwitchCase Expr [NormCase] [DfltCase]
    | StmtBreak
    | StmtContinue
    | StmtWhile Expr Stmt
    | StmtFor PIdent TypeIter Stmt
  deriving (Eq, Ord, Show, Read)

data NormCase = CaseNormal Expr Stmt
  deriving (Eq, Ord, Show, Read)

data DfltCase = CaseDefault Stmt
  deriving (Eq, Ord, Show, Read)

data LExpr = LExprId PIdent | LExprDeref Deref | LExprRef Ref
  deriving (Eq, Ord, Show, Read)

data Deref = DerefExpr LExpr
  deriving (Eq, Ord, Show, Read)

data Ref = RefExpr LExpr
  deriving (Eq, Ord, Show, Read)

data Expr
    = LExpr LExpr
    | ExprInt Integer
    | ExprDouble Double
    | ExprChar Char
    | ExprString String
    | ExprTrue
    | ExprFalse
    | ExprFunCall PIdent [Arg]
    | ExprBoolNot Expr
    | ExprNegation Expr
    | ExprPower Expr Expr
    | ExprMul Expr Expr
    | ExprFloatDiv Expr Expr
    | ExprIntDiv Expr Expr
    | ExprReminder Expr Expr
    | ExprModulo Expr Expr
    | ExprPlus Expr Expr
    | ExprMinus Expr Expr
    | ExprIntInc Expr Expr
    | ExprIntExc Expr Expr
    | ExprLt Expr Expr
    | ExprGt Expr Expr
    | ExprLtEq Expr Expr
    | ExprGtEq Expr Expr
    | ExprEq Expr Expr
    | ExprNeq Expr Expr
    | ExprAnd Expr Expr
    | ExprOr Expr Expr
    | ExprAssign LExpr AssignOperator Expr
    | ExprTyped Type Expr
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

data Type
    = TypeBool
    | TypeDouble
    | TypeInt
    | TypeVoid
    | TypeChar
    | TypeString
    | TypeCompound CompoundType
  deriving (Eq, Ord, Show, Read)

data CompoundType = TypePointer Type | TypeIterable TypeIter
  deriving (Eq, Ord, Show, Read)

data TypeIter = TypeIterInterval Expr | TypeIterArray [Expr]
  deriving (Eq, Ord, Show, Read)

data EndLine = Semicolon
  deriving (Eq, Ord, Show, Read)

