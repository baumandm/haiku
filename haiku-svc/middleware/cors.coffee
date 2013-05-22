# CORS middleware 
exports.allowCrossDomain = (req, res, next) ->
    res.header "Access-Control-Allow-Origin", req.headers.origin or "*"
    res.header "Access-Control-Allow-Methods", "GET,PUT,POST,DELETE"
    res.header "Access-Control-Allow-Headers", "Content-Type, Authorization"
    res.header "Cache-Control", "no-store"
    res.header "Pragma", "no-cache"
    res.header "Expires", "0"
  
    # intercept OPTIONS method
    if req.method == "OPTIONS"
        res.send 200
    else
        next()
    @