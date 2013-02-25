#= require spec_helper
#= require mercury/extensions/number

describe "Number", ->

  describe "#toHex", ->

    it "converts a number to it's hex value", ->
      expect( 100.toHex() ).to.eq('64')
      expect( 255.toHex() ).to.eq('FF')

    it "pads 0-F with a 0", ->
      expect( 0.toHex() ).to.eq('00')
      expect( 15.toHex() ).to.eq('0F')


  describe "#toBytes", ->

    it "converts a number to a readable byte representation (eg. 1.2 kb, 3.4 Mb)", ->
      bytes = 36
      expect( bytes.toBytes() ).to.eq('36 bytes')

      kb = 1024
      expect( kb.toBytes() ).to.eq('1.00 kb')
      expect( (kb + 100).toBytes() ).to.eq('1.10 kb')
      expect( (kb * 1000).toBytes() ).to.eq('1000.00 kb')

      mb = kb * 1024
      expect( mb.toBytes() ).to.eq('1.00 Mb')

      gb = mb * 1024
      expect( gb.toBytes() ).to.eq('1.00 Gb')

      tb = gb * 1024
      expect( tb.toBytes() ).to.eq('1.00 Tb')

      pb = tb * 1024
      expect( pb.toBytes() ).to.eq('1.00 Pb')

      eb = pb * 1024
      expect( eb.toBytes() ).to.eq('1.00 Eb')
