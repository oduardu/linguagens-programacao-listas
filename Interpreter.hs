module Interpreter where

import Lexer
import Parser

isValue :: Expr -> Bool
isValue BTrue  = True
isValue BFalse = True
isValue (Num _) = True
isValue (Lam _ _ _) = True
isValue (EmptyList _) = True
isValue (ConstructorList h t) = isValue h && isValue t
isValue _ = False

subst :: String -> Expr -> Expr -> Expr
subst x s y@(Var v) = if x == v then
                        s
                      else
                        y
subst x s (Num n) = (Num n)
subst x s BTrue = BTrue
subst x s BFalse = BFalse
subst x s (Lam y tp t1) = Lam y tp (subst x s t1)
subst x s (App t1 t2) = App (subst x s t1) (subst x s t2)
subst x s (Add t1 t2) = Add (subst x s t1) (subst x s t2)
subst x s (And t1 t2) = And (subst x s t1) (subst x s t2)
subst x s (Or t1 t2) = Or (subst x s t1) (subst x s t2)
subst x s (Times t1 t2) = Times (subst x s t1) (subst x s t2)
subst x s (Eq t1 t2) = Eq (subst x s t1) (subst x s t2)
subst x s (Neq t1 t2) = Neq (subst x s t1) (subst x s t2)
subst x s (If e1 e2 e3) = If (subst x s e1) (subst x s e2) (subst x s e3)

step :: Expr -> Expr
step (Add (Num n1) (Num n2)) = Num (n1 + n2)
step (Add (Num n1) e2) = let e2' = step e2
                           in Add (Num n1) e2'
step (Add e1 e2) = Add (step e1) e2

step (Times (Num n1) (Num n2)) = Num (n1 * n2)
step (Times (Num n1) e2) = let e2' = step e2
                             in Times (Num n1) e2'
step (Times e1 e2) = Times (step e1) e2

step (Eq (Num n1) (Num n2)) = if n1 == n2 then BTrue else BFalse
step (Eq (Num n1) e2) = let e2' = step e2 in Eq (Num n1) e2'
step (Eq e1 e2) = Eq (step e1) e2

step (Neq (Num n1) (Num n2)) = if n1 /= n2 then BTrue else BFalse
step (Neq (Num n1) e2) = let e2' = step e2 in Neq (Num n1) e2'
step (Neq e1 e2) = Neq (step e1) e2

step (And BFalse e2) = BFalse
step (And BTrue e2) = e2
step (And e1 e2) = And (step e1) e2

step (Or BTrue e2) = BTrue
step (Or BFalse e2) = e2
step (Or e1 e2) = Or (step e1) e2

step (If BTrue e1 e2) = e1
step (If BFalse e1 e2) = e2
step (If e e1 e2) = If (step e) e1 e2

step (App (Lam x tp e1) e2) = if (isValue e2) then
                                subst x e2 e1
                              else
                                App (Lam x tp e1) (step e2)

step (ConstructorList e1 e2) = if (isValue e1) then
                                 if (isValue e2) then
                                   ConstructorList e1 e2
                                 else
                                   ConstructorList e1 (step e2)
                               else
                                 ConstructorList (step e1) e2

step (HeadList (ConstructorList e1 e2)) = e1
step (HeadList e1) = HeadList (step e1)

step (TailList (ConstructorList e1 e2)) = e2
step (TailList e1) = TailList (step e1)

eval :: Expr -> Expr
eval e = if isValue e then
           e
         else
           eval (step e)
