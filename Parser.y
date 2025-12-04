{
module Parser where 

import Lexer 
}

%name parser 
%tokentype { Token }
%error { parseError }

%left "||"
%left "&&"
%left '+' '-'
%left '*'
%left listAdd listHead listTail

%token 
    num             { TokenNum $$ }
    true            { TokenTrue }
    false           { TokenFalse }
    '+'             { TokenPlus }
    '*'             { TokenTimes }
    "&&"            { TokenAnd }
    "||"            { TokenOr }
    '('             { TokenLParen }
    ')'             { TokenRParen }
    '['             { TokenLBracket }
    ']'             { TokenRBracket }
    'if'            { TokenIf }
    'then'          { TokenThen }
    'else'          { TokenElse }
    'list'          { TokenList }
    '.add'          { TokenListAdd }
    '.head'         { TokenListHead }
    '.tail'         { TokenListTail }

%% 

Exp     : num                               { Num $1 }
        | true                              { BTrue }
        | false                             { BFalse }
        | Exp '+' Exp                       { Add $1 $3 }
        | Exp '*' Exp                       { Times $1 $3 }
        | Exp "&&" Exp                      { And $1 $3 }
        | Exp "||" Exp                      { Or $1 $3 }
        | '(' Exp ')'                       { Paren $2 }
        | 'if' Exp 'then' Exp 'else' Exp    { If $2 $4 $6 }
        | 'list' '[' ']'                    { EmptyList TNum}
        | Exp '.add''(' Exp ')'             { ConstructorList $4 $1 }
        | Exp '.head''('')'                 { HeadList $1 }
        | Exp '.tail''('')'                 { TailList $1 }

{ 

parseError :: [Token] -> a 
parseError _ = error "Syntax error!"

}