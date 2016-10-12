exprEl = document.getElementsByClassName('expr')[0]
currEl = document.getElementsByClassName('current')[0]
exprString = ""
evalString = ""
re = /([0-9.]*)\D*$/ # pick out last integer, ignoring possible crap after

for el in document.getElementsByClassName 'button'
  el.addEventListener "click", (ev) -> buttonHandler(ev.target.textContent)

buttonHandler = (text) ->

  switch text
    when "⌫" then backspaceHandler()
    when "AC" then acHandler()
    when  "=" then eqHandler(text)
    when "➕", "➖", "×", "➗" then operationHandler(text)
    when "(" then lbHandler()
    when ")" then rbHandler()
    else numberHandler(text)

  exprEl.textContent = exprString


# Handlers
#
# Number handler
# Raw numbers should not be placed behind a closing bracket.
# Other than that, it's all good.
numberHandler = (ch) ->
  if exprString.slice(-1) == ")"
    putErrorBox "Don't input a number directly after a closing bracket."
    return
  clearErrorBox()
  exprString += ch
  evalString += ch
  currEl.textContent = exprString.match(re)[1]

# Operation handler
# Minus can be used after any operator or bracket (and will negate the following
# number).
# Also translate unicode characters to ascii operators.
operationHandler = (ch) ->
  if ch is "➖" and exprString.slice(-1) is "➖"
    putErrorBox "Don't use two consecutive minus signs"
    return
  if exprString.slice(-1) is "" and ch in ["➕", "×", "➗"]
      putErrorBox "Don't begin expression with an operator other than a minus sign."
      return
  if ch in ["➕", "×", "➗"] and
  exprString.slice(-1) in ["➕", "×", "➗", "➖", "("]
    putErrorBox "Operators should be used between two legal expressions."
    return

  clearErrorBox()
  exprString += ch
  switch ch
    when "➕" then evalString += "+"
    when "×" then evalString += "*"
    when "➗" then evalString += "/"
    when "➖" then evalString += "-"

# Left Bracket Handler
# Left bracket can only appear after an operator or another opening bracket.
lbHandler = () ->
  if evalString.slice(-1) in ["+", "-", "*", "/", "("] or
     evalString.slice(-1) is ""
      clearErrorBox()
      exprString += "("
      evalString += "("
  else putErrorBox "Don't place an opening bracket after a number or closing bracket."

# Right bracket handler
# Right brackets can only appear after a number. End of story.
# Oh, and only if there are opened brackets unmatched somewhere.
rbHandler = () ->
  if evalString.slice(-1) in  ["+", "-", "*", "/", "("]
    putErrorBox "Parentheses should encompass a legal expression. Don't end on 
    an operator."
    return

  if unpaired(evalString) is 0
    putErrorBox "No matching opening parentheses found."
    return

  clearErrorBox()
  exprString += ")"
  evalString += ")"

# AC handler
# That was easy.
acHandler = ->
  clearErrorBox()
  exprString = ""
  evalString = ""
  currEl.textContent = ""

# Equals handler
# Equals only makes sense if all brackets are matched up and the last character
# is a number or a closing bracket.
eqHandler = (ch) ->
  if unpaired(evalString) isnt 0
    putErrorBox "Unpaired parenthesis left in expression."
    return
  if evalString.slice(-1) in ["+", "-", "*", "/", "("]
    putErrorBox "Only legal expressions can be evaluated.
    Don't end on an operator or opening parenthesis."
    return

  clearErrorBox()
  result = eval(evalString)
  currEl.textContent = result
  exprString = ""
  evalString = ""
       
# Backspace handler
# Pretty easy as well.
backspaceHandler = ->
  clearErrorBox()
  exprString = exprString.slice(0, -1)
  evalString = evalString.slice(0, -1)
  currEl.textContent = exprString.match(re)[1]

# Get number of opening brackets - number of closing brackets present in string.
unpaired = (str) ->
  lbMatches = str.match(/\(/g)
  rbMatches = str.match(/\)/g)
  numberOfLb = if lbMatches? then lbMatches.length else 0
  numberOfRb = if rbMatches? then rbMatches.length else 0
  return numberOfLb - numberOfRb

# Place the error box on the page, with transition
putErrorBox = (msg) ->
  clearErrorBox()

  wrapper = document.getElementsByClassName("wrapper")[0]
  err = document.createElement("div")
  content = document.createTextNode(msg)
  err.appendChild(content)
  err.classList.add("error")
  wrapper.appendChild(err)
  
  #Wait for DOM element to get created before adding class
  vis = -> err.classList.add "visible"
  setTimeout vis, 100


clearErrorBox = ->
  wrapper = document.getElementsByClassName("wrapper")[0]
  # Check if there is an errorbox present. If so, remove it.
  oldBox = wrapper.getElementsByClassName("error")[0]
  if oldBox?
    oldBox.classList.remove("visible")
    del = -> wrapper.removeChild oldBox
    setTimeout del, 500
