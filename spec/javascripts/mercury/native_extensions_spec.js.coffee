describe "String", ->

  describe "#titleize", ->

    it "should capitalize the first letter in a string", ->
      expect('wow!'.titleize()).toEqual('Wow!')


  describe "#toHex", ->

    it "converts a rgb(0, 0, 0) type string to hex", ->
      expect('rgb(0, 0, 0)'.toHex()).toEqual('#000000')
      expect('rgb(255, 255, 0)'.toHex()).toEqual('#FFFF00')


  describe "#regExpEscape", ->

    it "escapes characters used in regular expressions", ->
      expect('/.*+?|()[]{}\\'.regExpEscape()).toEqual('\\/\\.\\*\\+\\?\\|\\(\\)\\[\\]\\{\\}\\\\')


  describe "#printf", ->

    it "works something like a basic implementation of the standard sprintf", ->
      expect('int %d'.printf(2.1)).toEqual('int 2')
      expect('int%d'.printf(2.1)).toEqual('int2')
      expect('%d-int'.printf(2.1)).toEqual('2-int')
      expect('%f float'.printf(2.1)).toEqual('2.1 float')
      expect('%s string'.printf(2.1)).toEqual('2.1 string')
      expect('%% a'.printf(2.1)).toEqual('% a')
      expect('a %% b'.printf()).toEqual('a % b')
      expect('a %% %d'.printf(2.1)).toEqual('a % 2')
      expect('%d\n%s'.printf(2.1, 'string')).toEqual('2\nstring')


describe "Number", ->

  describe "#toHex", ->

    it "converts a number to it's hex value", ->
      expect(100.toHex()).toEqual('64')
      expect(255.toHex()).toEqual('FF')

    it "pads 0-F with a 0", ->
      expect(0.toHex()).toEqual('00')
      expect(15.toHex()).toEqual('0F')

  describe "#toBytes", ->

    it "converts a number to a readable byte representation (eg. 1.2 kb, 3.4 Mb)", ->
      kb = 1024
      expect(kb.toBytes()).toEqual('1.00 kb')
      expect((kb + 100).toBytes()).toEqual('1.10 kb')
      expect((kb * 1000).toBytes()).toEqual('1000.00 kb')
      expect((kb * 1024).toBytes()).toEqual('1.00 Mb')
      expect((kb * 1024 * 1024).toBytes()).toEqual('1.00 Gb')
      expect((kb * 1024 * 1024 * 1024).toBytes()).toEqual('1.00 Tb')
      expect((kb * 1024 * 1024 * 1024 * 1024).toBytes()).toEqual('1.00 Pb')
      expect((kb * 1024 * 1024 * 1024 * 1024 * 1024).toBytes()).toEqual('1.00 Eb')

