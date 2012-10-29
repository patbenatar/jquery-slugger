$ = jQuery

$.fn.extend
  slugger: (options) ->
    $(@).each ->
      new Slugger($(@), options)