# Linguagens de Programação - Interpretador com Listas

Este projeto implementa um interpretador simples em Haskell para uma linguagem com suporte a operações aritméticas, booleanas e manipulação de listas.

## Pré-requisitos

Você precisará ter o ambiente Haskell instalado (GHC, Cabal). Além disso, são necessárias as ferramentas `happy` (Parser).

```bash
# Instalar Happy via Cabal
cabal update
cabal install happy

# Certifique-se de que o caminho de instalação está no seu PATH
# No Mac/Linux geralmente é ~/.cabal/bin ou ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"
```

## Compilação e Execução

1. **Gerar o Parser:**
   Antes de rodar o projeto, você precisa gerar os arquivos Haskell a partir das definições `.y`.

   ```bash
   # Se o happy estiver no PATH:
   happy Parser.y
   ```

2. **Iniciar o Interpretador (GHCi):**
   Carregue o módulo principal no interpretador interativo do Haskell.

   ```bash
   ghci Interpreter.hs
   ```

## Exemplos de Uso

Dentro do GHCi, você pode executar códigos da linguagem usando a composição das funções `eval`, `parser` e `lexer`.

A sintaxe básica é:
```haskell
eval (parser (lexer "SEU_CODIGO_AQUI"))
```

### 1. Aritmética Básica
```haskell
-- Soma
eval (parser (lexer "10 + 20"))
-- Resultado: Num 30

-- Multiplicação com precedência
eval (parser (lexer "2 + 3 * 4"))
-- Resultado: Num 14
```

### 2. Lógica Booleana e Condicionais
```haskell
-- Operador OR (||)
eval (parser (lexer "true || false"))
-- Resultado: BTrue

-- Condicional IF/THEN/ELSE
eval (parser (lexer "if true then 1 else 0"))
-- Resultado: Num 1
```

### 3. Manipulação de Listas
A linguagem suporta listas (ex: `list[]` cria uma lista vazia).

```haskell
-- Criar uma lista vazia
eval (parser (lexer "list[]"))
-- Resultado: EmptyList TNum

-- Adicionar elementos (.add)
-- Nota: O elemento é adicionado ao início da lista
eval (parser (lexer "list[].add(1)"))
-- Resultado: ConstructorList (Num 1) (EmptyList TNum)

-- Encadeamento de adições
eval (parser (lexer "list[].add(2).add(1)"))
-- Resultado: Lista [1, 2]

-- Pegar a cabeça da lista (.head())
eval (parser (lexer "list[].add(10).head()"))
-- Resultado: Num 10

-- Pegar a cauda da lista (.tail())
eval (parser (lexer "list[].add(20).add(10).tail()"))
-- Resultado: Lista contendo apenas [20]
```

### 4. Exemplo Complexo
Misturando condicionais e listas:

```haskell
eval (parser (lexer "if true then list[].add(99) else list[]"))
```