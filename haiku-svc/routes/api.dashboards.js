###
# API for Haikus
###

_ = require "lodash"
mongoose = require 'mongoose'
    
## TODO
# var Dashboards = mongoose.model('dashboard');

###/* If there wasn't an error, output the object.  
   Otherwise log the error and send a 500 */
var typicalOutputMethod = function(res, errorCode) { 
    return function(err, theObject) {
        if (!err) {
            return res.send(theObject);
        } else {
            console.log(err);

            /* Send a custom error code if defined, else 500 */
            if (!_.isUndefined(errorCode))
                res.send(errorCode);
            else
                res.send(500);               
        }
    };
};###

exports.get = (req, res) ->
    console.log(new Date().toISOString() + " GET /haikus")
    res.send 200
    #Dashboards.find(typicalOutputMethod(res));


exports.getSingle = function (req, res) {

    var name = req.params.name.toLowerCase();
    console.log(new Date().toISOString() + " GET /dashboards/" + name);
    return Dashboards.findOne({name: name}, function(err, dashboard) {
        if (err || _.isUndefined(dashboard) || _.isNull(dashboard)) {
            console.log(err);
            res.send(404);
        } else {
            return res.send(dashboard);
        }
    });
};

exports.post = function (req, res) {

    console.log(new Date().toISOString() + " POST /dashboards");
    console.log(JSON.stringify(req.body));

    var newDashboard = new Dashboards({
        name: req.body.name.toLowerCase(),
        pages: req.body.pages,
        theme: req.body.theme,
        style: req.body.style,
        duration: req.body.duration,
        preload: req.body.preload
    });
   
    newDashboard.save(function (err) {
        if (!err) {
            console.log("created new dashboard");
            res.send(newDashboard);
        } else {
            console.log(err);
            return res.send(400);
        }
    });
};

exports.putSingle = function (req, res) {

    console.log(new Date().toISOString() + " PUT /dashboards/:name");
    console.log(JSON.stringify(req.body));

    return Dashboards.findOne({name: req.params.name.toLowerCase()}, function (err, dashboard) {

        /* TODO: Save to history array */

        /* Update properties */
        dashboard.pages = req.body.pages;
        dashboard.theme = req.body.theme;
        dashboard.style = req.body.style;
        dashboard.duration = req.body.duration;
        dashboard.preload = req.body.preload;
        
        dashboard.save(function (err) {
            if (!err) {
                console.log("updated dashboard");
                res.send(200);
            } else {
                console.log(err);
                res.send(500);
            }
            return res.send(dashboard);   
        });
    });
};

exports.deleteSingle = function (req, res) {

    var name = req.params.name.toLowerCase();
    console.log(new Date().toISOString() + " DELETE /dashboards/" + name);
    return Dashboards.remove({name: name}, 
        function (err) {
            if (!err) {
                console.log("deleted" + name);
                res.send(200);
            } else {
                console.log(err);
                res.send(500);
            }
        }
    );
};