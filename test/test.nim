import word2vec

load(300) # load huge binary file
let
    aVec = text2vec("Cat set on a red wall")
    bVec = text2vec("Dog set on a red fence")
# how different are they?
echo dist(aVec, bVec)