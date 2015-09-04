@Posts = new Mongo.Collection 'posts'

Posts.allow
  update: (userId, post) -> ownsDocument(userId, post)
  remove: (userId, post) -> ownsDocument(userId, post)

Posts.deny
  update: (userId, post, fieldNames) ->
    _.without(fieldNames, 'url', 'title').length > 0

Posts.deny
  update: (userId, post, fieldNames, modifier) ->
    errors = validatePost(modifier.$set)
    return errors.title || errors.url

@validatePost = (post) ->
  errors = {}
  if !post.title
    errors.title = "Please fill in a headline"

  if !post.url
    errors.url = "Please fill in a URL"

  return errors

Meteor.methods
  postInsert: (postAttributes)->
    check(this.userId, String)
    check(postAttributes,
      title: String
      url: String)

    errors = validatePost(postAttributes)
    if errors.title || errors.url
      throw new Meteor.Error('invalid post', 'You must set a title and URL for your post')

    postWithSameLink = Posts.findOne(url: postAttributes.url)
    if postWithSameLink
      return {
        postExists: true
        _id: postWithSameLink._id
      }

    user = Meteor.user()

    post = _.extend(postAttributes,
      userId: user._id
      author: user.username
      submitted: new Date())

    postId = Posts.insert(post)
    return _id: postId
