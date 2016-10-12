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


activateButton = (button) ->
  document.getElementsByClassName(button)[0]?.classList.add("active")

clearActive = ->
  for el in document.getElementsByClassName("active")
    el?.classList.remove("active")
