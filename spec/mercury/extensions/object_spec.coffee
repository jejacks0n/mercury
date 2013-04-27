#= require spec_helper
#= require mercury/extensions/object

describe "Object", ->

  describe ".toParams", ->

    it "returns the expected params from an object", ->
      obj =
        arr: [1, 2, {foo: 'bar'}]
        str: 'foo'
        obj: {arr: [1, 2, {foo: 'bar'}], str: 'foo', obj: {bar: 'baz'}}
      expect( Object.toParams(obj) ).to.eq('arr[][foo]=bar&str=foo&obj[arr][][foo]=bar&obj[str]=foo&obj[obj][bar]=baz')
