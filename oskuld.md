## Content
* Defining our expression language
* Rules for evaluation
* Mechanical evaluation of expressions


# The language

## Applicative expressions (example)

$$ \frac{x + 2 \times x}{4} $$
\center `/(+(x, ×(2, x)), 4)`

\rule{5cm}{0.5pt}

Applying `(2, 3)` to an add function:
\center `(λ(a, b). +(a, b)) (2, 3)`

## Applicative expressions (structure)
An applicative expression is either

| an **identifier**
| or a **$\lambda$-exp**, which is
|     a **bound variable** part, which is
|        an identifier
|        or a list of identifiers *(!)*
|     and a **body** part, which is
|        an AE
| or a **combination**, which is
|     an **operator**, which is
|        an AE
|     and an **operand**, which is
|        an AE

## Constructed objects
Defined by _structure definitions_.

constructors
  : For constructing COs.
    Denoted as `[]`, `:`, ...

predicates
  : For differntiating between alternatives.
    Denoted as `isNull`, `isIdentifier`, `isλexp` ...

selectors
  : For selecting components.
    Denoted as `head`, `tail`, `bv`, `body`, `operand`, `operator`.

## Some more AE encoding examples
### ... where
\begin{align*}
  u×2 - v+&1, \\
    \textbf{where }& u = 10 + x \\
    \textbf{and }  & v = 20 × x
\end{align*}
\hspace{0.5cm}
\center `(λ(u, v). u×2 - v+1) (10+x, 20×x)`

## Some more AE encoding examples
### Conditionals
```
b == 0 → 0
else   → a / b
```
\hspace{0.5cm}
```
if(b == 0) (λ(). 0, λ(). a/b) ()
```

## Some more AE encoding examples
### (Mutually) recursive definitions
Given the Y-combinator `Y` which find the fixpoint of a function (such that $x = f(x)$).

```
f(4)
  where recursive f(n) =
      n == 0 → 1
      else   → n × f(n - 1)
```
```
(λfac. fac(4)) (Y
                  (λf. λn. n == 0 → 1
                           else   → n × f(n - 1)))
```

# Evaluation

## Values

Every AE can be evaluated into one of...

* Number
* Function
* List of values

## Environment

An AE `X` has a value relative to an environment `E`,

```
    E : Identifier → Value
```

that binds free variables in `X`.

This value will be denoted as `val E X`, "the value of `X` in `E`"

## Evaluation

1. Recursive self evaluator (like LISP)
2. Machine for stepwise evaluation

Both return `val E X`

## Rules for evaluation

For an AE `X`:

**R1**. If `X` is an identifier, `val E X` is `E X`

**R2**. If `X` is a λ-expression, `val E X` is a function that waits for the argument
of the λ, then evaluates the λ-body in an environment where the bound variables
of `X` are substituted with the supplied argument

**R3**. If `X` is a combination, `val E X` is found by evaluating the operator and
operand, then applying the operator to the operand.

## `val` as an applicative expression


```
recursive val E X =
  isIdentifier X → E X
  isλ-exp X      → f
     where f x = val (extend E (bv X, x)) (body X)
  else           → (val E (operator X)) (val E (operand X))

```

`extend E (key, value)` extends environment `E` by mapping `key` to `value`.

(slightly different notation in paper)
