###
# Mongo DB code
###

mongoose = require 'mongoose'
shortId = require('shortid').seed(90371)

# Connect to Mongo
mongoose.connect('mongodb://localhost/haiku')

haikuSchema = new mongoose.Schema({
    _id: {
        type: String, 
        required: true, 
        unique: true, 
        default: -> 
            return shortId.generate()
    }
    author:      {type: String}
    text:        {type: String}
    createdByIp: {type: String}
    createdDate: {type: Date, default: Date.now}
    likes:       {type: Number}
})

haikuModel = mongoose.model('haiku', haikuSchema);

ipSchema = new mongoose.Schema({
    ip:         {type: String}
    likes:      {type: []}
})

ipModel = mongoose.model('ip', ipSchema);

counterSchema = new mongoose.Schema({
    name:       {type: String}
    count:      {type: Number}
})

counterModel = mongoose.model('counter', counterSchema)

# Unique counter
counterSchema.index({name: "haikus"}, {unique: true})
counterModel.findOne({name: "haikus"}, (err, data) ->
    if (!data)
        haikuCounter = new counterModel({
            name: "haikus", 
            count: 0
        })
        haikuCounter.save()
)
