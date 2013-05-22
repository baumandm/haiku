###
# API for Haikus
###

_ = require "lodash"
mongoose = require 'mongoose'
    
## TODO
Haikus = mongoose.model('haiku')
Ips = mongoose.model('ip')
Counters = mongoose.model('counter')

#If there wasn't an error, output the object.  
#Otherwise log the error and send a 500 
typicalOutputMethod = (res, errorCode) ->
    return (err, theObject) ->
        if (!err)
            if _.isUndefined(theObject) || _.isNull(theObject)
                console.log("404")
                res.send 404
            else
                return res.send theObject
        else
            console.log(err)

            # Send a custom error code if defined, else 500 
            if !_.isUndefined(errorCode)
                res.send errorCode
            else
                res.send 500


# Get all haikus
exports.get = (req, res) ->
    console.log(new Date().toISOString() + " GET /haikus")
    Haikus.find(typicalOutputMethod(res))


# Get a single haiku
exports.getSingle = (req, res) ->

    id = req.params.id
    console.log(new Date().toISOString() + " GET /haikus/" + id)

    return Haikus.findOne({_id: id}, typicalOutputMethod(res))

# Get a random haiku
exports.getRandom = (req, res) ->
    Counters.findOne({name: "haikus"}, (err, counter) ->
        randomIndex = Math.floor(Math.random() * counter.count)

        Haikus.find().limit(-1).skip(randomIndex).exec(typicalOutputMethod(res))
    )
    

# Creates a new Haiku
exports.post = (req, res) ->

    console.log(new Date().toISOString() + " POST /haikus")
    console.log(JSON.stringify(req.body))

    newHaiku = new Haikus({
        author: req.body.author
        text: req.body.text
        createdByIp: req.ip
        likes: 0
    })
   
    newHaiku.save((err) ->
        if !err
            console.log "created new haiku" 
            res.send newHaiku
            Counters.update({name: "haikus"}, { $inc: { count: 1}}).exec()
        else 
            console.log err 
            return res.send 400
    )


# Delete a single Haiku
exports.deleteSingle = (req, res) ->

    id = req.params.id
    console.log(new Date().toISOString() + " DELETE /haikus/" + id)

    return Haikus.remove({"_id": id}, 
        (err) ->
            if !err
                console.log "deleted " + id
                res.send 200
            else
                console.log err
                res.send 500        
    )


# "Like" a single haiku
exports.likeSingle = (req, res) ->

    id = req.params.id
    console.log(new Date().toISOString() + " GET /haikus/" + id + "/like")

    # Allow each IP to like each haiku only once..
    Ips.findOne({ip: req.ip}, (err, ip) ->
        if err || _.isNull(ip)
            ip = new Ips({
                    ip: req.ip
                    likes: []
            })

        if _.contains(ip.likes, id)
            console.log "Already liked..."
            return res.send 202

        # Increment, add this IP to the list and save
        Haikus.update({_id: id}, { $inc: { likes: 1 }})
            .exec((err, haiku) ->
                if !err
                    console.log "Liked! " +id
                    ip.likes.push(id)
                    ip.save()
                    res.send 200
                else
                    console.log err
                    res.send 500   
            ) 
    )

