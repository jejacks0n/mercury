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
