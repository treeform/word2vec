# word2vec

Word2vec can be used to turn text into vectors that encode the meanting.
You can use these vectors to compare simmilarties between texts.

Exmaple:

```nim
import word2vec
let
    aVec = text2vec("Cat set on a red wall")
    bVec = text2vec("Dog set on a red fence")
# how different are they?
echo dist(aVec, bVec)
```