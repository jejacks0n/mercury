/*!
 * Mercury Editor is a Coffeescript and jQuery based WYSIWYG editor.  Mercury Editor utilizes the HTML5 ContentEditable
 * spec to allow editing sections of a given page (instead of using iframes) and provides an editing experience that's as
 * realistic as possible.  By not using iframes for editable regions it allows CSS to behave naturally.
 *
 * Mercury Editor was written for the future, and doesn't attempt to support legacy implementations of document editing.
 *
 * Currently supported browsers are
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
 *= require_self
 */
(function() {
  if (!document.getElementsByTagName) return;

  var head = document.getElementsByTagName("head")[0];
  if (window == top) {
    var style = document.createElement('style');
    style.innerText = 'body{visibility:hidden;display:none}';
    head.appendChild(style);
  }

  var timer;
  function loadMercury() {
    if (document.mercuryLoaded) return;
    if (timer) window.clearTimeout(timer);
    document.mercuryLoaded = true;

    if (window == top) {
      setTimeout(function() {
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
      window.Mercury = top.Mercury;
      Mercury.trigger('initialize:frame');
    }
  }

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
