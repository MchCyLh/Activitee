require! {Activity:'../../models/activity', Tag:'../../models/tag', Comment:'../../models/comment'}

# edit page
module.exports = (req, res)!->
  id = req.params.id
  if id
    # Activity.findById id, (err, activity)!->
    (err, activity) <- Activity .find-one { _id : id } .populate 'tags' .exec
    if err
      console.log err
    
    Tag.find {}, (err, tags)->
      if err
        console.log err
      tagNames = []
      actTags = []
      for tag in tags
        tagNames.push tag.name
      for tag in activity.tags
        actTags.push tag.name
      res.render 'edit', {
        title: '修改活动信息'
        user: req.user
        tagNames: tagNames
        activity: activity
        actTags: actTags
      }


