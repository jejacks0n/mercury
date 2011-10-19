## Generic web steps
#------------------------------------------------------------------------------
When /^(?:|I )click on (.+)$/ do |locator|
  selector = selector_for(locator)
  find(selector, :message => "Unable to locate the element '#{selector}' to click on").click
end

Then /^(.+) should (not )?be visible$/ do |locator, boolean|
  selector = selector_for(locator)
  if boolean == 'not '
    page.has_no_css?("#{selector}")
  else
    page.has_css?("#{selector}", :visible => true)
  end
end

# scoping step for different windows
When /^(.*) in the "([^"]*)" window$/ do |step, window|
  page.driver.within_window(window) do
    When(step)
  end
end


## Mercury general steps
#------------------------------------------------------------------------------
Given /^(?:|I )adjust the configuration to have: "([^"]*)"$/ do |javascript|
  Rails.application.config.mercury_config = javascript
end

# scoping step for the mercury content frame
When /^(.*) in the content frame$/ do |step|
  page.driver.within_frame('mercury_iframe') do
    When(step)
  end
end

# silence mercury's onbeforeunload confirmation
Given /^the editor won't prompt when leaving the page$/ do
  page.driver.execute_script('Mercury.silent = true;')
end


## Toolbar specific steps
#------------------------------------------------------------------------------
# for the select dropdowns
When /^(?:|I )select (.*?) from the dropdown$/ do |locator|
  selector = selector_for(locator)
  find(selector, :message => "Unable to locate the element '#{selector}' to click on").click
end


## Panel specific steps
#------------------------------------------------------------------------------
When /^(?:I )(?:open|close|toggle) the (.*?) panel$/ do |panel_locator|
  When(%Q{I click on the "#{panel_locator}" button})
end


## Modal specific steps
#------------------------------------------------------------------------------
When /^(?:I )close the modal(?: window)?$/ do
  When(%Q{I click on the modal close button})
end


## Region specific steps
#------------------------------------------------------------------------------
# setting content
Given /^the content of (.*?) (?:is|are|has|includes) (.*?)$/ do |region_locator, contents|
  When(%Q{I set the contents of #{region_locator} to #{contents}})
end

When /^(?:|I )(?:change|set) the contents? of (.*?) to (.*?)$/ do |region_locator, contents|
  region_id = region_selector_for(region_locator).gsub('#', '')
  content = contents[0] == '"' ? contents : "\"#{contents_for(contents)}\""
  page.driver.within_frame('mercury_iframe') do
    find("##{region_id}", :message => "Unable to locate a region matching '##{region_id}'")
    page.driver.execute_script <<-JAVASCRIPT
      var element = top.jQuery(document).find('##{region_id}');
      if (element.data('type') == 'markupable') {
        element.find('textarea').val(#{content});
      } else {
        var region = top.mercuryInstance.getRegionByName('#{region_id}');
        region.content(#{content});
      }
    JAVASCRIPT
  end
end

# setting/making selections
When /^(?:|I )(?:make|have) a selection$/ do
  When(%Q{I have a selection for "span"})
end

When /^(?:|I )(?:make|have) a selection (?:in (.*?) )?for "([^"]*)"$/ do |region_locator, selector|
  Given(%Q{I can simulate complex javascript events})
  # assume the first editable region if one wasn't provided'
  region_selector = region_selector_for(region_locator || 'the editable region')
  page.driver.within_frame('mercury_iframe') do
    find("#{region_selector}", :message => "Unable to locate a region matching '#{region_selector}'")
    find("#{region_selector} #{selector}", :message => "Unable to locate a match for '#{selector}' inside '#{region_locator}'")
    page.driver.execute_script <<-JAVASCRIPT
      var element = top.jQuery(document).find('#{region_selector}');
      if (element.data('type') == 'markupable') {
        alert('unimplemented');
        throw('unimplemented');
      } else {
        var selectedElement = element.find('#{selector}');
        var selection = new top.Mercury.Regions.Editable.Selection(window.getSelection(), document);
        selection.selectNode(selectedElement.get(0));
        selectedElement.simulate('mouseup');
      }
    JAVASCRIPT
  end
end

# other events
When /^(?:|I )double click on (.*?) in (.*?)$/ do |locator, region_locator|
  Given(%Q{I can simulate complex javascript events})
  selector = selector_for(locator)
  # assume the first editable region if one wasn't provided'
  region_selector = region_selector_for(region_locator || 'the editable region')
  page.driver.within_frame('mercury_iframe') do
    find("#{region_selector}", :message => "Unable to locate a region matching '#{region_selector}'")
    find("#{region_selector} #{selector}", :message => "Unable to locate a match for '#{selector}' inside '#{region_locator}'")
    page.driver.execute_script <<-JAVASCRIPT
      top.jQuery(document).find('#{region_selector} #{selector}').simulate('dblclick');
    JAVASCRIPT
  end
end

# getting contents
Then /^the contents? of (.*?) should be "([^"]*)"$/ do |region_locator, content|
  region_selector = region_selector_for(region_locator)
  page.driver.within_frame('mercury_iframe') do
    find("#{region_selector}", :message => "Unable to locate a region matching '#{region_selector}'")
    results = page.driver.execute_script <<-JAVASCRIPT
      var element = top.jQuery(document).find('#{region_selector}');
      if (element.data('type') == 'markupable') {
        return element.find('textarea').val();
      } else {
        return element.html();
      }
    JAVASCRIPT
    assert_equal content, results.gsub('"', "'").gsub("\n", '')
  end
end


## Saving specific steps
#------------------------------------------------------------------------------
# caching for the last save -- a request will still be made
Given /^save results will be cached$/ do
  page.driver.execute_script <<-JAVASCRIPT
    Mercury.PageEditor.prototype.oldSerialize = Mercury.PageEditor.prototype.serialize;
    Mercury.PageEditor.prototype.serialize = function() {
      results = this.oldSerialize.call(this, arguments);
      window.cachedResults = results;
      return results;
    }
  JAVASCRIPT
end

# check for the last save cached results
Then /^the save should have (.*?) for (.*?)$/ do |contents, region_locator|
  region_id = region_selector_for(region_locator).gsub('#', '')
  content = contents[0] == '"' ? contents : "\"#{contents_for(contents)}\""
  results = page.driver.execute_script <<-JAVASCRIPT
    return (window.cachedResults['#{region_id}']) ?
      window.cachedResults['#{region_id}']['value'] : null;
  JAVASCRIPT
  assert_equal content, "\"#{results}\""
end


## Table editing specific steps
#------------------------------------------------------------------------------
# in the modal window
When /^(?:|I )(?:add|insert) a (row|column) (before|after)(?: it)?$/ do |row_or_column, before_or_after|
  name = "insert_#{row_or_column}_#{before_or_after}".camelcase(:lower)
  When(%Q{I click on ".mercury-modal-content input[name=#{name}]"})
end

When /^(?:|I )delete the(?: current)? (row|column)$/ do |row_or_column|
  name = "delete_#{row_or_column}".camelcase(:lower)
  When(%Q{I click on ".mercury-modal-content input[name=#{name}]"})
end

When /^(?:|I )(increase|decrease) the (rowspan|colspan)$/ do |increase_or_decrease, rowspan_or_colspan|
  name = "#{increase_or_decrease}_#{rowspan_or_colspan}".camelcase(:lower)
  When(%Q{I click on ".mercury-modal-content input[name=#{name}]"})
end

Then /^the selected cell should be (.*?)$/ do |locator|
  selector = selector_for(locator).gsub('td:', 'td.selected:')
  find("#{selector}", :message => "Unable to locate the selected cell for '#{selector}'")
end

# in general
Then /^the(?: table)? (row|column) count should be (\d+)$/ do |row_or_column, expected_count|
  method = "get_#{row_or_column}_count".camelcase(:lower)
  actual_count = page.driver.execute_script("return Mercury.tableEditor.#{method}()")
  assert_equal expected_count.to_i, actual_count.to_i
end


## Snippet specific steps
#------------------------------------------------------------------------------
# setting snippet options
Given /^the options for the (.*?) snippet "([^"]*)" are (.*?)$/ do |snippet_name, snippet_id, options|
  @snippet_id = snippet_id
  options_json = parse_snippet_options_from(options)
  page.driver.execute_script <<-JAVASCRIPT
    Mercury.Snippet.load({#{snippet_id}: {name: '#{snippet_name}', options: #{options_json}}});
  JAVASCRIPT
end

# dragging/dropping
When /^(?:|I )(?:drag|drop) (.*?) (?:into|on) (.*?)$/ do |snippet_locator, region_locator|
  snippet_name = snippet_name_for(snippet_locator)
  region_id = region_selector_for(region_locator).gsub('#', '')
  page.driver.within_frame('mercury_iframe') do
    find("##{region_id}", :message => "Unable to locate a region matching '##{region_id}'")
    page.driver.execute_script <<-JAVASCRIPT
      var element = top.jQuery(document).find('##{region_id}');
      if (element.data('type') == 'markupable') {
        alert('unimplemented');
        throw('unimplemented');
      } else {
        var region = top.mercuryInstance.getRegionByName('#{region_id}');
        region.selection().range.collapse(true);
        document.execCommand('insertHTML', false, '<img data-snippet="#{snippet_name}" src="/assets/mercury/default-snippet.png">');
        element.trigger('possible:drop');
      }
    JAVASCRIPT
  end
end

When /^(?:|I )hover over (.*?)(?: in (.*?))?$/ do |locator, region_locator|
  Given(%Q{I can simulate complex javascript events})
  selector = selector_for(locator)
  region_selector = region_selector_for(region_locator || 'the editable region')
  page.driver.within_frame('mercury_iframe') do
    find("#{region_selector}", :message => "Unable to locate a region matching '#{region_selector}'")
    page.driver.execute_script <<-JAVASCRIPT
      var element = top.jQuery(document).find('#{region_selector}');
      if (element.data('type') == 'markupable') {
        alert('unimplemented');
        throw('unimplemented');
      } else {
        element.find('#{selector}').simulate('mousemove');
      }
    JAVASCRIPT
  end
end

When /^(?:|I )edit the snippet$/ do
  When(%{I hover over the snippet})
  And(%{click on the edit snippet settings toolbar button})
end


## Dropping image specific steps
#------------------------------------------------------------------------------
#When /^(?:|I )drop an image into (.*?) from a different browser/ do |region_locator|
#  Given(%Q{I can simulate complex javascript events})
#  region_selector = region_selector_for(region_locator || 'the editable region')
#  page.driver.within_frame('mercury_iframe') do
#    find("#{region_selector}", :message => "Unable to locate a region matching '#{region_selector}'")
#    page.driver.execute_script <<-JAVASCRIPT
#      var element = top.jQuery(document).find('#{region_selector}');
#      if (element.data('type') == 'markupable') {
#        alert('unimplemented');
#        throw('unimplemented');
#      } else {
#        element.find('#{region_selector}').simulate('drop', {'text/html': '<img src="testing.gif"/>'});
#      }
#    JAVASCRIPT
#  end
#end


## Javascript event simulation steps
#------------------------------------------------------------------------------
Given /^(?:|I )can simulate complex javascript events$/ do
  page.driver.execute_script(EVENT_SIMULATION_JAVASCRIPT)
end

#------------------------------------------------------------------------------

EVENT_SIMULATION_JAVASCRIPT = <<-JAVASCRIPT
  /*
   * jquery.simulate - simulate browser mouse and keyboard events
   *
   * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
   * Dual licensed under the MIT or GPL Version 2 licenses.
   * http://jquery.org/license
   *
   */
  ;(function($) {

  $.fn.extend({
    simulate: function(type, options) {
      return this.each(function() {
        var opt = $.extend({}, $.simulate.defaults, options || {});
        new $.simulate(this, type, opt);
      });
    }
  });

  $.simulate = function(el, type, options) {
    this.target = el;
    this.options = options;

    if (/^drag$/.test(type)) {
      this[type].apply(this, [this.target, options]);
    } else {
      this.simulateEvent(el, type, options);
    }
  }

  $.extend($.simulate.prototype, {
    simulateEvent: function(el, type, options) {
      var evt = this.createEvent(type, options);
      this.dispatchEvent(el, type, evt, options);
      return evt;
    },
    createEvent: function(type, options) {
      if (/^mouse(over|out|down|up|move)|(dbl)?click$/.test(type)) {
        return this.mouseEvent(type, options);
      } else if (/^key(up|down|press)$/.test(type)) {
        return this.keyboardEvent(type, options);
      }
    },
    mouseEvent: function(type, options) {
      var evt;
      var e = $.extend({
        bubbles: true, cancelable: (type != "mousemove"), view: window, detail: 0,
        screenX: 0, screenY: 0, clientX: 0, clientY: 0,
        ctrlKey: false, altKey: false, shiftKey: false, metaKey: false,
        button: 0, relatedTarget: undefined
      }, options);

      var relatedTarget = $(e.relatedTarget)[0];

      if ($.isFunction(document.createEvent)) {
        evt = document.createEvent("MouseEvents");
        evt.initMouseEvent(type, e.bubbles, e.cancelable, e.view, e.detail,
          e.screenX, e.screenY, e.clientX, e.clientY,
          e.ctrlKey, e.altKey, e.shiftKey, e.metaKey,
          e.button, e.relatedTarget || document.body.parentNode);
      } else if (document.createEventObject) {
        evt = document.createEventObject();
        $.extend(evt, e);
        evt.button = { 0:1, 1:4, 2:2 }[evt.button] || evt.button;
      }
      return evt;
    },
    keyboardEvent: function(type, options) {
      var evt;

      var e = $.extend({ bubbles: true, cancelable: true, view: window,
        ctrlKey: false, altKey: false, shiftKey: false, metaKey: false,
        keyCode: 0, charCode: 0
      }, options);

      if ($.isFunction(document.createEvent)) {
        try {
          evt = document.createEvent("KeyEvents");
          evt.initKeyEvent(type, e.bubbles, e.cancelable, e.view,
            e.ctrlKey, e.altKey, e.shiftKey, e.metaKey,
            e.keyCode, e.charCode);
        } catch(err) {
          evt = document.createEvent("Events");
          evt.initEvent(type, e.bubbles, e.cancelable);
          $.extend(evt, { view: e.view,
            ctrlKey: e.ctrlKey, altKey: e.altKey, shiftKey: e.shiftKey, metaKey: e.metaKey,
            keyCode: e.keyCode, charCode: e.charCode
          });
        }
      } else if (document.createEventObject) {
        evt = document.createEventObject();
        $.extend(evt, e);
      }
      if ($.browser.msie || $.browser.opera) {
        evt.keyCode = (e.charCode > 0) ? e.charCode : e.keyCode;
        evt.charCode = undefined;
      }
      return evt;
    },
    dispatchEvent: function(el, type, evt) {
      if (el.dispatchEvent) {
        el.dispatchEvent(evt);
      } else if (el.fireEvent) {
        el.fireEvent('on' + type, evt);
      }
      return evt;
    },
    drag: function(el) {
      var self = this, center = this.findCenter(this.target),
        options = this.options,	x = Math.floor(center.x), y = Math.floor(center.y),
        dx = options.dx || 0, dy = options.dy || 0, target = this.target;
      var coord = { clientX: x, clientY: y };
      this.simulateEvent(target, "mousedown", coord);
      coord = { clientX: x + 1, clientY: y + 1 };
      this.simulateEvent(document, "mousemove", coord);
      coord = { clientX: x + dx, clientY: y + dy };
      this.simulateEvent(document, "mousemove", coord);
      this.simulateEvent(document, "mousemove", coord);
      this.simulateEvent(target, "mouseup", coord);
      this.simulateEvent(target, "click", coord);
    },
    findCenter: function(el) {
      var el = $(this.target), o = el.offset(), d = $(document);
      return {
        x: o.left + el.outerWidth() / 2 - d.scrollLeft(),
        y: o.top + el.outerHeight() / 2 - d.scrollTop()
      };
    }
  });

  $.extend($.simulate, {
    defaults: {
      speed: 'sync'
    },
    VK_TAB: 9,
    VK_ENTER: 13,
    VK_ESC: 27,
    VK_PGUP: 33,
    VK_PGDN: 34,
    VK_END: 35,
    VK_HOME: 36,
    VK_LEFT: 37,
    VK_UP: 38,
    VK_RIGHT: 39,
    VK_DOWN: 40
  });

  })(jQuery);
JAVASCRIPT
