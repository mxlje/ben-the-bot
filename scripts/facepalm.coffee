# Description:
#   Clearly illustrate with an image what people mean whenever they say "facepalm"
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
# Author:
#   jimeh
#
# Notes:
#   2014-10-23 removed explicit image extensions from URLs

module.exports = (robot) ->
  robot.hear /facepalm/i, (msg) ->
    # Randomly use facepalm.org or a Google Image search for "facepalm".
    if msg.random([0, 1])
      facepalmMe msg, (url) ->
        msg.send url
    else
      imageMe msg, "facepalm", (url) ->
        msg.send url

facepalmMe = (msg, cb) ->
  msg.http('http://facepalm.org/img.php').get() (err, res, body) ->
    cb "http://facepalm.org/#{res.headers['location']}"

imageMe = (msg, query, cb) ->
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(v: "1.0", rsz: '8', q: query, safe: 'active')
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData.results
      if images.length > 0
        image  = msg.random images
        cb image.unescapedUrl
