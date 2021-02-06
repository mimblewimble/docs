# Commitments

In cryptography a Commitment (or commitment scheme) refers to a concept which can be imagined like a box with a lock. You can put something into the box (for example a piece of a paper with a secret number written on it), lock it and give it to another person (or the public).

The other person doesn't know yet what's the secret number in the box, but if you decide to publish your secret number later in time and want to prove that this really is the secret which you came up with in the first place (and not a different one) you can prove this simply by giving the key of the box to the other person.

They can unlock the box, compare the secret within the box with the secret you just published and can be sure that you didn't change your secret since you locked it. You "committed" to the secret number beforehand, meaning you cannot change it between the time of commitment and the time of revealing.

They have two important properties:

* **Hiding** - Nobody but the committer can see or infer the actual value behind the commitment.
* **Binding** - The committer can't change the value after the commitment is published.

ECC can be used to create a commitment. Let’s say we want to commit to the value `8`.

```text
commit (8)  ->  8*G
```

To everybody else, our commitment `8*G` just looks like a random point, and we publish it. Some time later we reveal our value.

```text
reveal 8
```

And now any observer could multiply our stated value 8, by the public point G and verify that their result is equal to the commitment we published ealier.

```text
verify (8, commitment) == 8*G  ? --> True/False
```

However, there’s a major issue. If our value is within a small range, which is typically the case, it’s simple for anybody to find out what value we committed to, even if we don’t reveal it; by trying out (brute-forcing) different values, they can find the one value that, when multiplied by `G`, matches the original commitment.

!!! note "Example"
    Say we're betting on how many goals a team would score by the end of the year. Our guess is 23, and we commit to it by publishing the commitment `23*G`. Problem is, it would be trivial for anybody to uncover our guess simply by trying to commit to 1, 2, 3, 4 etc. and checking each result if it's equal to our commitment. In this case, our value will be revealed after only 23 simple steps.

What’s the solution?

## Blinding Factor

The issue is solved by adding a blinding factor r, which is a random 256-bit integer (range 0 to 2^256, same as a typical private key) used to blind the value so that it can’t be guessed and uncovered.

We could try adding the blinding factor by comitting `(8+r)*G` and then revealing `8` and `r`. But, doing so breaks the binding property of the commitment, because instead of revealing value `8` and blinding factor `r`, we could reveal `7` and `r+1` or any other value.

Therefore, we require a different method to include `r`.

## Pedersen Commitments

Introducing **G**’s twin, **H**.

**H** is another generator point, distinct from **G** (note how it’s the next letter in the alphabet). Both are nothing-up-my-sleeve-points, meaning nobody knows `n` such that `n*G = H`. Using **H** we can blind the value while keeping the commitment binding.

```text
r*G + v*H
```

This specific form of commitement is called a *Pedersen Commitment.*

**A Mimblewimble output is just a Pedersen Commitment**, as we’ll soon see. Its values are as follows:

* `r` is the blinding factor, and `r*G` is the public key point for `r`   (using G as generator point).

* `v` is the value committed, and `v*H` is the public key point for `v` (using H as generator point).





## Homomorphic Commitments

Commitments with homomorphic properties means you can perform calculations on encrypted values without decrypting them first. The result of the computation is a commitment which is identical to the result if the operations had been performed on the unencrypted values.

They allow us to do as follows:

:   commit (x)  &rArr;  C~1~ </br>
	commit (y)  &rArr; C~2~ </br>
	commit (x+y) &rArr; Z = C~1~ + C~2~

If we add two commitments to each other, the result would be an entirely new, valid commitment, which actually commits to the value `x + y`. So we’re able to perform a math operation (addition) unto encrypted data (commitments) while keeping the underlying values “intact”.

Elliptic curve commitments indeed have these homomorphic properties. We can do the following:

```text
x*G + y*G => (x + y)*G
```

Notice how we add two different curve points and the result is a different point, which is a commitment to the sum of the values we’re hiding.

Similarly, we can add up two Pedersen Commitments. First let's create two of them:

* C~1~ = r~1~G + v~1~H
* C~2~ = r~2~G + v~2~H

The point **Z** (remember a commitment is simply a point on the curve) is the result of addition between points **C~1~** and **C~2~**.

```text
Z = C1 + C2
```

```text
Z = r1*G + r2*G + v1*H + v2*H
```

So we can calculate what **Z** is:

```text
Z = (r1 + r2)*G + (v1 + v2)*H
```

Hence point **Z** is a Pedersen commitment that is the sum of commitments **C~1~** and **C~2~**.

This is the foundation for the Elliptic-curve algebra used in Mimblewimble to prove both ownership of outputs (coins) and non-inflation.


[^1]: [Finessing commitments](https://joinmarket.me/blog/blog/finessing-commitments/)
