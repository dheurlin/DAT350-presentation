# Evaluation

## Values

Every AE can be evaluated into one of...

* Number
* Function
* List of values

## Environment

An AE `X` has a value relative to an environment `E`

```
    E : Identifier → Value
```

that binds free variables in `X`.

This value will be denoted as `val E X`

## Evaluation

1. Recursive self evaluator (like LISP)
2. Machine for stepwise evaluation

Both return `val E X`
