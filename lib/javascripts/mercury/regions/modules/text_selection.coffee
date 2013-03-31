# todo: problems:
# toggle wrap words doesn't work well from the end/start of token
#   |_|foo_ - removing fails
#   _foo_| - probably behaves as expected, but seems odd
#   |*|*foo** - removing fails
#   **foo*|*| - removing fails
#   |<|u|>foo</u> - selection moves badly
#   <u>foo</|u|> - selection moves badly
#   |<sub>foo</sub> - removing fails
#   <|s|u|b|>foo<|/|s|u|b|>| - selection moves badly
# unwrapping lines by paragraph is moving the selection badly
#   |> foo1 - selection moves badly

Mercury.Region.Modules.TextSelection =

  getSelection: ->
    el = @focusable.get(0)
    value = el.value
    start = el.selectionStart
    end = el.selectionEnd
    start: start, end: end, length: end - start, text: value.slice(start, end)


  setSelection: (sel, preAdjust = 0, sufAdjust = null, collapse = false) ->
    start = sel.start + preAdjust
    end = sel.end + (sufAdjust ? preAdjust)
    end = start if end < start || typeof(end) == 'undefined' || collapse
    el = @focusable.get(0)
    value = el.value
    start += value.length if start < 0
    end += value.length if end < 0
    el.selectionStart = start
    el.selectionEnd = end


  getSerializedSelection: ->
    @getSelection()


  setSerializedSelection: (sel) ->
    @setSelection(sel)


  isWithinToken: (wrapper) ->
    [fix, sel] = @getTokenAndSelection(wrapper)
    exp = @expandSelectionToTokens(sel, fix)
    return true if exp.cleaned


  firstLineMatches: (matcher) ->
    sel = @getSelection()
    exp = @expandSelectionToLines(sel)
    return true if exp.text.match(matcher)


  # ---------------------------------------------------------------------------
  # Selection replacements
  # ---------------------------------------------------------------------------

  replaceSelection: (text = '') ->
    el = @focusable.get(0)
    value = el.value
    sel = @getSelection()
    el.value = [value.slice(0, sel.start), text, value.slice(sel.end)].join('')
    caretIndex = sel.start + text.length
    @setSelection(start: caretIndex, end: caretIndex)


  replaceSelectedLine: (line, text = '') ->
    @setSelection(line)
    @replaceSelection(text)


  setAndReplaceSelection: (beforeSel, text = '', afterSel, preAdjust, sufAdjust, collapse) ->
    @setSelection(beforeSel)
    @replaceSelection(text)
    @setSelection(afterSel, preAdjust, sufAdjust, collapse)


  replaceSelectionWithParagraph: (text = '') ->
    val = @value()
    sel = @getSelection()
    pre = '\n'
    pre += '\n' unless val[sel.start - 1] == '\n'
    pre = '' unless sel.start
    suf = '\n'
    suf += '\n' unless val[sel.end] == '\n' || val[sel.end + 1] == '\n'
    suf = '\n\n' unless sel.end

    @replaceSelection([pre, text, suf].join(''))


  # ---------------------------------------------------------------------------
  # Wrap/unwrap natural selections
  # ---------------------------------------------------------------------------

  wrapSelected: (wrapper, options = {}) ->
    [fix, sel] = @getTokenAndSelection(wrapper)
    val = [fix.pre, sel.text || options.text || '', fix.suf].join('')

    if options.select == 'end'
      [pre, suf] = [val.length, null]
    else
      [pre, suf] = [0, val.length - sel.length]

    @setAndReplaceSelection(sel, val, sel, pre, suf, options.select == 'end')


  unwrapSelected: (wrapper) ->
    [fix, sel] = @getTokenAndSelection(wrapper)
    set = sel.text.match(fix.regexp)
    return false unless set && set.length == 2

    @setAndReplaceSelection(sel, sel.text.replace(fix.regexp, ''), sel, 0, -set.join('').length)


  toggleWrapSelected: (wrapper, options = {}) ->
    @wrapSelected(wrapper, options) unless @unwrapSelected(wrapper)


  # ---------------------------------------------------------------------------
  # Wrap/unwrap selections by word (expanding to the selected words/token)
  # ---------------------------------------------------------------------------

  wrapSelectedWords: (wrapper) ->
    [fix, sel] = @getTokenAndSelection(wrapper)
    exp = @expandSelectionToWords(sel)

    @setAndReplaceSelection(exp, [fix.pre, exp.text, fix.suf].join(''), sel, fix.pre.length)


  unwrapSelectedWords: (wrapper) ->
    [fix, sel] = @getTokenAndSelection(wrapper)
    exp = @expandSelectionToTokens(sel, fix)
    return false unless exp.cleaned

    @setAndReplaceSelection(exp, exp.token, sel, -exp.match[0].length)


  toggleWrapSelectedWords: (wrapper) ->
    @wrapSelectedWords(wrapper) unless @unwrapSelectedWords(wrapper)


  # ---------------------------------------------------------------------------
  # Wrapping selections by lines (expanding to selected lines)
  # ---------------------------------------------------------------------------

  wrapSelectedLines: (wrapper) ->
    [fix, sel] = @getTokenAndSelection(wrapper)
    exp = @expandSelectionToLines(sel)
    pre = 0
    suf = 0
    val = []
    pos = exp.start
    all = exp.text.split('\n')
    for line in all
      if line.trim() || all.length == 1
        pre ||= fix.pre.length
        suf += fix.pre.length
        pos += line.length
        suf += fix.suf.length if pos < sel.end
        val.push([fix.pre, line, fix.suf].join(''))
      else
        empty = true
        pos += line.length
        val.push(line)
    pre = 0 if empty

    @setAndReplaceSelection(exp, val.join('\n'), sel, pre, suf)


  unwrapSelectedLines: (wrapper) ->
    [fix, sel] = @getTokenAndSelection(wrapper)
    exp = @expandSelectionToLines(sel)
    pre = 0
    suf = 0
    val = []
    pos = exp.start
    all = exp.text.split('\n')
    ret = true
    for line in all
      set = line.match(fix.regexp)
      if set && set.length == 2
        pre += set[0].length if pos <= sel.start
        suf += set[0].length if pos < sel.end
        pos += line.length
        pre += set[1].length if pos <= sel.start
        suf += set[1].length if pos < sel.end
        val.push(line.replace(fix.regexp, ''))
      else
        ret = false
        pos += line.length
        val.push(line)
    pre = 0 unless ret

    @setAndReplaceSelection(exp, val.join('\n'), sel, -pre, -suf)
    ret


  # ---------------------------------------------------------------------------
  # Wrapping selections by paragraph (expanding to selected paragraphs)
  # ---------------------------------------------------------------------------

  wrapSelectedParagraphs: (wrapper, options = {}) ->
    [fix, sel] = @getTokenAndSelection(wrapper)
    exp = @expandSelectionToParagraphs(sel)
    pre = 0
    suf = 0
    val = []
    pos = exp.start
    if options.all
      pre = suf += fix.pre.length
      val.push([fix.pre, exp.text, fix.suf].join(''))
    else
      all = exp.text.split('\n')
      for line in all
        if line.trim() || all.length == 1
          pre += fix.pre.length if pos <= sel.start
          suf += fix.pre.length if pos < sel.end
          pos += line.length
          pre += fix.suf.length if pos <= sel.start
          suf += fix.suf.length if pos < sel.end
          val.push([fix.pre, line, fix.suf].join(''))
        else
          empty = true
          pos += line.length
          val.push(line)
      pre = 0 if empty

    @setAndReplaceSelection(exp, val.join('\n'), sel, pre, suf)


  unwrapSelectedParagraphs: (wrapper, options = {}) ->
    [fix, sel] = @getTokenAndSelection(wrapper)
    exp = @expandSelectionToParagraphs(sel)
    pre = 0
    suf = 0
    val = []
    pos = exp.start
    ret = true
    if options.all
      set = exp.text.match(fix.regexp)
      if set && set.length == 2
        pre += set[0].length
        suf += set[1].length
        val.push(exp.text.replace(fix.regexp, ''))
      else
        val.push(exp.text)
    else
      for line in exp.text.split('\n')
        set = line.match(fix.regexp)
        if set && set.length == 2
          pre += set[0].length if pos <= sel.start
          suf += set[0].length if pos < sel.end
          pos += line.length
          pre += set[1].length if pos <= sel.start
          suf += set[1].length if pos < sel.end
          val.push(line.replace(fix.regexp, ''))
        else
          ret = false
          pos += line.length
          val.push(line)
      pre = 0 unless ret

    @setAndReplaceSelection(exp, val.join('\n'), sel, -pre, -suf)
    ret


  # ---------------------------------------------------------------------------
  # PROTECTED: Selection translation (expand by word/line/paragraph/etc.)
  # ---------------------------------------------------------------------------

  expandSelectionToWords: (sel) ->
    val = @value()
    return sel if @selectionIsEmptyLine(sel, val) || @selectionIsEndOfLine(sel, val)

    lineStart = @getSelectionStartOfLine(sel, val)
    lineEnd = @getSelectionEndOfLine(sel, val)

    start = val.lastIndexOf(' ', sel.start - 1)
    start = lineStart if start < lineStart
    start += 1 if start > 0 && (val[start] == ' ' || val[start] == '\n')

    end = val.indexOf(' ', sel.end)
    end = lineEnd if end >= lineEnd || end == -1

    start: start, end: end, text: val.substring(start, end), length: end - start


  expandSelectionToLines: (sel) ->
    val = @value()
    return sel if @selectionIsEmptyLine(sel, val)

    start = @getSelectionStartOfLine(sel, val)
    end = @getSelectionEndOfLine(sel, val)

    start: start, end: end, text: val.substring(start, end), length: end - start


  expandSelectionToParagraphs: (sel) ->
    val = @value()
    return sel if @selectionIsEmptyLine(sel, val)

    start = val.lastIndexOf('\n\n', sel.start - 1)
    start = 0 if start < 0
    start += 2 if start > 0
    start += 1 if start == 0 && val[0] == '\n'
    start += 1 if start == 1 && val[1] == '\n'
    start = sel.start if start > sel.start - 1

    end = val.indexOf('\n\n', sel.end - 1)
    end = sel.end if sel.length && val.substr(sel.end - 2, 2) == '\n\n'
    end = val.length if end < 0

    start: start, end: end, text: val.substring(start, end), length: end - start


  expandSelectionToTokens: (sel, fix) ->
    val = @value()
    return sel if @selectionIsEmptyLine(sel, val)
    return alt if alt = @selectionIsToken(sel, val, fix)

    lineStart = @getSelectionStartOfLine(sel, val)
    lineEnd = @getSelectionEndOfLine(sel, val)

    start = val.lastIndexOf(fix.pre, sel.start - 1)
    start = lineStart if start < lineStart
    start += 1 if start > 0 && (val[start] == ' ' || val[start] == '\n')

    end = val.indexOf(fix.suf, sel.end - 1)
    end += fix.suf.length if end > -1
    end = lineEnd if end > lineEnd || end == -1

    token = null
    value = val.substring(start, end)
    match = value.match(fix.regexp)
    token = value.replace(fix.regexp, '') if match && match.length == 2

    start: start, end: end, text: value, length: end - start, cleaned: token != null, token: token, match: match


  selectionIsToken: (sel, val, fix) ->
    return false if sel.length > 0
    start = sel.start - fix.pre.length
    end = sel.end + fix.suf.length
    token = null
    value = val.substring(start, end)
    match = value.match(fix.regexp)
    token = value.replace(fix.regexp, '') if match && match.length == 2
    return false if token == null
    start: start, end: end, text: value, length: end - start, cleaned: true, token: token, match: match


  getSelectionStartOfLine: (sel, val) ->
    start = sel.start
    start = val.lastIndexOf('\n', start) unless val[start] == '\n'
    start = val.lastIndexOf('\n', start - 1) if start == sel.start
    start = 0 if start < 0
    if start == 0 && val[0] == '\n' && sel.start == 0
      start = 0
    else if val[start] == '\n'
      start += 1
    start


  getSelectionEndOfLine: (sel, val) ->
    end = sel.end
    end = val.indexOf('\n', end) if sel.length == 0 || (val[end] != '\n' && val[end - 1] != '\n')
    end = val.length if end < 0
    end


  selectionIsEmptyLine: (sel, val) ->
    (sel.length <= 1 && val.substr(sel.start - 1, 2) == '\n\n') || (sel.start == 0 && val[0] == '\n')


  selectionIsEndOfLine: (sel, val) ->
    val[sel.start - 1] == ' ' && (val[sel.start] == '\n' || sel.start == val.length)


  # ---------------------------------------------------------------------------
  # PROTECTED: Helpers
  # ---------------------------------------------------------------------------

  processWrapper: (wrapper, args...) ->
    fix = @tokenFromWrapper(wrapper)
    fix.pre = fix.pre.printf(args[0]...)
    fix.suf = fix.suf.printf((args[1] || args[0])...)
    [fix.pre, fix.suf]


  tokenFromWrapper: (wrapper) ->
    wrapper = @wrappers[wrapper] if typeof(wrapper) == 'string'
    [pre, suf] = wrapper
    suf ?= pre
    pre: pre, suf: suf, regexp: wrapper[2] || new RegExp("^#{pre.regExpEscape()}|#{suf.regExpEscape()}$", 'gi')


  getTokenAndSelection: (wrapper) ->
    [@tokenFromWrapper(wrapper), @getSelection()]

