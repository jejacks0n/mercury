if (top.Mercury) {
  window.Mercury = top.Mercury;
  Mercury.PageEditor.prototype.save = function() {
    var data = this.serialize();
    var lightview = Mercury.lightview(null, {title: 'Saving', closeButton: true});
    setTimeout(function() {
      var textarea = '<textarea style="width:100%;height:300px" wrap="off">' + top.JSON.stringify(data, null, '  ') + '</textarea>';
      lightview.loadContent('<div style="width:500px">Saving in the demo is disabled, but you can see what would be sent to the server below.' + textarea + '</div>');
    }, 500);
  }
}