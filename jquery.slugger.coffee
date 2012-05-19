$ = jQuery

$.fn.extend
  slugger: (options) ->
    $(@).each ->
      new Slugger($(@), options)

class Slugger

  settings:
    slugInput: null
    safeMode: true
    cleanseSlugInput: true

  input: $()
  string: null
  slug: null
  slugIsDirty: false
  caretLibExists: false

  constructor: ($el, options) ->

    # Merge default options
    @options = $.extend({}, @settings, options)

    unless @options.slugInput?
      throw "You must provide a slugInput jQuery object"

    # Do we have the (optionally) dependent caret lib?
    @caretLibExists = !!$().caret

    # This plugin gets called on the container
    @$input = $el

    # Bind to keyup events on @$input
    @$input.bind "keyup", @onInputKeyup
    # Bind to keyup events on @options.slugInput so we can keep
    # it cleansed as user edits it
    if @options.cleanseSlugInput
      @options.slugInput.bind "keyup", @onSlugInputKeyup
    # Bind to change events on @options.slugInput so we know when user
    # clears it
    @options.slugInput.bind "change", @onSlugInputChange

    # Grab initial values for string and slug from their inputs
    @string = @$input.val()
    @slug = @options.slugInput.val()

    @update()

  onInputKeyup: (event) =>
    @update()

  onSlugInputKeyup: (event) =>
    cleansed = @cleanse(@options.slugInput.val())
    if cleansed.changeOccurred
      caretPos = @options.slugInput.caret() if @caretLibExists
      # Update value with cleansed string
      @options.slugInput.val(cleansed.cleansedString)
      # Restore caret position
      if @caretLibExists
        caretPos += cleansed.difference * -1
        @options.slugInput.caret(caretPos)

  onSlugInputChange: (event) =>
    @update() if @options.slugInput.val() == ''

  update: ->
    if @options.safeMode?
      @safeUpdate()
    else
      @dirtyUpdate()
    @render()

  safeUpdate: ->
    lastSlug = @options.slugInput.val()
    string = @$input.val()
    if lastSlug != @slug and lastSlug != ''
      @slugIsDirty = true
    else
      @slugIsDirty = false
      @slug = @convert(string)

  dirtyUpdate: ->
    @slugIsDirty = false
    string = @$input.val()
    @slug = @convert(string)

  render: ->
    @options.slugInput.val @slug unless @slugIsDirty

  convert: (str) ->
    str = str.replace(/^\s+|\s+$/g, '') # trim
    str = str.toLowerCase()

    # remove accents, swap ñ for n, etc
    from = "ãàáäâẽèéëêìíïîõòóöôùúüûñç·/_,:;"
    to = "aaaaaeeeeeiiiiooooouuuunc------"
    for i in from.length
      str = str.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i))

    str = str.replace(/[^a-z0-9 -]/g, ''). # remove invalid chars
      replace(/\s+/g, '-'). # collapse whitespace and replace by -
      replace(/-+/g, '-') # collapse dashes

    return str

  # Returns a hash with some useful information about the change
  # as well as the cleansedString
  cleanse: (str) ->
    cStr = str.toLowerCase()

    from = "ãàáäâẽèéëêìíïîõòóöôùúüûñç·/_,:;"
    to = "aaaaaeeeeeiiiiooooouuuunc------"
    for i in from.length
      cStr = cStr.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i))

    cStr = cStr.replace(/[^a-z0-9 -]/g, ''). # remove invalid chars
      replace(/\s+/g, '-'). # collapse whitespace and replace by -
      replace(/-+/g, '-') # collapse dashes

    return {
      cleansedString: cStr
      changeOccurred: cStr != str
      difference: str.length - cStr.length
    }