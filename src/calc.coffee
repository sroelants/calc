exprEl = document.getElementsByClassName('expr')[0]
currEl = document.getElementsByClassName('current')[0]
exprString = ""
evalString = ""
re = /([0-9.]*)\D*$/ # pick out last integer, ignoring possible crap after

for el in document.getElementsByClassName 'button'
  el.addEventListener "click", (ev) -> buttonHandler(ev.target.textContent)

window.addEventListener "keypress", (ev) -> keyHandler(ev)
window.addEventListener "keyup", (ev) -> clearActive()
