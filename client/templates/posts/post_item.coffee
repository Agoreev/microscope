Template.postItem.helpers

  ownPost: -> this.userId == Meteor.userId()

  domain: ->
    a = document.createElement('a')
    a.href = this.url
    a.hostname

  upvotedClass: ->
    userId = Meteor.userId()
    if userId && !_.include(this.upvoters, userId)
      'btn-primary upvotable'
    else
      'disabled'

Template.postItem.events
  "click .upvote": (event) ->
    event.preventDefault()
    Meteor.call('upvote', this._id)
