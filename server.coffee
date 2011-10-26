# Used zappa example as a base:
# https://github.com/mauricemach/zappa/blob/master/examples/chat.coffee

require('zappa') 3456, ->
  @enable 'serve jquery'
  @settings.minify = true

  uuid = Math.floor(Math.random() * 100000000)
  
  @get '/': ->
    @render index: {layout: no}

  @on connection: ->
    @emit init: {roomId: uuid}
  
  @on 'set nickname': ->
    @client.nickname = @data.nickname
  
  @on said: ->
    return if @data.roomId isnt uuid
    @broadcast said: {nickname: @client.nickname, text: @data.text}
    @emit said: {nickname: @client.nickname, text: @data.text}
  
  @client '/index.js': ->
    @connect()

    roomId = null

    @on init: ->
      roomId = @data.roomId

    @on said: ->
      $('#panel').append "<p>&lt;#{@data.nickname}&gt; #{@data.text}</p>"

    $ =>
      @emit 'set nickname': {nickname: prompt 'Pick a nickname!'}

      $('#box').focus()

      $('button').click (e) =>
        @emit said: {roomId: roomId, text: $('#box').val()}
        $('#box').val('').focus()
        e.preventDefault()

  @view index: ->
    doctype 5
    html ->
      head ->
        title 'Random chat!'
        script src: '/socket.io/socket.io.js'
        script src: '/zappa/jquery.js'
        script src: '/zappa/zappa.js'
        script src: '/index.js'
      body ->
        div id: 'panel'
        form ->
          input id: 'box'
          button 'Send'
