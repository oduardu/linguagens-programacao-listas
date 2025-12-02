module Examples where

import Interpreter
import Lexer
import TypeChecker

-- 1 - Lista [3, 2, 1]
listaVazia :: Expr
listaVazia = EmptyList TNum

lista1 :: Expr
lista1 = ConstructorList (Num 1) listaVazia

lista2 :: Expr
lista2 = ConstructorList (Num 2) lista1

listaFinal :: Expr
listaFinal = ConstructorList (Num 3) lista2

-- 2 - Head e Tail
headOp :: Expr
headOp = HeadList listaFinal

tailOp :: Expr
tailOp = TailList listaFinal

segundoElemento :: Expr
segundoElemento = HeadList (TailList listaFinal)

-- 3 - Expressões dentro da lista
minhaLista :: Expr
minhaLista = ConstructorList (Num 5) (ConstructorList (Num 6) (EmptyList TNum))

somaComHead :: Expr
somaComHead = Add (HeadList minhaLista) (Num 10)

-- Função Lambda: \x:TList TNum. TailList (TailList x)
func_tail_tail :: Expr
func_tail_tail = Lam "x" (TList TNum) (TailList (TailList (Var "x")))

aplicacao_list :: Expr
aplicacao_list = App func_tail_tail minhaLista
