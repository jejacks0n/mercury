module MercurySelectorsHelpers

  def mercury_selector_for(locator)
    case locator

      # toolbar selectors
      when 'the toolbar' then '.mercury-toolbar-container'

      when /^the "(.*?)" button$/
        ".mercury-primary-toolbar .mercury-#{mercury_button_mapping_for($1)}-button"

      when /^the (.*?) editor (button|dropdown|palette)$/
        ".mercury-editable-toolbar .mercury-#{mercury_button_mapping_for($1)}-button"

      when /^the (.*?) toolbar button$/
        ".mercury-snippet-toolbar .mercury-#{mercury_button_mapping_for($1)}-button"

      when /^the (.*?) select$/
        ".mercury-#{mercury_button_mapping_for($1)}-select"

      when /^the (.*?) palette$/
        ".mercury-#{mercury_button_mapping_for($1)}-palette"

      # palette / select dropdown
      when 'the color red' then '.mercury-palette .picker:nth-child(22n)'

      when 'the red style' then '.mercury-select-options .red'
      when 'the heading 2 block' then '.mercury-select-options h2'

      # statusbar selectors
      when 'the statusbar' then '.mercury-statusbar'
      when 'the about the editor link' then 'a.mercury-statusbar-about'

      # panel selectors
      when 'the panel', /^the (.*?) panel$/ then '.mercury-panel'

      # modal window selectors
      when 'the modal', 'the modal window', /^the (.*?) modal$/ then '.mercury-modal'
      when 'the modal overlay' then '.mercury-modal-overlay'
      when 'the modal title' then '.mercury-modal h1.mercury-modal-title'
      when 'the modal close button' then '.mercury-modal h1.mercury-modal-title a'

      when 'the sweet snowman' then '.mercury-modal .character:nth-child(247n)'

      when 'the first cell in the first row' then '.mercury-modal tr:nth-child(1n) td:nth-child(1n)'
      when 'the third cell in the first row' then '.mercury-modal tr:nth-child(1n) td:nth-child(3n)'
      when 'the forth cell in the first row' then '.mercury-modal tr:nth-child(1n) td:nth-child(4n)'
      when 'the second cell in the second row' then '.mercury-modal tr:nth-child(2n) td:nth-child(2n)'
      when 'the forth cell in the second row' then '.mercury-modal tr:nth-child(2n) td:nth-child(4n)'

      when 'a selected cell' then '.mercury-modal td.selected'

      # lightview selectors
      when 'the lightview', 'the lightview window', /^the (.*?) lightview$/ then '.mercury-lightview'
      when 'the lightview overlay' then '.mercury-lightview-overlay'
      when 'the lightview title' then '.mercury-lightview h1.mercury-lightview-title'
      when 'the lightview close button' then '.mercury-lightview h1.mercury-lightview-title a'

      # snippet selectors
      when 'the snippet toolbar' then '.mercury-snippet-toolbar'
      when 'the snippet', 'that snippet' then "div[data-snippet=#{@snippet_id || 'snippet_42'}]"

      # other selectors
      when 'the first image' then 'img:nth-child(1n)'

    end
  end

  def mercury_button_mapping_for(locator)
    case locator.downcase

      # primary toolbar
      when 'save' then 'save'
      when 'preview' then 'preview'
      when 'undo' then 'undo'
      when 'redo' then 'redo'
      when 'link', 'insert link' then 'insertLink'
      when 'media', 'insert media' then 'insertMedia'
      when 'table', 'insert table' then 'insertTable'
      when 'character', 'insert character' then 'insertCharacter'
      when 'snippet', 'insert snippet' then 'snippetPanel'
      when 'history', 'view history' then 'historyPanel'
      when 'notes', 'view notes' then 'notesPanel'

      # editor toolbar
      when 'predefined styles' then 'style'
      when 'block format' then 'formatblock'
      when 'backcolor', 'background color' then 'backColor'
      when 'forecolor', 'foreground color' then 'foreColor'
      when 'italicize' then 'italic'
      when 'overline' then 'overline'
      when 'strike through' then 'strikethrough'
      when 'underline' then 'underline'
      when 'subscript' then 'subscript'
      when 'superscript' then 'superscript'
      when 'justify left', 'left justify' then 'justifyLeft'
      when 'justify center', 'center justify' then 'justifyCenter'
      when 'justify right', 'right justify' then 'justifyRight'
      when 'justify full', 'full justification' then 'justifyFull'
      when 'unordered list', 'insert unordered list' then 'insertUnorderedList'
      when 'ordered list', 'insert ordered list' then 'insertOrderedList'
      when 'hr', 'insert hr', 'horizontal rule', 'insert horizontal rule' then 'horizontalRule'
      when 'clean formatting', 'remove formatting' then 'removeFormatting'
      when 'html editor' then 'htmlEditor'

      # table context buttons
      when 'add row before', 'insert row before' then 'insertRowBefore'
      when 'add row after', 'insert row after' then 'insertRowAfter'
      when 'delete row' then 'deleteRow'
      when 'add column before', 'insert column before' then 'insertColumnBefore'
      when 'add column after', 'insert column after' then 'insertColumnAfter'
      when 'delete column' then 'deleteColumn'
      when 'increase colspan' then 'increaseColspan'
      when 'decrease colspan' then 'decreaseColspan'
      when 'increase rowspan' then 'increaseRowspan'
      when 'decrease rowspan' then 'decreaseRowspan'

      # snippet toolbar
      when 'edit snippet settings', 'edit snippet' then 'editSnippet'
      when 'remove snippet' then 'removeSnippet'

      else locator
    end
  end

  def region_selector_for(locator)
    case locator.downcase

      when 'the first editable region', 'the editable region' then '#editable1'
      when 'the first markupable region', 'the markupable region', 'the markdown region' then '#markupable1'
      when 'the first snippetable region', 'the first snippet region', 'the snippetable region', 'the snippet region' then '#snippetable1'

      else locator
    end
  end

  def snippet_name_for(locator)
    case locator.downcase

      when 'the example snippet' then 'example'

      else locator
    end
  end

end

World(MercurySelectorsHelpers)
