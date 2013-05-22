###
# Haiku REST Service.
###

express = require 'express'
_ = require "lodash"

# Initialize Mongoose
mongo = require './mongo'

# Initialize Express
app = module.exports = express()

# Application configuration
app.configure(->
    app.set "trust proxy", true
    app.use express.bodyParser()
    app.use express.methodOverride()

    # CORS configuration
    cors = require './middleware/cors'
    app.use cors.allowCrossDomain

    app.use app.router
)

app.configure('development', ->
    app.use express.errorHandler({ dumpExceptions: true, showStack: true })
)

app.configure('production', ->
    app.use express.errorHandler()
)

# Configure REST API
api = require './routes/api'
api.configure(app)

# Default port value.
# If IISNode set the port, use that configured value instead
port = 4900
if not _.isUndefined(process.env.PORT)
    port = process.env.PORT

# Start server
app.listen(port, ->
    console.log("Express server listening on port %d in %s mode", 
        this.address().port, 
        app.settings.env
    )
)
