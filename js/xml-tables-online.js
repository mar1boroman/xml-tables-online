var xmlDocFile = "";

const htmlInfo = `
Drag and drop your XML file here or upload a file from your
local system using the <i class="bi bi-upload"></i> button.
<br />
Your XML will be auto-formatted, you can use
<i class="bi bi-clipboard2"></i> the clipboard to copy the
formatted XML.
<br />
After uploading your XML, for tabular, graph, 2-D and 3-D view,
click on the <i class="bi bi-magic"></i> Tabular button. You can
download your XML in JSON and CSV format from the new tab
(Tabular button will open your XML in a new tab)
<br />
No data is stored, all transformations are done in your browser
memory.
<br />
Source code for this online version is hosted at 
<a href="https://github.com/mar1boroman/xml-tables-online" target="_blank"><i class="bi bi-github" style="color: black"></i></a>.
<br />
Currently supported only on <b>Firefox</b> browser
<br />
Contributions welcome
`;

window.onload = function () {
  setInfo();
  document.getElementById("reset-btn").hidden = true;
};

function setInfo() {
  document.getElementById("xml-text").innerHTML = htmlInfo;
  document.getElementById("xml-text").style.textAlign = "center";
  document.getElementById("reset-btn").hidden = true;
}

function setXMLDocFile(file) {
  xmlDocFile = file;
}

function getXMLDoc() {
  return xmlDocFile;
}

// function which is executed when the XML doc read by file input or drag and drop to set the text in input text area
function dropfile(file) {
  setXMLDocFile(file);
  var reader = new FileReader();
  reader.onload = function (event) {
    document.getElementById("xml-text").classList.add("language-xml");
    document.getElementById("xml-text").style.textAlign = "left";
    document.getElementById("xml-text").textContent = event.target.result;
    document.getElementById("reset-btn").hidden = false;
    hljs.highlightElement(document.getElementById("xml-text"));
  };
  reader.readAsText(file, "UTF-8");
}

// function executed when file is dragged and dropped in the drag and drop area
function onXMLFileDrop(event) {
  event.preventDefault();
  var file = event.dataTransfer.files[0];

  dropfile(file);
}

function dragOverHandler(ev) {
  ev.preventDefault();
}

// function executed when the user uploads a file
function onUploadFile(event) {
  var file = event.target.files[0];
  // console.log(file);
  dropfile(file);
}

// function to convert the XML doc into a XML document which can be manipulated by javascript
function loadXMLSync(url) {
  var xhr = new XMLHttpRequest();

  xhr.open("GET", url, false);
  xhr.setRequestHeader("Content-Type", "text/xml");
  xhr.send();

  return xhr.responseXML;
}

// function to load javascript dynamically
function loadJSSync(url) {
  var xhr = new XMLHttpRequest();

  xhr.open("GET", url, false);
  xhr.setRequestHeader("Content-Type", "text/javascript");
  xhr.send();

  return xhr.responseText;
}

// function to load css dynamically
function loadCSSSync(url) {
  var xhr = new XMLHttpRequest();

  xhr.open("GET", url, false);
  xhr.setRequestHeader("Content-Type", "text/css");
  xhr.send();

  return xhr.responseText;
}

// function executed when the user clicks the tabular button
function getXMLBlob(file) {
  // Create a new XML document with additional styletag
  var urlreader = new FileReader();

  urlreader.readAsDataURL(file);
  urlreader.onload = function (event) {
    var fileURL = event.target.result;

    // Preparing the XSL Stylesheet document dynamically

    var xslDoc = loadXMLSync("xml-tables-core/xsl/xml-tables.xsl");

    // Injecting the Core JS and CSS dynamically
    var xslJS = loadJSSync("xml-tables-core/js/xml-tables.js");
    var xslCSS = loadCSSSync("xml-tables-core/css/xml-tables.css");
    const xslJSBlob = new Blob([xslJS], { type: "text/javascript" });
    const xslCSSBlob = new Blob([xslCSS], { type: "text/css" });
    var xslJSURL = URL.createObjectURL(xslJSBlob);
    var xslCSSURL = URL.createObjectURL(xslCSSBlob);

    var xmlTablesJSCore = document.createElement("script");
    xmlTablesJSCore.setAttribute("type", "text/javascript");
    xmlTablesJSCore.setAttribute("src", xslJSURL);
    xmlTablesJSCore.setAttribute("crossorigin", "anonymous");
    xslDoc.getElementsByTagName("head")[0].appendChild(xmlTablesJSCore);

    var xmlTablesCSSCore = document.createElement("link");
    xmlTablesCSSCore.setAttribute("rel", "stylesheet");
    xmlTablesCSSCore.setAttribute("type", "text/css");
    xmlTablesCSSCore.setAttribute("href", xslCSSURL);
    xmlTablesCSSCore.setAttribute("crossorigin", "anonymous");
    xslDoc.getElementsByTagName("head")[0].appendChild(xmlTablesCSSCore);

    const xslString = new XMLSerializer().serializeToString(xslDoc);
    const xslBlob = new Blob([xslString], { type: "text/xsl" });
    var xslURL = URL.createObjectURL(xslBlob);

    // Preparing the XML file referring to the XML document created above stylesheet dynamically

    var xmlDoc = loadXMLSync(fileURL);
    var pi = xmlDoc.createProcessingInstruction(
      "xml-stylesheet",
      'href= "' + `${xslURL}` + '"' + ' type="text/xsl"'
    );
    xmlDoc.insertBefore(pi, xmlDoc.firstChild);

    const xmlString = new XMLSerializer().serializeToString(xmlDoc);
    const xmlBlob = new Blob([xmlString], { type: "text/xml" });

    var url = URL.createObjectURL(xmlBlob);
    window.open(url);
  };
}

function onClickTabular() {
  var xmlFile = getXMLDoc();
  getXMLBlob(xmlFile);
}

function onClickClipboard() {
  var clipboardContent = document.getElementById("xml-text").textContent;
  // console.log(clipboardContent);
  navigator.clipboard.writeText(clipboardContent);
}
