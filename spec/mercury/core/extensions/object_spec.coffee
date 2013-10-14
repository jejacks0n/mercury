#= require spec_helper
#= require mercury/core/extensions/object
#= require mercury/core/view
#= require mercury/views/modules/form_handler

describe "Object", ->

  describe ".toParams", ->

    it "returns the expected params from an object", ->
      obj =
        arr: [1, 2, {foo: 'bar'}]
        str: 'foo'
        obj: {arr: [1, 2, {foo: 'bar'}], str: 'foo', obj: {bar: 'baz'}}
      expect( Object.toParams(obj) ).to.eq('arr[][foo]=bar&str=foo&obj[arr][][foo]=bar&obj[str]=foo&obj[obj][bar]=baz')


  describe ".serialize", ->

    beforeEach ->
      Object::foo = 'bar'

    afterEach ->
      delete(Object::foo)

    it "serializes an object into an array of fields/inputs", ->
      obj =
        foo: 'bar'
        baz: ['foo', 'bar', ['foo', 'bar']]
        qux: {foo: {bar: 'baz'}}
      expect( Object.serialize(obj) ).to.eql [
        {name: 'foo', value: 'bar'}
        {name: 'baz[]', value: 'foo'}
        {name: 'baz[]', value: 'bar'}
        {name: 'baz[]', value: ['foo', 'bar']}
        {name: 'qux[foo][bar]', value: 'baz'}
      ]

    it "handles things other than objects", ->
      expect( Object.serialize('foo', [], 'pre[]') ).to.eql [
        {name: 'pre[]', value: 'foo'}
      ]

    it "adds to an existing array if one is passed", ->
      expect( Object.serialize('foo', [{name: 'bar', value: 'baz'}], 'pre[]') ).to.eql [
        {name: 'bar', value: 'baz'}
        {name: 'pre[]', value: 'foo'}
      ]


  describe ".deserializeArray", ->

    it "takes an array of objects with name/value and builds an object", ->
      arr = [
        {name: 'foo', value: 'bar'}
        {name: 'baz[]', value: 'foo'}
        {name: 'baz[]', value: ['foo', 'bar']}
        {name: 'qux[foo][bar]', value: 'baz'}
      ]
      expect( Object.deserialize(arr) ).to.eql
        foo: 'bar'
        baz: ['foo', ['foo', 'bar']]
        qux: {foo: {bar: 'baz'}}

    it "adds to an existing object if one is passed", ->
      arr = [
        {name: 'foo[bar]', value: 'baz'}
        {name: 'qux[foo][bar]', value: 'baz'}
      ]
      expect( Object.deserialize(arr, {bar: 'baz'}) ).to.eql
        bar: 'baz'
        foo: {bar: 'baz'}
        qux: {foo: {bar: 'baz'}}

    it "adds to an array if one is passed", ->
      arr = [name: 'qux[foo][bar]', value: 'baz']
      expect( Object.deserialize(arr, []) ).to.eql [
        foo: {bar: 'baz'}
      ]

