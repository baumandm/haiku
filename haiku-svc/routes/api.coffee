###
# API Wireup
###

exports.haikus = haikus = require './api.haikus'

exports.notAllowed = (req, res) ->
    res.send 405

exports.index = (req, res) ->
    res.sendfile 'public/index.html'

exports.configure = (app) ->
    # REST Routes
    app.get '/haikus/random', haikus.getRandom
    app.get '/haikus/:id', haikus.getSingle
    app.get '/haikus/:id/like', haikus.likeSingle
    app.post '/haikus/:id', exports.notAllowed
    app.put '/haikus/:id', exports.notAllowed
    app.delete '/haikus/:id', haikus.deleteSingle

    app.get '/haikus', haikus.get
    app.post '/haikus', haikus.post
    app.put '/haikus', exports.notAllowed
    app.delete '/haikus', exports.notAllowed

    # Redirect all other routes to the index page
    app.get '*', exports.index

