module Lexer where

import Data.Char

data Token = TokenNum Int
           | TokenTrue
           | TokenFalse
           | TokenPlus
           | TokenTimes
           | TokenAnd
           | TokenOr
           | TokenEq
           | TokenNeq
           | TokenLParen
           | TokenRParen
           | TokenLBracket
           | TokenRBracket
           | TokenIf
           | TokenThen
           | TokenElse
           | TokenList
           | TokenListAdd
           | TokenListHead
           | TokenListTail
           deriving Show

data Expr = Num Int
          | BTrue
          | BFalse
          | Add Expr Expr
          | Times Expr Expr
          | And Expr Expr
          | Or Expr Expr
          | Eq Expr Expr
          | Neq Expr Expr
          | Paren Expr
          | If Expr Expr Expr
          | Var String
          | Lam String Ty Expr
          | App Expr Expr
          | EmptyList Ty
          | ConstructorList Expr Expr
          | HeadList Expr
          | TailList Expr
          deriving Show

data Ty = TNum
        | TBool
        | TFun Ty Ty
        | TList Ty
        deriving (Show, Eq)

lexer :: String -> [Token]
lexer [] = []
lexer ('+':cs) = TokenPlus : lexer cs
lexer ('*':cs) = TokenTimes : lexer cs

lexer ('(':cs) = TokenLParen : lexer cs
lexer (')':cs) = TokenRParen : lexer cs
lexer ('[':cs) = TokenLBracket : lexer cs
lexer (']':cs) = TokenRBracket : lexer cs

lexer ('=':'=':cs) = TokenEq : lexer cs
lexer ('!':'=':cs) = TokenNeq : lexer cs

lexer ('&':'&':cs) = TokenAnd : lexer cs
lexer ('|':'|':cs) = TokenOr : lexer cs
lexer ('i':'f':cs) = TokenIf : lexer cs
lexer ('t':'h':'e':'n':cs) = TokenThen : lexer cs
lexer ('e':'l':'s':'e':cs) = TokenElse : lexer cs

lexer ('.':'a':'d':'d':cs) = TokenListAdd : lexer cs
lexer ('.':'h':'e':'a':'d':cs) = TokenListHead : lexer cs
lexer ('.':'t':'a':'i':'l':cs) = TokenListTail : lexer cs

lexer (c:cs) | isSpace c = lexer cs
             | isDigit c = lexNum (c:cs)
             | isAlpha c = lexKw (c:cs)
lexer _ = error "Lexical error"

lexNum cs = case span isDigit cs of
              (num, rest) -> TokenNum (read num) : lexer rest

lexKw cs = case span isAlpha cs of
                ("true", rest) -> TokenTrue : lexer rest
                ("false", rest) -> TokenFalse : lexer rest
                ("if", rest)    -> TokenIf : lexer rest
                ("then", rest)  -> TokenThen : lexer rest
                ("else", rest)  -> TokenElse : lexer rest
                ("list", rest) -> TokenList : lexer rest
