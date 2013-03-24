@JST ||= {}
JST['/mercury/templates/toolbar'] = (scope) ->
  """
  <ul class="mercury-toolbar-development-collection">
    <li data-action="interface">Toggle Interface</li>
    <li data-action="preview">Toggle Preview</li>
    <li data-action="undo">Undo</li>
    <li data-action="redo">Redo</li>
    <hr/>
    <li data-action="direction">custom action (toggle rtl/ltr)</li>
    <hr/>
    <li data-action="block" data-value="none">none</li>
    <li data-action="block" data-value="h1">h1</li>
    <li data-action="block" data-value="h2">h2</li>
    <li data-action="block" data-value="h3">h3</li>
    <li data-action="block" data-value="h4">h4</li>
    <li data-action="block" data-value="h5">h5</li>
    <li data-action="block" data-value="h6">h6</li>
    <li data-action="block" data-value="pre">pre</li>
    <li data-action="block" data-value="paragraph">paragraph</li>
    <li data-action="block" data-value="blockquote">blockquote</li>
    <hr/>
    <li data-action="bold">bold</li>
    <li data-action="italic">italic</li>
    <li data-action="underline">underline</li>
    <li data-action="subscript">subscript</li>
    <li data-action="superscript">superscript</li>
    <hr/>
    <li data-action="orderedList">orderedList</li>
    <li data-action="unorderedList">unorderedList</li>
    <hr/>
    <li data-action="indent">indent</li>
    <li data-action="outdent">outdent</li>
    <hr/>
    <li data-action="style" data-value="border:1px solid red">style</li>
    <li data-action="style" data-value="foo">class</li>
    <hr/>
    <li data-action="html" data-value="html">html (with html)</li>
    <li data-action="html" data-value="el">html (with element)</li>
    <li data-action="html" data-value="jquery">html (with jQuery)</li>
    <hr/>
    <li data-action="link" data-value='{"url": "https://github.com/jejacks0n/mercury", "text": "Project Home"}'>link</li>
    <li data-action="image" data-value='{"url": "http://goo.gl/UWYSd", "text": "Test Image"}'>image</li>
    <hr/>
    <li data-action="rule">rule</li>
    <hr/>
    <li><input type="text"/></li>
  </ul>
  """
