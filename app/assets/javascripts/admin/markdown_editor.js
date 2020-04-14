
// Does not show error SimpleMDE not defined
// Does not show console.log

// $( document ).on('turbolinks:load', function() {
//  var simplemde = new SimpleMDE({ element: document.getElementById("markdown-editor") });
//  simplemde.value("This text will appear in the editor");
//  console.log("Markdown working")
// })

// Shows error SimpleMDE not defined
// Shows console log "Markdown working"
// literally why I hate rails w/ js
$(document).ready(function() {
 //var simplemde = new SimpleMDE({ element: $("#MyID")[0] });
 console.log("Markdown working")
 //simplemde.value("This text will appear in the editor");
});

