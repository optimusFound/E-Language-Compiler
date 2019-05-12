module SkelE where

-- Haskell module generated by the BNF converter

import AbsE
import ErrM
type Result = Err String

failure :: Show a => a -> Result
failure x = Bad $ "Undefined case: " ++ show x

transPIdent :: PIdent -> Result
transPIdent x = case x of
  PIdent string -> failure x
transProgram :: Program -> Result
transProgram x = case x of
  PDefs decls -> failure x
  PTDefs annotateddecls -> failure x
transAnnotatedDecl :: AnnotatedDecl -> Result
transAnnotatedDecl x = case x of
  UntypedDecl decl -> failure x
  TypedDecl type_ decl -> failure x
transDecl :: Decl -> Result
transDecl x = case x of
  DeclFun lexpr args guard stmts -> failure x
  DeclStmt stmt -> failure x
transArg :: Arg -> Result
transArg x = case x of
  ArgDecl modality pident guard -> failure x
transModality :: Modality -> Result
transModality x = case x of
  ModEmpty -> failure x
  ModVar -> failure x
  ModDef -> failure x
transGuard :: Guard -> Result
transGuard x = case x of
  GuardVoid -> failure x
  GuardType type_ -> failure x
transStmt :: Stmt -> Result
transStmt x = case x of
  StmtExpr expr -> failure x
  StmtDecl lexpr guard -> failure x
  StmtIterDecl lexpr guard -> failure x
  StmtVarInit lexpr guard expr -> failure x
  StmtDefInit lexpr guard expr -> failure x
  StmtReturn exprs -> failure x
  StmtBlock decls -> failure x
  StmtIfElse expr stmt1 stmt2 -> failure x
  StmtIfNoElse expr stmt -> failure x
  SSwitchCase expr normcases dfltcases -> failure x
  StmtBreak -> failure x
  StmtContinue -> failure x
  StmtWhile expr stmt -> failure x
  StmtFor pident typeiter stmt -> failure x
transNormCase :: NormCase -> Result
transNormCase x = case x of
  CaseNormal expr stmt -> failure x
transDfltCase :: DfltCase -> Result
transDfltCase x = case x of
  CaseDefault stmt -> failure x
transExpr :: Expr -> Result
transExpr x = case x of
  StmtAssign lexpr assignoperator expr -> failure x
  LeftExpr lexpr -> failure x
  ExprInt integer -> failure x
  ExprDouble double -> failure x
  ExprChar char -> failure x
  ExprString string -> failure x
  ExprTrue -> failure x
  ExprFalse -> failure x
  ExprFunCall pident args -> failure x
  ExprBoolNot expr -> failure x
  ExprDeref lexpr -> failure x
  ExprNegation expr -> failure x
  ExprAddition expr -> failure x
  ExprPower expr1 expr2 -> failure x
  ExprMul expr1 expr2 -> failure x
  ExprFloatDiv expr1 expr2 -> failure x
  ExprIntDiv expr1 expr2 -> failure x
  ExprReminder expr1 expr2 -> failure x
  ExprModulo expr1 expr2 -> failure x
  ExprPlus expr1 expr2 -> failure x
  ExprMinus expr1 expr2 -> failure x
  ExprIntInc expr1 expr2 -> failure x
  ExprIntExc expr1 expr2 -> failure x
  ExprLt expr1 expr2 -> failure x
  ExprGt expr1 expr2 -> failure x
  ExprLtEq expr1 expr2 -> failure x
  ExprGtEq expr1 expr2 -> failure x
  ExprEq expr1 expr2 -> failure x
  ExprNeq expr1 expr2 -> failure x
  ExprAnd expr1 expr2 -> failure x
  ExprOr expr1 expr2 -> failure x
transLExpr :: LExpr -> Result
transLExpr x = case x of
  LExprId pident -> failure x
  LExprRef ref -> failure x
transRef :: Ref -> Result
transRef x = case x of
  RefExpr lexpr -> failure x
transAssignOperator :: AssignOperator -> Result
transAssignOperator x = case x of
  OpAssign -> failure x
  OpOr -> failure x
  OpAnd -> failure x
  OpPlus -> failure x
  OpMinus -> failure x
  OpMul -> failure x
  OpIntDiv -> failure x
  OpFloatDiv -> failure x
  OpRemainder -> failure x
  OpModulo -> failure x
  OpPower -> failure x
transType :: Type -> Result
transType x = case x of
  TypeBool -> failure x
  TypeDouble -> failure x
  TypeInt -> failure x
  TypeVoid -> failure x
  TypeChar -> failure x
  TypeString -> failure x
  TypeCompound compoundtype -> failure x
transCompoundType :: CompoundType -> Result
transCompoundType x = case x of
  TypePointer type_ -> failure x
  TypeIterable typeiter -> failure x
transTypeIter :: TypeIter -> Result
transTypeIter x = case x of
  TypeIterInterval expr -> failure x
  TypeIterArray exprs -> failure x

