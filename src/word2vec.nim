import tables, strutils, math, streams, strformat


type
  BestN*[T] = ref object
    ## Keeps the best num elements
    scores*: seq[float32]
    objs*: seq[T]
    num*: int

proc newBestN*[T](number: int): BestN[T] =
  ## Creates a new best of N array
  result = BestN[T]()
  result.num = number
  result.scores = newSeq[float32](0)
  result.objs = newSeq[T](0)
  
proc add*[T](bestN: BestN[T], score: float32, obj: T) =
  ## Ads a score and a best element
  var inserted = false
  for i, s in bestN.scores:
    if s > score:
      bestN.scores.insert(score, i)
      bestN.objs.insert(obj, i)
      inserted = true
      break
  if not inserted and bestN.scores.len < bestN.num:
    bestN.scores.add(score)
    bestN.objs.add(obj)
  elif bestN.scores.len > bestN.num:
    bestN.scores.setLen(bestN.num)
    bestN.objs.setLen(bestN.num)

proc len*[T](bestN: BestN[T]): int =
  ## Number of elements, up to N
  bestN.scores.len

proc normalize*(vector: var seq[float32]) =
  ## Normalizes a vector to be length 1 vector.
  var total: float32 = 0.0
  for e in vector:
    total += e*e
  total = sqrt(total)
  for i, e in vector:
    vector[i] /= total
  
proc `+=`*(a: var seq[float32], b: seq[float32]) =
  ## Add a vector in place
  assert a.len == b.len
  for i, e in b:
    a[i] += e

proc dist*(a, b: seq[float32]): float32 =
  ## Distance between two vectors
  assert a.len == b.len
  var total: float32 = 0.0
  for i in 0..<a.len:
    total += (a[i] - b[i]) * (a[i] - b[i])
  return sqrt(total)


var power = 50
var words = newTable[string, int]()
var vectors: seq[float32]
var i = 0

proc load*(powerLoad: int = 50, dir = "glovebin") =
  power = powerLoad
  let fileName = &"{dir}/words.6B.{$power}d.txt"
  for word in fileName.lines():
    words[word] = i
    inc i

  var f = newFileStream(&"{dir}/vectors.6B.{$power}d.float32")
  vectors = newSeq[float32](power * words.len)
  discard f.readData(unsafeAddr vectors[0], vectors.len*4)
  f.close()


proc splitWords(text: string): seq[string] =
  ## Splits a string into words.
  var w = ""
  for c in text:
    if c in {' ', '.', ',', '?', ';'}:
      if w != "":
        result.add w
      w = ""
    else:
      w.add(c.toLowerAscii())
  if w != "":
    result.add w

  
proc word2vec(word: string): seq[float32] =
  ## Turns a word into vector representaion 
  if word notin words:
    return newseq[float32](power)
  let idx = words[word] 
  vectors[idx * power ..< (idx + 1) * power]


proc text2vec*(text: string): seq[float32] =
  ## Turns text into vector representaion
  result = newSeq[float32](power)
  for word in text.splitWords:
    if word notin words:
      continue  
    let idx = words[word] 
    result += vectors[idx * power ..< (idx + 1) * power]
  result.normalize()


proc wordPrompt() =
  while true:
    var a = stdin.readLine()
    var aVec = word2vec(a)
    var n = 0
    var bestN = newBestN[string](20)
    for word, idx in words:
      let vector = vectors[idx * power ..< (idx + 1) * power]
      let d = dist(aVec, vector)
      bestN.add(d, word)
      inc n

    for i in 0 ..< bestN.num:
      echo bestN.scores[i], ": ", bestN.objs[i]

when isMainModule:

  load(300)

  let title = "The dog is out of the bag."
  let others = [
    "New car hare",
    "Space attack",
    "Lets go get the box",
    "feline is here",
    "filine is out of the box",
    "the kitty is out of the bag",
    "filine box",
    "other",
    "Space craft is flying along."
  ]

  var bestN = newBestN[string](20)
  let titleVec = text2vec(title)
  for other in others:
    let otherVec = text2vec(other)
    let d = dist(titleVec, otherVec)
    bestN.add(d, other)

  for i in 0 ..< bestN.scores.len:
    echo bestN.scores[i], ": ", bestN.objs[i]

