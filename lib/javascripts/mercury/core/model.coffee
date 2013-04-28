#= require mercury/core/events
#= require mercury/core/i18n
#= require mercury/core/logger
#= require mercury/core/stack
#= require mercury/core/module

class Mercury.Model extends Mercury.Module
  @extend  Mercury.Config
  @extend  Mercury.Events
  @include Mercury.Config
  @include Mercury.Events
  @include Mercury.I18n
  @include Mercury.Logger
  @include Mercury.Stack

  @logPrefix: 'Mercury.Model:'

  @idCounter: 1

  # Define the model by setting className and urlPrefix. Must be called so we can generate a new collection object. This
  # also clears any events that might already exist, and sets some useful stuff like logPrefix.
  # Returns itself for chaining.
  #
  @define: (@className, @urlPrefix) ->
    @logPrefix = @::logPrefix = "#{@className}:"
    @records = {}
    @off()
    @


  # Class level url generator. This method is typically called from within save, and the instance is expected to be
  # passed. If the record isn't a new record the id will be appended to the url.
  # Returns the url.
  #
  @url: (record) ->
    @urlPrefix


  # Finds a record by id (falling back to cid if not found) in the collection. Throws an exception if the record isn't
  # found.
  # Returns the record.
  #
  @find: (id) ->
    record = @records[id]
    return @find("c#{id}") if !record && ("#{id}").match(/^\d+/)
    throw new Error("#{@className} found no records with the ID '#{id}'") unless record
    record


  # Returns all records as an array.
  #
  @all: ->
    record for id, record of @records


  # Returns the count of the records.
  #
  @count: ->
    @all().length


  # Returns all records as an array (same as #all).
  #
  @toJSON: ->
    @all()


  # Checks to see if the collection contains a record for the given id. Handles the error when the record isn't found.
  # Returns the record, or false if not found.
  #
  @contains: (id) ->
    try return @find(id)
    catch e
      return false


  # Generates a unique id for new records.
  #
  @uid: (prefix = '') ->
    uid = prefix + @idCounter++
    uid = @uid(prefix) if @contains(uid)
    uid


  # The constructor accepts attributes and will set them using #set. All records recieve a generated cid.
  #
  constructor: (attrs = {}) ->
    @attributes = {}
    @errors = {}
    @set(attrs)
    @cid = @constructor.uid('c')
    super


  # Validates the current attributes. It's expected that you add errors in your own models implementation by adding
  # error messages to @errors using:
  #
  # @addErrors('attrName', 'error message')
  #
  validate: ->


  # Saves the record using ajax. The HTTP method is POST or PUT based on if the record is new or not. It provides
  # default success and error handlers, but since it returns the ajax call you can also use the promise pattern for
  # event callbacks.
  # Returns false if the record isn't valid, otherwise returns a jQuery ajax object.
  #
  # It's expected that your server responds with JSON that contains the id, and any other attributes that the server
  # thinks the client should have.
  #
  save: (options = {}) ->
    return false unless @isValid()
    defaultOptions =
      method  : if @isNew() then 'POST' else 'PUT'
      url     : @constructor.url(@)
      accepts : 'application/json'
      cache   : false
      data    : @toJSON()
      success : (json) =>
        @id = json.id
        @constructor.records[@id] = @ if @id
        @set(json)
        @trigger('save')
        @saveSuccess?(arguments...)
      error   : (xhr) =>
        @trigger('error')
        @notify(@t('Unable to process response: %s', xhr.status))
        @saveError?(arguments...)
    $.ajax($.extend(defaultOptions, options))


  # Returns the attributes after being cloned.
  #
  toJSON: ->
    $.extend(true, {}, @attributes)


  # Returns true or false based on if the record has an id and is in the collection.
  #
  isNew: ->
    not @exists()


  # Triggers the validation. During validation it's expected that errors may be added to @errors in #validate.
  # Returns true if there were no errors generated, otherwise false.
  #
  isValid: ->
    @errors = {}
    @validate()
    for name, value of @errors
      return false
    return true


  # Adds an error message for a given attribute. Provides a consitent method to add errors and messages for a given
  # attribute when they don't pass validation.
  #
  addError: (attr, message) ->
    (@errors[attr] ||= []).push(message)


  # Collects errors into a more readable message.
  # Returns false if there are no errors, otherwise collects the errors into a more readable string.
  #
  errorMessages: ->
    return false if @isValid()
    errors = []
    errors.push("#{value.join(', ')}") for attr, value of @errors
    errors.join('\n')


  # Getter for attributes. It's advised to use this method when getting attributes, but you're encouraged to provide
  # your own getters that call through to this.
  # Returns the attribute value, or undefined if the attribute doesn't exist.
  #
  get: (key) ->
    @attributes[key]


  # Setter for attributes. You should always set attributes using #set so changes can be tracked and reverted in the
  # case of validation failure.
  # Accepts either a key and value, or an object of key value pairs.
  #
  set: (key, value) ->
    attrs = {}
    if typeof(key) == 'object' then attrs = key else attrs[key] = value
    @pushStack(@toJSON())
    @attributes[key] = value for key, value of attrs


  # Checks existence. Which is if there's an id and that id exists in the records.
  # Returns true or false.
  #
  exists: ->
    @id && @id of @constructor.records
