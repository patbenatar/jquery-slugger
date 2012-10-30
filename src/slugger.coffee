class @Slugger

  settings:
    slugInput: null
    safeMode: true
    cleanseSlugInput: true

  input: $()
  lastSlug: null
  generatedSlug: null
  slugIsDirty: false
  caretLibExists: false

  constructor: ($el, options) ->

    # Merge default options
    @options = $.extend({}, @settings, options)

    unless @options.slugInput?
      throw "You must provide a slugInput jQuery object"

    # Do we have the (optionally) dependent caret lib?
    @caretLibExists = !!$().caret

    @$input = $el

    @$input.bind "keyup", @onInputKeyup
    # Bind to keyup events on @options.slugInput so we can keep
    # it cleansed as user edits it
    if @options.cleanseSlugInput
      @options.slugInput.bind "keyup", @onSlugInputKeyup
    # Bind to change events on @options.slugInput so we know when user
    # clears it
    @options.slugInput.bind "change", @onSlugInputChange

    # Grab initial values for string and slug from their inputs
    @lastSlug = @options.slugInput.val()
    @generatedSlug = Slugger.utils.convert(@$input.val())

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
    if @options.safeMode
      @safeUpdate()
    else
      @dirtyUpdate()
    @render()

  safeUpdate: ->
    @lastSlug = @options.slugInput.val()
    string = @$input.val()
    if @lastSlug != @generatedSlug and @lastSlug != ''
      @slugIsDirty = true
    else
      @slugIsDirty = false
      @generatedSlug = Slugger.utils.convert(string)

  dirtyUpdate: ->
    @slugIsDirty = false
    string = @$input.val()
    @generatedSlug = Slugger.utils.convert(string)

  render: ->
    @options.slugInput.val @generatedSlug unless @slugIsDirty

  # Keep slug cleansed as user types into slugInput
  # Doesn't trim trailing whitespace
  # Returns a hash with some useful information about the change
  # as well as the cleansedString
  cleanse: (str) ->
    cStr = Slugger.utils.replace(str)
    return {
      cleansedString: cStr
      changeOccurred: cStr != str
      difference: str.length - cStr.length
    }