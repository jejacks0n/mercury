#= require mercury/core/plugin

Plugin =
  # General plugin definition.
  #
  # Each plugin should define the basic information so plugins can be displayed or understood. Plugins should use a
  # unique name, provide a general description and specify a version.
  #
  name: 'character'
  description: 'Provides interface for selecting and inserting special characters.'
  version: '1.0.0'

  # Configuration.
  #
  # Plugins can use the config key to specify various internal configuration values. These are specific to the plugin,
  # and can be accesses using the #config method -- much like the Mercury.config method you can provide a path to an
  # object value. When asking a plugin for a configuration that's also specified in Mercury, the plugin overrides the
  # top level value -- but only within the plugin.
  #
  config:
    modal: false
    characters: '38 34 162 8364 163 165 169 174 8482 8240 181 183 8226 8230 8242 8243 167 182 223 8249 8250 171 187 8216 8217 8220 8221 8218 8222 60 62 8804 8805 8211 8212 175 8254 164 166 168 161 191 710 732 176 8722 177 247 8260 215 185 178 179 188 189 190 402 8747 8721 8734 8730 8764 8773 8776 8800 8801 8712 8713 8715 8719 8743 8744 172 8745 8746 8706 8704 8707 8709 8711 8727 8733 8736 180 184 170 186 8224 8225 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 216 338 352 217 218 219 220 221 376 222 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 248 339 353 249 250 251 252 253 254 255 913 914 915 916 917 918 919 920 921 922 923 924 925 926 927 928 929 931 932 933 934 935 936 937 945 946 947 948 949 950 951 952 953 954 955 956 957 958 959 960 961 962 963 964 965 966 967 968 969 8501 982 8476 977 978 8472 8465 8592 8593 8594 8595 8596 8629 8656 8657 8658 8659 8660 8756 8834 8835 8836 8838 8839 8853 8855 8869 8901 8968 8969 8970 8971 9001 9002 9674 9824 9827 9829 9830'

  # Specifying actions.
  #
  # Actions should be ordered based on preference, the first being the preferred, and every other one as a fallback.
  # When you call #triggerAction, the region is asked for what is supported in the order defined here. When a supported
  # action is determined the callback provided is called with the determined action and any values that were passed to
  # #triggerAction.
  #
  actions:
    html: 'insertHtml'
    text: 'insertText'

  # When a plugin is specified for a button, this will be called with the button. You can add additional functionality
  # to the button from within this method.
  #
  registerButton: (@button) ->
    return if @config('modal')
    @button.subview = new Plugin.Palette()

  # When a plugin is specified for a button this callback will be called when the button is clicked.
  #
  onButtonClick: ->
    new Plugin.Modal() if @config('modal')

  # Action handlers -- typically trigger an action event, but are left unrestricted for whatever might be desired.
  #
  insertHtml: (name, value) -> Mercury.trigger('action', 'html', "&##{value};")
  insertText: (name, value) -> Mercury.trigger('action', 'text', $("<em>&##{value};</em>").html())


# Register the plugin, and reassign the variable to the instance returned. This allows us to use it as a Plugin instance
# from here out.
Plugin = Mercury.registerPlugin('character', Plugin)


# Defines the modal view -- if configured to use modal.
class Plugin.Modal extends Mercury.Modal
  template:  'character'
  className: 'mercury-character-modal'
  title:     'Character Picker'
  width:     400
  events:    'click li': (e) -> Plugin.triggerAction($(e.target).data('value'))


# Defines the palette view -- if configured not to use modal.
class Plugin.Palette extends Mercury.ToolbarPalette
  template:  'character'
  className: 'mercury-character-palette'
  events:    'click li': (e) -> Plugin.triggerAction($(e.target).data('value'))


# Define the template to be used in both the palette and modal -- since we can share the template.
@JST ||= {}
JST['/mercury/templates/character'] = (scope) ->
  """<ul>#{("<li data-value='#{char}'>&##{char};</li>" for char in Plugin.config('characters').split(' ')).join('')}</ul>"""
