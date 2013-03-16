@Mercury ||= {}

class Mercury.Module

  # Reserved method names.
  moduleKeywords = ['included', 'extended', 'private']

  # Extend methods from one object onto self (add to class methods). If the passed object has a Module property that's
  # used, otherwise the object passed is used.
  #
  # This would add method1 to the Klass properties.
  #
  # class Klass extends Mercury.Module
  #   @extend {method1: function() { }}
  #
  # Klass.method1                                => function() { }
  #
  # Similarly you can call extend externally to add properties to an object.
  #
  # Mercury.Module.extend.call(Klass, {method2: function() { })
  #
  # Klass.method2                                => function() { }
  #
  @extend: (object) ->
    throw new Error('extend expects an object') unless object
    module = object.Module || object
    for name, method of module
      continue if moduleKeywords.indexOf(name) > -1
      @[name] = method
    module.extended?.apply(@)


  # Include methods from one object onto self (add to prototype). If the passed object has a Module property that's
  # used, otherwise the object passed is used.
  #
  # This would add method1 to the Klass prototype.
  #
  # class Klass extends Mercury.Module
  #   @include {method1: function() { }}
  #
  # instance = new Klass()
  # instance.method1                             => function() { }
  #
  # Similarly you can call include externally to add to the prototype of an existing object.
  #
  # Mercury.Module.include.call(Klass, {method2: function() { })
  #
  # Klass.prototype.method2                      => function() { }
  #
  @include: (object) ->
    throw new Error('include expects an object') unless object
    module = object.Module || object
    for name, method of module
      continue if moduleKeywords.indexOf(name) > -1
      @::[name] = method
    module.included?.apply(@::)


  # Provides a way to call a method within the scope of an object.
  #
  @proxy: (callback) ->
    => callback.apply(@, arguments)


  # Default constructor for subclasses. Calls #init if it's defined.
  #
  constructor: ->
    @__handlers__ = $.extend({}, @__handlers__)
    @init?(arguments...)


  # Provides a way to call a method within the scope of an instance.
  #
  proxy: (callback) ->
    => callback.apply(@, arguments)
