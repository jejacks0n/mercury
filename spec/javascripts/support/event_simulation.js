jasmine.simulate = {

  /**
   * Simulates a key event using the given event information to populate
   * the generated event object. This method does browser-equalizing
   * calculations to account for differences in the DOM and IE event models
   * as well as different browser quirks. Note: keydown causes Safari 2.x to
   * crash.
   *
   * @param {HTMLElement} target The target of the given event.
   * @param {String} type The type of event to fire. This can be any one of
   *      the following: keyup, keydown, and keypress.
   * @param {Boolean} bubbles (Optional) Indicates if the event can be
   *      bubbled up. DOM Level 3 specifies that all key events bubble by
   *      default. The default is true.
   * @param {Boolean} cancelable (Optional) Indicates if the event can be
   *      canceled using preventDefault(). DOM Level 3 specifies that all
   *      key events can be cancelled. The default
   *      is true.
   * @param {Window} view (Optional) The view containing the target. This is
   *      typically the window object. The default is window.
   * @param {Boolean} ctrlKey (Optional) Indicates if one of the CTRL keys
   *      is pressed while the event is firing. The default is false.
   * @param {Boolean} altKey (Optional) Indicates if one of the ALT keys
   *      is pressed while the event is firing. The default is false.
   * @param {Boolean} shiftKey (Optional) Indicates if one of the SHIFT keys
   *      is pressed while the event is firing. The default is false.
   * @param {Boolean} metaKey (Optional) Indicates if one of the META keys
   *      is pressed while the event is firing. The default is false.
   * @param {int} keyCode (Optional) The code for the key that is in use.
   *      The default is 0.
   * @param {int} charCode (Optional) The Unicode code for the character
   *      associated with the key being used. The default is 0.
   * @static
   */
  keyEvent: function (target, type, bubbles, cancelable, view, ctrlKey, altKey, shiftKey, metaKey, keyCode, charCode) {
    if (!target) throw('simulateKeyEvent(): Invalid target.');
    if (typeof(type) != 'string') throw('simulateKeyEvent(): Event type must be a string.');

    type = type.toLowerCase();
    switch(type) {
      case 'keyup':
      case 'keydown':
      case 'keypress':
        break;
      case 'textevent': // DOM Level 3
        type = 'keypress';
        break;
      default: throw("simulateKeyEvent(): Event type '" + type + "' not supported.");
    }

    // setup default values
    if (typeof(bubbles) == 'undefined') bubbles = true; // all key events bubble
    if (typeof(cancelable) == 'undefined') cancelable = true; // all key events can be cancelled
    if (typeof(view) == 'undefined') view = window;
    if (typeof(ctrlKey) == 'undefined') ctrlKey = false;
    if (typeof(altKey) == 'undefined') altKey = false;
    if (typeof(shiftKey) == 'undefined') shiftKey = false;
    if (typeof(metaKey) == 'undefined') metaKey = false;
    if (typeof(keyCode) == 'undefined') keyCode = 0;
    if (typeof(charCode) == 'undefined') charCode = 0;

    // try to create a mouse event
    var customEvent = null;

    // check for DOM-compliant browsers first
    if (typeof(document.createEvent) == 'function') {
      try {
        customEvent = document.createEvent('KeyEvents');
        // Interesting problem: Firefox implemented a non-standard version
        // of initKeyEvent() based on DOM Level 2 specs. Key event was
        // removed from DOM Level 2 and re-introduced in DOM Level 3 with a
        // different interface. Firefox is the only browser with any
        // implementation of Key Events, so for now, assume it's Firefox if
        // the above line doesn't error.
        // TODO: Decipher between Firefox's implementation and a correct one.
        customEvent.initKeyEvent(type, bubbles, cancelable, view, ctrlKey, altKey, shiftKey, metaKey, keyCode, charCode);
      } catch (ex) {
        // If we got here, that means key events aren't officially supported.
        // Safari/WebKit is a real problem now. WebKit 522 won't let you set
        // keyCode, charCode, or other properties if you use a UIEvent, so we
        // first must try to create a generic event. The fun part is that
        // this will throw an error on Safari 2.x. The end result is that we
        // need another try...catch statement just to deal with this mess.
        try {
          // try to create generic event - will fail in Safari 2.x
          customEvent = document.createEvent('Events');
        } catch (uierror) {
          // the above failed, so create a UIEvent for Safari 2.x
          customEvent = document.createEvent('UIEvents');
        } finally {
          customEvent.initEvent(type, bubbles, cancelable);
          customEvent.view = view;
          customEvent.altKey = altKey;
          customEvent.ctrlKey = ctrlKey;
          customEvent.shiftKey = shiftKey;
          customEvent.metaKey = metaKey;
          customEvent.keyCode = keyCode;
          customEvent.charCode = charCode;
        }
      }
      // fire the event
      target.dispatchEvent(customEvent);
    } else if (typeof(document.createEventObject) == 'object') {
      //create an IE event object
      customEvent = document.createEventObject();
      customEvent.bubbles = bubbles;
      customEvent.cancelable = cancelable;
      customEvent.view = view;
      customEvent.ctrlKey = ctrlKey;
      customEvent.altKey = altKey;
      customEvent.shiftKey = shiftKey;
      customEvent.metaKey = metaKey;

      // IE doesn't support charCode explicitly. CharCode should take
      // precedence over any keyCode value for accurate representation.
      customEvent.keyCode = (charCode > 0) ? charCode : keyCode;

      // fire the event
      target.fireEvent('on' + type, customEvent);
    } else {
      throw('simulateKeyEvent(): No event simulation framework present.');
    }
  },

  /**
   * Simulates a mouse event using the given event information to populate
   * the generated event object. This method does browser-equalizing
   * calculations to account for differences in the DOM and IE event models
   * as well as different browser quirks.
   *
   * @param {HTMLElement} target The target of the given event.
   * @param {String} type The type of event to fire. This can be any one of
   *      the following: click, dblclick, mousedown, mouseup, mouseout,
   *      mouseover, and mousemove.
   * @param {Boolean} bubbles (Optional) Indicates if the event can be
   *      bubbled up. DOM Level 2 specifies that all mouse events bubble by
   *      default. The default is true.
   * @param {Boolean} cancelable (Optional) Indicates if the event can be
   *      canceled using preventDefault(). DOM Level 2 specifies that all
   *      mouse events except mousemove can be cancelled. The default
   *      is true for all events except mousemove, for which the default
   *      is false.
   * @param {Window} view (Optional) The view containing the target. This is
   *      typically the window object. The default is window.
   * @param {int} detail (Optional) The number of times the mouse button has
   *      been used. The default value is 1.
   * @param {int} screenX (Optional) The x-coordinate on the screen at which
   *      point the event occured. The default is 0.
   * @param {int} screenY (Optional) The y-coordinate on the screen at which
   *      point the event occured. The default is 0.
   * @param {int} clientX (Optional) The x-coordinate on the client at which
   *      point the event occured. The default is 0.
   * @param {int} clientY (Optional) The y-coordinate on the client at which
   *      point the event occured. The default is 0.
   * @param {Boolean} ctrlKey (Optional) Indicates if one of the CTRL keys
   *      is pressed while the event is firing. The default is false.
   * @param {Boolean} altKey (Optional) Indicates if one of the ALT keys
   *      is pressed while the event is firing. The default is false.
   * @param {Boolean} shiftKey (Optional) Indicates if one of the SHIFT keys
   *      is pressed while the event is firing. The default is false.
   * @param {Boolean} metaKey (Optional) Indicates if one of the META keys
   *      is pressed while the event is firing. The default is false.
   * @param {int} button (Optional) The button being pressed while the event
   *      is executing. The value should be 0 for the primary mouse button
   *      (typically the left button), 1 for the terciary mouse button
   *      (typically the middle button), and 2 for the secondary mouse button
   *      (typically the right button). The default is 0.
   * @param {HTMLElement} relatedTarget (Optional) For mouseout events,
   *      this is the element that the mouse has moved to. For mouseover
   *      events, this is the element that the mouse has moved from. This
   *      argument is ignored for all other events. The default is null.
   * @static
   */
  mouseEvent: function(target, type, bubbles, cancelable, view, detail, screenX, screenY, clientX, clientY, ctrlKey, altKey, shiftKey, metaKey, button, relatedTarget) {
    if (!target) throw('simulateMouseEvent(): Invalid target.');
    if (typeof(type) != 'string') throw('simulateMouseEvent(): Event type must be a string.');

    type = type.toLowerCase();
    switch(type){
      case 'mouseover':
      case 'mouseout':
      case 'mousedown':
      case 'mouseup':
      case 'click':
      case 'dblclick':
      case 'mousemove':
        break;
      default: throw("simulateMouseEvent(): Event type '" + type + "' not supported.");
    }

    //setup default values
    if (typeof(bubbles) == 'undefined') bubbles = true; // all mouse events bubble
    if (typeof(cancelable) == 'undefined') cancelable = (type != "mousemove"); // mousemove is the only one that can't be cancelled
    if (typeof(view) == 'undefined') view = window; // view is typically window
    if (typeof(detail) == 'undefined') detail = 1; // number of mouse clicks must be at least one
    if (typeof(screenX) == 'undefined') screenX = 0;
    if (typeof(screenY) == 'undefined') screenY = 0;
    if (typeof(clientX) == 'undefined') clientX = 0;
    if (typeof(clientY) == 'undefined') clientY = 0;
    if (typeof(ctrlKey) == 'undefined') ctrlKey = false;
    if (typeof(altKey) == 'undefined') altKey = false;
    if (typeof(shiftKey) == 'undefined') shiftKey = false;
    if (typeof(metaKey) == 'undefined') metaKey = false;
    if (typeof(button) == 'undefined') button = 0;

    // try to create a mouse event
    var customEvent = null;

    // check for DOM-compliant browsers first
    if (typeof(document.createEvent) == 'function') {
      customEvent = document.createEvent("MouseEvents");

      // Safari 2.x (WebKit 418) still doesn't implement initMouseEvent()
      if (customEvent.initMouseEvent) {
        customEvent.initMouseEvent(type, bubbles, cancelable, view, detail, screenX, screenY, clientX, clientY, ctrlKey, altKey, shiftKey, metaKey, button, relatedTarget);
      } else {
        // the closest thing available in Safari 2.x is UIEvents
        customEvent = document.createEvent("UIEvents");
        customEvent.initEvent(type, bubbles, cancelable);
        customEvent.view = view;
        customEvent.detail = detail;
        customEvent.screenX = screenX;
        customEvent.screenY = screenY;
        customEvent.clientX = clientX;
        customEvent.clientY = clientY;
        customEvent.ctrlKey = ctrlKey;
        customEvent.altKey = altKey;
        customEvent.metaKey = metaKey;
        customEvent.shiftKey = shiftKey;
        customEvent.button = button;
        customEvent.relatedTarget = relatedTarget;
      }

      // Check to see if relatedTarget has been assigned. Firefox versions
      // less than 2.0 don't allow it to be assigned via initMouseEvent()
      // and the property is readonly after event creation, so in order to
      // keep YAHOO.util.getRelatedTarget() working, assign to the IE
      // proprietary toElement property for mouseout event and fromElement
      // property for mouseover event.
      if (relatedTarget && !customEvent.relatedTarget) {
        if (type == "mouseout") {
          customEvent.toElement = relatedTarget;
        } else if (type == "mouseover") {
          customEvent.fromElement = relatedTarget;
        }
      }

      //fire the event
      target.dispatchEvent(customEvent);
    } else if (typeof(document.createEventObject) == 'object') {
      //create an IE event object
      customEvent = document.createEventObject();
      customEvent.bubbles = bubbles;
      customEvent.cancelable = cancelable;
      customEvent.view = view;
      customEvent.detail = detail;
      customEvent.screenX = screenX;
      customEvent.screenY = screenY;
      customEvent.clientX = clientX;
      customEvent.clientY = clientY;
      customEvent.ctrlKey = ctrlKey;
      customEvent.altKey = altKey;
      customEvent.metaKey = metaKey;
      customEvent.shiftKey = shiftKey;
      //fix button property for IE's wacky implementation
      switch(button) {
        case 0: customEvent.button = 1; break;
        case 1: customEvent.button = 4; break;
        case 2: break; // leave as is
        default: customEvent.button = 0;
      }
      // Have to use relatedTarget because IE won't allow assignment to
      // toElement or fromElement on generic events.  This keeps
      // YAHOO.util.customEvent.getRelatedTarget() functional.
      customEvent.relatedTarget = relatedTarget;

      //fire the event
      target.fireEvent("on" + type, customEvent);
    } else {
      throw('simulateMouseEvent(): No event simulation framework present.');
    }
  },

  //--------------------------------------------------------------------------
  // Mouse events
  //--------------------------------------------------------------------------

  /**
   * Simulates a mouse event on a particular element.
   *
   * @param {HTMLElement} target The element to click on.
   * @param {String} type The type of event to fire. This can be any one of
   *      the following: click, dblclick, mousedown, mouseup, mouseout,
   *      mouseover, and mousemove.
   * @param {Object} options Additional event options (use DOM standard names).
   * @static
   */
  fireMouseEvent: function(type, target, options) {
    options = options || {};
    this.mouseEvent(target, type, options.bubbles,
      options.cancelable, options.view, options.detail, options.screenX,
      options.screenY, options.clientX, options.clientY, options.ctrlKey,
      options.altKey, options.shiftKey, options.metaKey, options.button,
      options.relatedTarget);
  },

  /**
   * Simulates a click on a particular element.
   *
   * @param {HTMLElement} target The element to click on.
   * @param {Object} options Additional event options (use DOM standard names).
   * @static
   */
  click: function(target, options) {
    try {
      this.fireMouseEvent('click', target, options);
    } catch(e) {
      alert(e);
    }
  },

  /**
   * Simulates a double click on a particular element.
   *
   * @param {HTMLElement} target The element to double click on.
   * @param {Object} options Additional event options (use DOM standard names).
   * @static
   */
  dblclick: function(target, options) {
    this.fireMouseEvent('dblclick', target, options);
  },

  /**
   * Simulates a mousedown on a particular element.
   *
   * @param {HTMLElement} target The element to act on.
   * @param {Object} options Additional event options (use DOM standard names).
   * @static
   */
  mousedown: function(target, options) {
    this.fireMouseEvent('mousedown', target, options);
  },

  /**
   * Simulates a mousemove on a particular element.
   *
   * @param {HTMLElement} target The element to act on.
   * @param {Object} options Additional event options (use DOM standard names).
   * @static
   */
  mousemove: function(target, options) {
    this.fireMouseEvent('mousemove', target, options);
  },

  /**
   * Simulates a mouseout event on a particular element. Use 'relatedTarget'
   * on the options object to specify where the mouse moved to.
   *
   * Quirks: Firefox less than 2.0 doesn't set relatedTarget properly, so
   * toElement is assigned in its place. IE doesn't allow toElement to be
   * be assigned, so relatedTarget is assigned in its place. Both of these
   * concessions allow YAHOO.util.Event.getRelatedTarget() to work correctly
   * in both browsers.
   *
   * @param {HTMLElement} target The element to act on.
   * @param {Object} options Additional event options (use DOM standard names).
   * @static
   */
  mouseout: function(target, options) {
    this.fireMouseEvent('mouseout', target, options);
  },

  /**
   * Simulates a mouseover event on a particular element. Use 'relatedTarget'
   * on the options object to specify where the mouse moved from.
   *
   * Quirks: Firefox less than 2.0 doesn't set relatedTarget properly, so
   * fromElement is assigned in its place. IE doesn't allow fromElement to be
   * be assigned, so relatedTarget is assigned in its place. Both of these
   * concessions allow YAHOO.util.Event.getRelatedTarget() to work correctly
   * in both browsers.
   *
   * @param {HTMLElement} target The element to act on.
   * @param {Object} options Additional event options (use DOM standard names).
   * @static
   */
  mouseover: function(target, options) {
    this.fireMouseEvent('mouseover', target, options);
  },

  /**
   * Simulates a mouseup on a particular element.
   *
   * @param {HTMLElement} target The element to act on.
   * @param {Object} options Additional event options (use DOM standard names).
   * @static
   */
  mouseup: function(target, options) {
    this.fireMouseEvent('mouseup', target, options);
  },

  //--------------------------------------------------------------------------
  // Key events
  //--------------------------------------------------------------------------

  /**
   * Fires an event that normally would be fired by the keyboard (keyup,
   * keydown, keypress). Make sure to specify either keyCode or charCode as
   * an option.
   *
   * @param {String} type The type of event ("keyup", "keydown" or "keypress").
   * @param {HTMLElement} target The target of the event.
   * @param {Object} options Options for the event. Either keyCode or charCode are required.
   * @static
   */
  fireKeyEvent: function(type, target, options) {
    options = options || {};
    this.keyEvent(target, type, options.bubbles,
      options.cancelable, options.view, options.ctrlKey,
      options.altKey, options.shiftKey, options.metaKey,
      options.keyCode, options.charCode);
  },

  /**
   * Simulates a keydown event on a particular element.
   *
   * @param {HTMLElement} target The element to act on.
   * @param {Object} options Additional event options (use DOM standard names).
   * @static
   */
  keydown: function(target, options) {
    this.fireKeyEvent('keydown', target, options);
  },

  /**
   * Simulates a keypress on a particular element.
   *
   * @param {HTMLElement} target The element to act on.
   * @param {Object} options Additional event options (use DOM standard names).
   * @static
   */
  keypress: function(target, options) {
    this.fireKeyEvent('keypress', target, options);
  },

  /**
   * Simulates a keyup event on a particular element.
   *
   * @param {HTMLElement} target The element to act on.
   * @param {Object} options Additional event options (use DOM standard names).
   * @static
   */
  keyup: function(target, options) {
    this.fireKeyEvent('keyup', target, options);
  },

  //--------------------------------------------------------------------------
  // Other events
  //--------------------------------------------------------------------------

  /**
   * Emulates a selection.. This doesn't simulate moving the mouse to make a
   * selection, or using the arrow keys with shift, but it does create a
   * selection that contains whatever target element you pass to it.
   *
   * @param {HTMLElement} target The element to select.
   * @static
   */
  selection: function(target, contentWindow) {
    contentWindow = contentWindow || window;
    var selection = contentWindow.getSelection();
    var range = contentWindow.document.createRange();
    range.selectNode(target);
    selection.removeAllRanges();
    selection.addRange(range);
    return selection;
  },

  /**
   * Emulates pressing the tab button.
   *
   * @param {HTMLElement} target The element to press tab in.
   * @static
   */
  tab: function(target) {
    this.keydown(target, {keyCode: 9});
  },

  /**
   * Executes a focus event
   * -- not simulated, but it seems like the right place to put it.
   *
   * @param {HTMLElement} target The element to act on.
   * @static
   */
  focus: function(target) {
    target.focus();
  },

  /**
   * Executes a focus event
   * -- not simulated, but it seems like the right place to put it.
   *
   * @param {HTMLElement} target The element to act on.
   * @static
   */
  blur: function(target) {
    target.blur();
  }
};
