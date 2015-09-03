Template.postItem.helpers

  commentsCount: -> Comments.find(postId: this._id).count()

  ownPost: -> this.userId == Meteor.userId()

  domain: ->
    a = document.createElement('a')
    a.href = this.url
    a.hostname
