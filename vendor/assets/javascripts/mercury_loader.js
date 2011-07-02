/*!
 * Mercury Editor is a Coffeescript and jQuery based WYSIWYG editor.  Documentation and other useful information can be
 * found at https://github.com/jejacks0n/mercury
 *
 * Supported browsers:
 *   - Firefox 4+
 *   - Chrome 10+
 *   - Safari 5+
 *
 * Copyright (c) 2011 Jeremy Jackson
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
 * persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */
(function() {

  // If the browser isn't supported, we don't try to do anything more.
  if (!document.getElementsByTagName) return;

  // Hide the document during loading so there isn't a flicker while mercury is being loaded.
  var head = document.getElementsByTagName("head")[0];
  if (window == top) {
    var style = document.createElement('style');
    style.innerText = 'body{visibility:hidden;display:none}';
    head.appendChild(style);
  }

  // Because Mercury loads the document it's going to edit into an iframe we do some tweaks to the current document to
  // make that feel more seamless.
  function loadMercury() {
    if (document.mercuryLoaded) return;
    if (timer) window.clearTimeout(timer);
    document.mercuryLoaded = true;

    if (window == top) {
      setTimeout(function() {
        // Once we're ready to load Mercury we clear the document contents, and add in the css and javascript tags.
        // Once the script has loaded we display the body again, and instantiate a new instance of Mercury.PageEditor.
        document.body.innerHTML = '&nbsp;';
        for (var i = 0; i <= document.styleSheets.length - 1; i += 1) {
          document.styleSheets[i].disabled = true
        }

        var link = document.createElement('link');
        link.href = '/assets/mercury.css';
        link.media = 'screen';
        link.rel = 'stylesheet';
        link.type = 'text/css';
        head.appendChild(link);

        var script = document.createElement('script');
        script.src = '/assets/mercury.js';
        script.type = 'text/javascript';
        head.appendChild(script);
        script.onload = function() {
          document.body.style.visibility = 'visible';
          document.body.style.display = 'block';
          new Mercury.PageEditor()
        }
      }, 1);
    } else if (top.Mercury) {
      // Since this file will be included in the iframe as well, we use it to tell Mercury that the document is ready to
      // be worked on.  By firing this event we're able to build the regions and get everything ready without having to
      // wait for assets and slow javascripts to load or complete.
      window.Mercury = top.Mercury;
      Mercury.trigger('initialize:frame');
    }
  }

  // This is a common technique for determining if the document has loaded yet, and is based on the methods used in
  // Prototype.js.  The following portions just call loadMercury once it's appropriate to do so.
  //
  // Support for the DOMContentLoaded event is based on work by Dan Webb, Matthias Miller, Dean Edwards, John Resig,
  // and Diego Perini.
  var timer;
  function checkReadyState() {
    if (document.readyState === 'complete') {
      document.stopObserving('readystatechange', checkReadyState);
      loadMercury();
    }
  }

  function pollDoScroll() {
    try { document.documentElement.doScroll('left'); }
    catch(e) {
      timer = pollDoScroll.defer();
      return;
    }
    loadMercury();
  }

  if (document.addEventListener) {
    document.addEventListener('DOMContentLoaded', loadMercury, false);
  } else {
    document.observe('readystatechange', checkReadyState);
    if (window == top) { timer = pollDoScroll.defer(); }
  }
})();
