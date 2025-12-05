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

2. **Compilar o código-fonte (GHC):**
   Compile o código-fonte.

   ```bash
   ghc Main.hs
   ```

3. **Executar o Interpretador:**
   Execute o interpretador compilado.

   ```bash
   echo "SUA_EXPRESSÃO_AQUI" | ./Main
   ```

## Exemplos de Uso

### 1. Aritmética Básica

```bash
-- Soma
echo "10+20" | ./Main
-- Resultado: Num 30

-- Multiplicação com precedência
echo "2+3*4" | ./Main
-- Resultado: Num 14
```

### 2. Lógica Booleana e Condicionais

```bash
-- Operador OR (||)
echo "true || false" | ./Main
-- Resultado: BTrue

-- Condicional IF/THEN/ELSE
echo "if true then 1 else 0" | ./Main
-- Resultado: Num 1
```

### 3. Manipulação de Listas

A linguagem suporta listas (ex: `list[]` cria uma lista vazia).

```bash
-- Criar uma lista vazia
echo "list[]" | ./Main
-- Resultado: EmptyList TNum

-- Adicionar elementos (.add)
-- Nota: O elemento é adicionado ao início da lista
echo "list[].add(1)" | ./Main
-- Resultado: ConstructorList (Num 1) (EmptyList TNum)

-- Encadeamento de adições
echo "list[].add(2).add(1)" | ./Main
-- Resultado: Lista [1, 2]

-- Pegar a cabeça da lista (.head())
echo "list[].add(10).head()" | ./Main
-- Resultado: Num 10

-- Pegar a cauda da lista (.tail())
echo "list[].add(20).add(10).tail()" | ./Main
-- Resultado: Lista contendo apenas [20]
```

### 4. Exemplo Complexo

Misturando condicionais e listas:

```bash
echo "if true then list[].add(99) else list[]" | ./Main
-- Resultado: ConstructorList (Num 99) (EmptyList TNum)
```
