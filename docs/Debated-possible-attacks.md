
### JT's signature scheme

Y: @tromp I can confirm that your signature scheme does indeed produce a final signature/pubkey that validates properly 

JT: cool. not sure if we should worry about chosen public key attacks though

Y: how would one work?

JT: if receiver has blinding key rR and sender has sR, then sender publishes sR*G, and receiver publishes rR*G+sR*G. Then excess becomes rR*G+sR*G - sR*G = rR*G

Y: right...rRG+sRG is the published key anyhow

JT: and can be signed by receiver only. but it seems we're safe because of needed range proofs

Y: Ah, yes okay I recall that conversation now...

JT: which receiver shldnt be able to produce without knowing (rR+sR)

Y: Yes, this only really works because we have range proofs in place

TODO: ask Andrew is this a sensible solution

TODO: ask Andred to look at secp additions Y made to support the scheme
