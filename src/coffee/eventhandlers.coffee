# Button Handler. Defers to more specific handlers depending on input.
buttonHandler = (text) ->

  switch text
    when "⌫" then backspaceHandler()
    when "AC" then acHandler()
    when  "=" then eqHandler(text)
    when "−", "×", "+", "÷" then operationHandler(text)
    when "(" then lbHandler()
    when ")" then rbHandler()
    else numberHandler(text)

  exprEl.textContent = exprString


# Key handler. Defers to more specific handlers and set button active.
keyHandler = (ev) ->
  key = if ev.key? then ev.key else String.fromCharCode(ev.charCode)
  switch key
    when "d", "Backspace"
      ev.preventDefault()
      activateButton("backspace")
      backspaceHandler()
    when "c"
      activateButton("ac")
      acHandler()
    when "=", "Enter"
      activateButton("equals")
      eqHandler("=")
    when "-"
      activateButton("minus")
      operationHandler("−")
    when "+"
      activateButton("plus")
      operationHandler("+")
    when "/"
      activateButton("div")
      operationHandler("÷")
    when "*"
      activateButton("times")
      operationHandler("×")
    when "("
      activateButton("lb")
      lbHandler()
    when ")"
      activateButton("rb")
      rbHandler()
    when "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
      activateButton("btn-#{key}")
      numberHandler(key)
    when "."
      activateButton("dec")
      numberHandler(".")

  exprEl.textContent = exprString

