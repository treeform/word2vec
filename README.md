# word2vec - for Nim

![Word2vec Logo](docs/word2vecLogo.png)

[Word2vec](https://en.wikipedia.org/wiki/Word2vec) can be used to turn text into vectors that encode the meaning.
You can use these vectors to compare similarities between texts.


## Exmaple

```nim
import word2vec

load(300) # load huge binary file
let
    aVec = text2vec("Cat set on a red wall")
    bVec = text2vec("Dog set on a red fence")
# how different are they?
echo dist(aVec, bVec)
```

<!--
TODO:

From famous [king - man + woman is queen; but why?](https://p.migdal.pl/2017/01/06/king-man-woman-queen-why.html)

```nim
import word2vec

load(300) # load huge binary file
let vec = word2vec("king") - word2vec("man") + word2vec("woman")
echo vec2world(vec)
``` -->

## Getting started

This library uses alreayd created [GloVe](https://nlp.stanford.edu/projects/glove/) vectors. There is no need to train your own vectors.

Beforey you start you need to download and convert:
* Download the GloVe vectors: https://nlp.stanford.edu/projects/glove/
* Unzip the `glove.6B.zip`
* Run word2vecloader.nim to convert text files into faster to load binary files.

```sh
mkdir glovebin
cd glovebin
wget http://nlp.stanford.edu/data/glove.6B.zip
unzip love.6B.zip
cd ..
nim c -r tools/word2vecloader.nim
```

