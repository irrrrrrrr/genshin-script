# @ts-check

class ConsoleG

  constructor: ->

    ###* @type import('./type/console').ConsoleG['isChanged'] ###
    @isChanged = false
    ###* @type import('./type/console').ConsoleG['lifetime'] ###
    @lifetime = 10e3
    ###* @type import('./type/console').ConsoleG['listContent'] ###
    @listContent = []

  ###* @type import('./type/console').ConsoleG['add'] ###
  add: (msg) ->

    id = ''
    if ($.startsWith msg, '#') and $.includes msg, ':'
      [id, string] = $.split msg, ':'
      if ($.length msg) > 40
        msg = "#{id}:\n  #{$.trim string}"
      msg = $.subString msg, 1

    tsOutdate = $.now() + @lifetime

    unless id
      $.push @listContent, [tsOutdate, msg, id]
      return

    hasId = false
    for item, i in @listContent
      unless id == item[2] then continue
      hasId = true
      @listContent[i] = [tsOutdate, msg, id]
      break

    if hasId then return
    $.push @listContent, [tsOutdate, msg, id]
    return

  ###* @type import('./type/console').ConsoleG['hide'] ###
  hide: ->
    Native 'ToolTip,, 0, 0, 20'
    return

  ###* @type import('./type/console').ConsoleG['init'] ###
  init: -> @watch()

  ###* @type import('./type/console').ConsoleG['log'] ###
  log: (ipt...) ->
    unless Config.get 'debug/enable' then return
    @add $.join ($.map ipt, $.toString), ' '
    @render()
    return

  ###* @type import('./type/console').ConsoleG['render'] ###
  render: $.throttle =>
    unless Client.isActive then return
    list = $.map @listContent, (item) -> item[1]
    text = $.trim ($.join list, '\n'), ' \n'
    [x, y] = [0 - Client.x, Point.h '55%']
    $.noop text, x, y
    Native 'ToolTip, % text, % x, % y, 20'
    return
  , 500

  ###* @type import('./type/console').ConsoleG['update'] ###
  update: ->
    unless Client.isActive then return
    now = $.now()
    len = $.length @listContent
    @listContent = $.filter @listContent, (item) -> item[0] >= now
    if len != $.length @listContent then @render()

  ###* @type import('./type/console').ConsoleG['watch'] ###
  watch: ->

    unless Config.get 'debug/enable' then return

    interval = 500
    token = 'console/watch'

    Client.on 'idle', =>
      Timer.remove token
      @hide()

    Client.on 'activate', =>
      Timer.loop token, interval, @update
      @update()

console = new ConsoleG()