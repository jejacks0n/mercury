Object.toParams = (params) ->
  pairs = []
  do proc = (object = params, prefix = null) ->
    for own key, value of object
      if value instanceof Array
        proc(el, if prefix? then "#{prefix}[#{key}][]" else "#{key}[]") for el, i in value
      else if value instanceof Object
        proc(value, if prefix? then prefix += "[#{key}]" else prefix = key)
      else
        pairs.push(if prefix? then "#{prefix}[#{key}]=#{value}" else "#{key}=#{value}")
  pairs.join('&')


Object.serialize = (obj, arr = [], prefix) ->
  if Object::toString.call(obj) != '[object Object]'
    arr.push(name: prefix, value: obj)
    return arr

  for own key, val of obj
    thisPrefix = if prefix then "#{prefix}[#{key}]" else key
    type = Object::toString.call(val)
    if type == '[object Object]'
      Object.serialize(val, arr, thisPrefix);
    else if type == '[object Array]'
      Object.serialize(v, arr, "#{thisPrefix}[]") for v in val
    else
      arr.push(name: thisPrefix, value: val)
  arr


Object.deserialize = (arr, obj = {}) ->
  lookup = obj
  for item in arr
    named = item.name.replace(/\[([^\]]+)?\]/g, ",$1").split(",")
    cap = named.length - 1
    i = 0
    while i < cap
      if lookup.push
        # this is an array, add values instead of setting them
        # push an object if this is an empty array or we are about to overwrite a value
        if !lookup[lookup.length - 1] ||                          # this is an empty array
           lookup[lookup.length - 1].constructor != Object ||     # current value is not a hash
           lookup[lookup.length - 1][named[i + 1]] != undefined   # current item is already set
          lookup.push({})
        lookup = lookup[lookup.length - 1]
      else
        lookup = lookup[named[i]] = lookup[named[i]] || (if named[i + 1] == "" then [] else {})
      i++
    if lookup.push then lookup.push item.value
    else lookup[named[cap]] = item.value
    lookup = obj
  obj
