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
  if ch is "−" and exprString.slice(-1) is "−"
    putErrorBox "Don't use two consecutive minus signs"
    return
  if exprString.slice(-1) is "" and ch in ["×", "+", "÷"]
      putErrorBox "Don't begin expression with an operator other than a minus sign."
      return
  if ch in ["×", "+", "÷"] and
  exprString.slice(-1) in ["−", "×", "+", "÷", "(", "."]
    putErrorBox "Operators should be used between two legal expressions."
    return

  clearErrorBox()
  exprString += ch
  switch ch
    when "+" then evalString += "+"
    when "×" then evalString += "*"
    when "÷" then evalString += "/"
    when "−" then evalString += "-"

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


