# Mechanical evaluation

## Mechanical evaluation

**Above**: formula to derive value from AE

**Now**: formula to advance one step through computation

## Transform

Transition rule that will gradually transform our state towards the final
evaluation `val E X`

    Transform : State → State
    Transform (S, E, C, D) = (S', E', C' D')

In the end, will have `val E X` on top of the stack

**Key idea:** Go through each item in `C`, evaluate it, put result on stack.


## State

* **Stack** - list of intermediate results awaiting use
* **Environment** - name/value pairs
* **Control** - items awaiting evaluation
    - AE
    - `ap`, marks that items on stack are ready to be used
* **Dump** - a complete state. Used to "push" our current state before
  evaluating a closure

We denote this as `(S, E, C, D)`

## Closure

The value returned by a λ-expression

Save the environment the AE `X` was evaluated in, together with the body of the
lambda expression

Makes sure all variables in the body are still bound

denote this closure by `<(E, bv X), [body X]>`

## C is not null

Inspect `head C`:


* **Identifier X** : put `lookup X E` on stack
* **λ-expression X**: put the closure `<(E, bv X), [body X]>` on stack
* **Combination X**: replace `C` by `[operand X, operator X, ap] ++ tail C`

Advance to next item by replacing `C` with `tail C` unless otherwise specified

## `head C` is `ap`

`ap` is a marker that tells us to apply the *head* of the stack (`head S`) to
the *second* element of the stack (`2nd S`)

if `head S` is...

### Not a closure:

pop top two elements from stack, apply 1st to 2nd, push result

### Closure `<(E', x), [body]>`:

Need to evaluate `body` in environment where `x` = `2nd S`

* replace `S`  with `[]`
* replace `E` with `extend E' (x, 2nd S)`
* replace `C` with `[body]`
* replace `D` with `(drop 2 S, E, tail C, D)` (we return to this state after we
  leave the closure)


## C is null

Nothing left to evaluate, "return" from closure by restoring former state but
adding result of closure to stack

**Current state**: `(S, E, C = [], D = (S', E', C', D'))`

**New state**: `(head S : S', E', C', D)`


## As an AE

```
Transform(S,E,C,D) =
  isNull C → (head S : S', E', C, D')
    where S',E',C,D' = D
  else →
    isIdentifier X → ((lookup X E):S, E, tail C, D)
    isλexp X → [<(E, bv X), [body X]> : S, E, tail C, D]
    X == ap → (head S == <(E', x), [cBody]>) → # closure
                  ([], extend E' (x, 2nd S), [cBody], (drop 2 S, E, tail C, D))
               else → # not closure
                   ((head S) $ (2nd S) : drop 2 S, E,  tail C, D)
    else → (S, E, [operand X, operator X, ap] ++ C, D)
    where X = head C
```

# Example

## Example

Consider the expression `(λx. y + x) 5`

As an AE explicitly:

```
combinator
  operator :
    λexp
     bv   : identifier 'x',
     body :
       combination
        operator : {identifier '+'},
        operand : [identifier 'y', identifier 'x']
  operand : identifier '5'
```

## Example (2) - Environment

Environment for `(λx. y + x) 5`

```
E '5' = 5
E 'y' = 10
E '+' = f where f [x, y] = f + y
```

## Example (3) - Stepwise evaluation

\begin{table}[]
\begin{tabular}{llll|l}
Stack  & Env & Control & Dump & Comment \\ \hline
\text{[]}                           &  E &  [(λx. '+' [y x]) 5] &  [] & \\
\text{[]}                           &  E &  ['5', λx. '+' [y x], ap] &  [] &         (combination) \\
\text{[5]}                          &  E &  [λx. '+' [y x], ap] &  []     &         (lookup '5' in env)\\
\text{[<(E, 'x'), ['+' [y x]]>, 5]} &  E &  [ap] &  [] &   (closure)\\
\text{[]}                           &  E'$_{x→5}$ &  ['+' [y x]] &  ([], E, [], [])   &  (extend env, save old state)\\
\text{[]}                           &  E'$_{x→5}$ &  [[y x], '+' ,  ap] &  ([], E, [], []) & (combination)\\
\text{[[10 5]]}                     &  E'$_{x→5}$ &  ['+', ap] &  ([], E, [], [])  & (lookup x, y in env)\\
\text{[+ ,  [10 5]]}                &  E'$_{x→5}$ &  [ap] &  ([], E, [], [])  & (lookup + in env)\\
\text{[15]}                         &  E'$_{x→5}$ &  [] &  ([], E, [], [])  & (ap applies function)\\
\text{[15]}                         &  E &  [] &  [] & (empty control,  restore old state)
\end{tabular}
\end{table}

# Takeaways

## Takeaways

* Structure definitions
    - more convenient than LISP list accessors
    - Abstracts away ordering of members
* Mechanical evaluation
    - Solves dereferencing of variables by introducing closures
    - Later versions used as target for FP compilers

# The end
