#= require spec_helper
#= require mercury/core/extensions/string

describe "String", ->

  describe "#trim", ->

    it "strips whitespace off the beginning and end of a string", ->
      expect( ' _foo_   '.trim() ).to.eq('_foo_')


  describe "#toCamelCase", ->

    it "converts dashes and underscores to camelcase", ->
      expect( 'string-with_underscores_and-dashes'.toCamelCase() ).to.eq('stringWithUnderscoresAndDashes')

    it "does studlycase", ->
      expect( 'string-with-dashes'.toCamelCase(true) ).to.eq('StringWithDashes')


  describe "#toDash", ->

    it "converts camelcase to dashes", ->
      expect( 'StudlyCaseString'.toDash() ).to.eq('studly-case-string')


  describe "#toUnderscore", ->

    it "converts camelcase to dashes", ->
      expect( 'StudlyCaseString'.toUnderscore() ).to.eq('studly_case_string')


  describe "#toTitleCase", ->

    it "makes a string titlecase", ->
      expect( 'some string'.toTitleCase() ).to.eq('Some string')


  describe "#toHex", ->

    it "converts a rgb(0, 0, 0) type string to hex", ->
      expect( 'rgb(0, 0, 0)'.toHex() ).to.eq('#000000')
      expect( 'rgb(255, 255, 0)'.toHex() ).to.eq('#FFFF00')

    it "doesn't do anything if it already looks like hex", ->
      expect( '#foo'.toHex() ).to.eq('#foo')


  describe "#regExpEscape", ->

    it "escapes characters used in regular expressions", ->
      expect( '/.*+?|()[]{}\\'.regExpEscape() ).to.eq('\\/\\.\\*\\+\\?\\|\\(\\)\\[\\]\\{\\}\\\\')


  describe "#printf", ->

    it "works something like a basic implementation of the standard sprintf", ->
      expect( 'int %d'.printf(2.1) ).to.eq('int 2')
      expect( 'int%d'.printf(2.1) ).to.eq('int2')
      expect( '%d-int'.printf(2.1) ).to.eq('2-int')
      expect( '%f float'.printf(2.1) ).to.eq('2.1 float')
      expect( '%s string'.printf(2.1) ).to.eq('2.1 string')
      expect( '%% a'.printf(2.1) ).to.eq('% a')
      expect( 'a %% b'.printf() ).to.eq('a % b')
      expect( 'a %% %d'.printf(2.1) ).to.eq('a % 2')
      expect( '%d\n%s'.printf(2.1, 'string') ).to.eq('2\nstring')
