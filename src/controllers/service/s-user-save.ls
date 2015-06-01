require! {User:'../../models/user', 'bcrypt-nodejs', 'passport-local'}

is-valid-password = (user, password)-> bcrypt-nodejs.compare-sync password, user.password
hash = (password)-> bcrypt-nodejs.hash-sync password, (bcrypt-nodejs.gen-salt-sync 10), null

# save user information
module.exports = (req, res)!->

  uid = req.user._id
  userObj = req.user

  if req.body.type == "basic"
    console.log "updating basic info..."
    User.findById uid, (err, user)!->
      if err
        console.log err
      else
        user.email = req.body.user.email
        user.save (err, user) !-> if err then console.log err

    #TODO save avatar to file if user upload a new icon


  if req.body.type == "pwd"
    console.log "updating user password..."
    if is-valid-password req.user, req.body.user.pwdOriginal
      console.log "original password valid"

      User.findById uid, (err, user)!->
        if err
          console.log err
        else if req.body.user.pwdNew == req.body.user.pwdNewConfirm
          user.password = hash req.body.user.pwdNew
          user.save (err, user) !-> if err then console.log err
          console.log "update password success!"
        else
          console.log "two new password not match!"

    else
      console.log "original password invalid"

  if req.body.type == "realInfo"
    console.log "updating real info..."

    User.findById uid, (err, user)!->
      if err
        console.log err
      else
        user.real_name = req.body.user.real_name
        user.phone_num = req.body.user.phone_num
        user.save (err, user) !-> if err then console.log err
