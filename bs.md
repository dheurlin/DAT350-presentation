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
  identifier X → E X
  λ-exp X      → f
     where f x = val(extend E (bv X, x))(body X)
  else         → {val E (rator X)}(val E (rand X))

```

`extend E (key, value)` extends environment `E` by mapping `key` to `value`.

(slightly different notation in paper)

# Mechanical evaluation

## Mechanical evaluation

**Above**: formula to derive value from AE

**Now**: formula to advance one step through computation

## Closure

explain

<!-- Can't really return a function, need to return a data object that we can
put on the stack -->

denote this closure by `<(E, bv X), [body X]>`

## State

* **Stack** - list of intermediate results awaiting use
* **Environment** - name/value pairs
* **Control** - items awaiting evaluation
    - AE
    - `ap`, marks that items on stack are ready to be used
* **Dump** - a complete state. Used to "push" our current state before
  evaluating a closure

We denote this as `(S, E, C, D)`

## Transform

Transition rule that will gradually transform our state towards the final
evaluation `val E X`

    Transform : State → State
    Transform (S, E, C, D) = (S', E', C' D')

In the end, will have `val E X` on top of the stack

**Key idea:** Go through each item in `C`, evaluate it, put result on stack.

### Two cases:
* C is null
* C is not null

## C is not null

Inspect `head C`:


* **Identifier X** : put `lookup X E` on stack
* **λ-expression X**: put the closure `<(E, bv X), [body X]>` on stack
* **Combination X**: replace `C` by `[rand X, rator X, ap] ++ tail C`

Advance to next item by replacing `C` with `tail C` unless otherwise specified

## `head C` is `ap`

`ap` is a marker that tells us to apply the *head* of the stack (`head S`) to
the *second* element of the stack (`2nd S`)

### Not a closure
pop top two elements from stack, apply 1st to 2nd, push result

### Closure `<(E', x), [body]>`:

Need to evaluate `body` in environment where `x` = `2nd S`

* replace `S`  with `[]`
* replace `E` with `extend E (x, 2nd S)`
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
  null C → (head S : S', E', C, D')
    where S',E',C,D' = D
  else →
    identifier X → ((lookup X E):S, E, tail C, D)
    λexp X → [<(E, bv X), [body X]> : S, E, tail C, D]
    X = ap → (head S == <(E', x), [body]>) → # closure
                  ([], extend E' (x, 2nd S), C, (drop 2 S, E, tail C, D))
               else → # not closure
                   ((head S) $ (2nd S) : drop 2 S, E,  tail C, D)
    else → (S, E, [rand X, rator X, ap] ++ C, D)
    where X = head C
```

