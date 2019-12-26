import word2vec

load(300) # load huge binary file
let vec = word2vec("king") - word2vec("man") + word2vec("woman")
echo vec2world(vec)