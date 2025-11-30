module TypeChecker where 

import Lexer 

type Ctx = [(String, Ty)]

typeof :: Ctx -> Expr -> Maybe Ty 
typeof ctx BTrue = Just TBool 
typeof ctx BFalse = Just TBool 
typeof ctx (Num n) = Just TNum 
typeof ctx (Add e1 e2) = case (typeof ctx e1, typeof ctx e2) of 
                           (Just TNum, Just TNum) -> Just TNum 
                           _                      -> Nothing
-- Implementar typeof para Times 
typeof ctx (And e1 e2) = case (typeof ctx e1, typeof ctx e2) of 
                           (Just TBool, Just TBool) -> Just TBool 
                           _                        -> Nothing

typeof ctx (Or e1 e2) = case (typeof ctx e1, typeof ctx e2) of 
                           (Just TBool, Just TBool) -> Just TBool 
                           _                        -> Nothing

typeof ctx (If e e1 e2) = case typeof ctx e of 
                            Just TBool -> case (typeof ctx e1, typeof ctx e2) of 
                                            (Just t1, Just t2) | t1 == t2  -> Just t1 
                                                               | otherwise -> Nothing 
                                            _ -> Nothing  
                            _ -> Nothing 

typeof ctx (Times e1 e2) = case (typeof ctx e1, typeof ctx e2) of 
                           (Just TNum, Just TNum) -> Just TNum 
                           _                      -> Nothing

typeof ctx (Var x) = lookup x ctx 
typeof ctx (Lam x tp b) = let ctx' = (x,tp) : ctx 
                            in case (typeof ctx' b) of 
                                 Just tr -> Just (TFun tp tr)
                                 _ -> Nothing 

typeof ctx (App e1 e2) = case typeof ctx e1 of 
                           Just (TFun tp tr) -> case typeof ctx e2 of 
                                                  Just t2 | t2 == tp -> Just tr 
                                                  _ -> Nothing 
                           _ -> Nothing 

 -- Checker da Lista
typeof ctx (EmptyList t) = Just (TList t)

typeof ctx (ConstructorList e1 e2) = case (typeof ctx e1, typeof ctx e2) of 
                         (Just tHead, Just (TList tTail)) | tHead == tTail -> Just (TList tHead)
                         _ -> Nothing 

typeof ctx (HeadList e1) = case typeof ctx e1 of 
                          Just (TList t) -> Just t
                          _ -> Nothing

typeof ctx (TailList e1) = case typeof ctx e1 of 
                          Just (TList t) -> Just (TList t)
                          _ -> Nothing


typecheck :: Expr -> Expr 
typecheck e = case typeof [] e of 
                Just _ -> e 
                _      -> error "Type error!"
