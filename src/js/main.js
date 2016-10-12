var acHandler, activateButton, backspaceHandler, buttonHandler, clearActive, clearErrorBox, currEl, el, eqHandler, evalString, exprEl, exprString, i, keyHandler, lbHandler, len, numberHandler, operationHandler, putErrorBox, rbHandler, re, ref, unpaired;

exprEl = document.getElementsByClassName('expr')[0];

currEl = document.getElementsByClassName('current')[0];

exprString = "";

evalString = "";

re = /([0-9.]*)\D*$/;

ref = document.getElementsByClassName('button');
for (i = 0, len = ref.length; i < len; i++) {
  el = ref[i];
  el.addEventListener("click", function(ev) {
    return buttonHandler(ev.target.textContent);
  });
}

window.addEventListener("keypress", function(ev) {
  return keyHandler(ev);
});

window.addEventListener("keyup", function(ev) {
  return clearActive();
});

buttonHandler = function(text) {
  switch (text) {
    case "⌫":
      backspaceHandler();
      break;
    case "AC":
      acHandler();
      break;
    case "=":
      eqHandler(text);
      break;
    case "−":
    case "×":
    case "+":
    case "÷":
      operationHandler(text);
      break;
    case "(":
      lbHandler();
      break;
    case ")":
      rbHandler();
      break;
    default:
      numberHandler(text);
  }
  return exprEl.textContent = exprString;
};

keyHandler = function(ev) {
  var key;
  key = ev.key != null ? ev.key : String.fromCharCode(ev.charCode);
  switch (key) {
    case "d":
    case "Backspace":
      ev.preventDefault();
      activateButton("backspace");
      backspaceHandler();
      break;
    case "c":
      activateButton("ac");
      acHandler();
      break;
    case "=":
    case "Enter":
      activateButton("equals");
      eqHandler("=");
      break;
    case "-":
      activateButton("minus");
      operationHandler("−");
      break;
    case "+":
      activateButton("plus");
      operationHandler("+");
      break;
    case "/":
      activateButton("div");
      operationHandler("÷");
      break;
    case "*":
      activateButton("times");
      operationHandler("×");
      break;
    case "(":
      activateButton("lb");
      lbHandler();
      break;
    case ")":
      activateButton("rb");
      rbHandler();
      break;
    case "1":
    case "2":
    case "3":
    case "4":
    case "5":
    case "6":
    case "7":
    case "8":
    case "9":
    case "0":
      activateButton("btn-" + key);
      numberHandler(key);
      break;
    case ".":
      activateButton("dec");
      numberHandler(".");
  }
  return exprEl.textContent = exprString;
};

numberHandler = function(ch) {
  if (exprString.slice(-1) === ")") {
    putErrorBox("Don't input a number directly after a closing bracket.");
    return;
  }
  clearErrorBox();
  exprString += ch;
  evalString += ch;
  return currEl.textContent = exprString.match(re)[1];
};

operationHandler = function(ch) {
  var ref1;
  if (ch === "−" && exprString.slice(-1) === "−") {
    putErrorBox("Don't use two consecutive minus signs");
    return;
  }
  if (exprString.slice(-1) === "" && (ch === "×" || ch === "+" || ch === "÷")) {
    putErrorBox("Don't begin expression with an operator other than a minus sign.");
    return;
  }
  if ((ch === "×" || ch === "+" || ch === "÷") && ((ref1 = exprString.slice(-1)) === "−" || ref1 === "×" || ref1 === "+" || ref1 === "÷" || ref1 === "(" || ref1 === ".")) {
    putErrorBox("Operators should be used between two legal expressions.");
    return;
  }
  clearErrorBox();
  exprString += ch;
  switch (ch) {
    case "+":
      return evalString += "+";
    case "×":
      return evalString += "*";
    case "÷":
      return evalString += "/";
    case "−":
      return evalString += "-";
  }
};

lbHandler = function() {
  var ref1;
  if (((ref1 = evalString.slice(-1)) === "+" || ref1 === "-" || ref1 === "*" || ref1 === "/" || ref1 === "(") || evalString.slice(-1) === "") {
    clearErrorBox();
    exprString += "(";
    return evalString += "(";
  } else {
    return putErrorBox("Don't place an opening bracket after a number or closing bracket.");
  }
};

rbHandler = function() {
  var ref1;
  if ((ref1 = evalString.slice(-1)) === "+" || ref1 === "-" || ref1 === "*" || ref1 === "/" || ref1 === "(") {
    putErrorBox("Parentheses should encompass a legal expression. Don't end on an operator.");
    return;
  }
  if (unpaired(evalString) === 0) {
    putErrorBox("No matching opening parentheses found.");
    return;
  }
  clearErrorBox();
  exprString += ")";
  return evalString += ")";
};

acHandler = function() {
  clearErrorBox();
  exprString = "";
  evalString = "";
  return currEl.textContent = "";
};

eqHandler = function(ch) {
  var ref1, result;
  if (unpaired(evalString) !== 0) {
    putErrorBox("Unpaired parenthesis left in expression.");
    return;
  }
  if ((ref1 = evalString.slice(-1)) === "+" || ref1 === "-" || ref1 === "*" || ref1 === "/" || ref1 === "(") {
    putErrorBox("Only legal expressions can be evaluated. Don't end on an operator or opening parenthesis.");
    return;
  }
  clearErrorBox();
  result = eval(evalString);
  currEl.textContent = result;
  exprString = "";
  return evalString = "";
};

backspaceHandler = function() {
  clearErrorBox();
  exprString = exprString.slice(0, -1);
  evalString = evalString.slice(0, -1);
  return currEl.textContent = exprString.match(re)[1];
};

unpaired = function(str) {
  var lbMatches, numberOfLb, numberOfRb, rbMatches;
  lbMatches = str.match(/\(/g);
  rbMatches = str.match(/\)/g);
  numberOfLb = lbMatches != null ? lbMatches.length : 0;
  numberOfRb = rbMatches != null ? rbMatches.length : 0;
  return numberOfLb - numberOfRb;
};

putErrorBox = function(msg) {
  var content, err, vis, wrapper;
  clearErrorBox();
  wrapper = document.getElementsByClassName("wrapper")[0];
  err = document.createElement("div");
  content = document.createTextNode(msg);
  err.appendChild(content);
  err.classList.add("error");
  wrapper.appendChild(err);
  vis = function() {
    return err.classList.add("visible");
  };
  return setTimeout(vis, 100);
};

clearErrorBox = function() {
  var del, oldBox, wrapper;
  wrapper = document.getElementsByClassName("wrapper")[0];
  oldBox = wrapper.getElementsByClassName("error")[0];
  if (oldBox != null) {
    oldBox.classList.remove("visible");
    del = function() {
      return wrapper.removeChild(oldBox);
    };
    return setTimeout(del, 500);
  }
};

activateButton = function(button) {
  var ref1;
  return (ref1 = document.getElementsByClassName(button)[0]) != null ? ref1.classList.add("active") : void 0;
};

clearActive = function() {
  var j, len1, ref1, results;
  ref1 = document.getElementsByClassName("active");
  results = [];
  for (j = 0, len1 = ref1.length; j < len1; j++) {
    el = ref1[j];
    results.push(el != null ? el.classList.remove("active") : void 0);
  }
  return results;
};
