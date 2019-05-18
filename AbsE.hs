

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

data Program = PDefs [Decl] | TACProgram [TAC]
  deriving (Eq, Ord, Read)

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
    | StmtVarInit PIdent Guard Expr
    | StmtVarArrInit [Range] PIdent Guard Array
    | StmtDefInit PIdent Guard Expr
    | StmtDefArrInit [Range] PIdent Guard Array
    | StmtReturn PReturn Expr
    | StmtNoReturn PReturn
    | SComp CompStmt
    | StmtIfThenElse Expr CompStmt CompStmt
    | StmtIfThen Expr CompStmt
    | StmtSwitchCase Expr [NormCase] [DfltCase]
    | StmtBreak PBreak
    | StmtContinue PContinue
    | StmtWhile Expr CompStmt
    | StmtFor PIdent ForRange CompStmt
  deriving (Eq, Ord, Show, Read)

data Array = ExprArray Expr | ExprMultiArray [Array]
  deriving (Eq, Ord, Show, Read)

data Range = ExprRange PInteger
  deriving (Eq, Ord, Show, Read)

data CompStmt = StmtBlock [Decl]
  deriving (Eq, Ord, Show, Read)

data NormCase = CaseNormal Expr CompStmt
  deriving (Eq, Ord, Show, Read)

data DfltCase = CaseDefault CompStmt
  deriving (Eq, Ord, Show, Read)

data ForRange = ExprForRange ForId ForId
  deriving (Eq, Ord, Show, Read)

data ForId = ForIdent PIdent | ForInteger PInteger
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

data Type
    = TypeBool
    | TypeFloat
    | TypeInt
    | TypeVoid
    | TypeChar
    | TypeString
    | TypeCompound CType
  deriving (Eq, Ord, Show, Read)

data CType = TypePointer Type | TypeAddress Type | TypeArray Type [Range]
  deriving (Eq, Ord, Show, Read)

data Label = Label (String,Integer)
  deriving (Eq, Ord, Show, Read)

-- temporal variables: 't'id_numeber
data Temp = Temp (Int,Type)
  deriving (Eq, Ord, Read)
-- user variables: var_name@line_number
data Var  = Var  (String,(Int,Int),Type)
  deriving (Eq, Ord, Read)

data TAC 
  = AssignIntTemp   Temp PInteger
  | AssignChrTemp   Temp PChar
  | AssignStrTemp   Temp PString
  | AssignTrueTemp  Temp PTrue
  | AssignFalseTemp Temp PFalse
  | AssignFloatTemp Temp PFloat

  | AssignIntVar    Var  PInteger
  | AssignChrVar    Var  PChar
  | AssignStrVar    Var  PString
  | AssignTrueVar   Var  PTrue
  | AssignFalseVar  Var  PFalse
  | AssignFloatVar  Var  PFloat

  | AssignT2V Var Temp
  | AssignT2T Temp Temp
  | AssignV2T Temp Var

  | BinOp BinaryOperator Temp Temp Temp
  | UnaryOp UnaryOp Temp Temp

  | TACInt Integer
  | TACDouble Double
  | TACChar Char
  | TACString String
  | TACTrue
  | TACFalse

  | Goto Label
  | IfNot Temp Label
  | L Label
  | Noop
  deriving (Eq, Ord, Read)

data BinaryOperator
  = BOpAssign
  | BOpOr
  | BOpAnd
  | BOpPlus
  | BOpMinus
  | BOpMul
  | BOpIntDiv
  | BOpFloatDiv
  | BOpRemainder
  | BOpModulo
  | BOpPower
  deriving (Eq, Ord, Read)

data UnaryOp
-- Assign
  = UOpMinus
-- Logical
  | UOpNegate
  deriving (Eq, Ord, Show, Read)