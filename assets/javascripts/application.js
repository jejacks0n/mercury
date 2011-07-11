if (top.Mercury) {
  window.Mercury = top.Mercury;
  Mercury.PageEditor.prototype.save = function() {
    var data = this.serialize();
    var lightview = Mercury.lightview(null, {title: 'Saving'});
    setTimeout(function() {
      lightview.loadContent('<div style="width:500px">Saving in the demo is disabled, but you can see what would be saved below.<textarea style="width:100%;height:300px">' + top.jQuery.toJSON(data) + '</textarea></div>');
    }, 500);
  }
}