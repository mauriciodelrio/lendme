express = require('express')
router = express.Router()

### GET home page. ###

router.get '/', (req, res, next) ->
  console.log 'aaaa'
  res.render 'index', title: 'Express'

module.exports = router