import tables, strutils, strformat, streams

proc genBin(power: int) =
  var words: string
  var vectors: seq[float32]
  var i = 0
  var fileName = &"glovebin/glove.6B.{$power}d.txt"
  echo "generating ", fileName
  for line in fileName.lines():
    let line = line.split(" ")
    let word = line[0]
    #var vector = newSeq[float32]()
    var count = 0
    for e in line[1..^1]:
      vectors.add parseFloat(e)
      inc count
    #echo count  
    assert count == power
    #vectors[word] = vector
    words.add(word)
    words.add("\n")
    if i mod 10000 == 0: 
      echo i
    inc i
  writeFile(&"glovebin/words.6B.{$power}d.txt", words)
  var bin = newFileStream(&"glovebin/vectors.6B.{$power}d.float32", fmWrite)
  bin.writeData(unsafeAddr vectors[0], vectors.len * 4)
  bin.close()

genBin(50)
genBin(100)
genBin(200)
genBin(300)
