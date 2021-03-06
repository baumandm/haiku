// Generated by CoffeeScript 1.6.2
/*
# Haiku REST Service.
*/


(function() {
  var api, app, express, mongo, port, _;

  express = require('express');

  _ = require("lodash");

  mongo = require('./mongo');

  app = module.exports = express();

  app.configure(function() {
    var cors;

    app.set("trust proxy", true);
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    cors = require('./middleware/cors');
    app.use(cors.allowCrossDomain);
    return app.use(app.router);
  });

  app.configure('development', function() {
    return app.use(express.errorHandler({
      dumpExceptions: true,
      showStack: true
    }));
  });

  app.configure('production', function() {
    return app.use(express.errorHandler());
  });

  api = require('./routes/api');

  api.configure(app);

  port = 4900;

  if (!_.isUndefined(process.env.PORT)) {
    port = process.env.PORT;
  }

  app.listen(port, function() {
    return console.log("Express server listening on port %d in %s mode", this.address().port, app.settings.env);
  });

}).call(this);
