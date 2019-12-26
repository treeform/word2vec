# word2vec

Word2vec can be used to turn text into vectors that encode the meanting.
You can use these vectors to compare simmilarties between texts.

Exmaple:

```nim
import word2vec

load(300) # load huge binary file
let
    aVec = text2vec("Cat set on a red wall")
    bVec = text2vec("Dog set on a red fence")
# how different are they?
echo dist(aVec, bVec)
```


Beforey you start you need to:
* Download the GloVe vectors: https://nlp.stanford.edu/projects/glove/
* Unzip the `glove.6B.zip`
* Run word2vecloader.nim

```sh
mkdir glovebin
cd glovebin
wget http://nlp.stanford.edu/data/glove.6B.zip
unzip glove.6B.zip
cd ..
nim c -r tools/word2vecloader.nim
```

