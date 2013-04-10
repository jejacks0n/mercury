Mercury.View.Modules.ScrollPropagation =

  preventScrollPropagation: (el) ->
    el.on 'mousewheel DOMMouseScroll', (e) ->
      [delta, scrollTop] = [e.originalEvent.wheelDelta || -e.originalEvent.detail, el.scrollTop()]
      return false if delta > 0 && scrollTop <= 0
      return false if delta < 0 && scrollTop >= el.get(0).scrollHeight - el.height()
      return true

