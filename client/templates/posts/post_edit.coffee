Template.postEdit.events
  "submit form": (event) ->
    event.preventDefault()

    currentPostId = this._id
    postProperties =
      url: $(event.target).find('[name=url]').val()
      title: $(event.target).find('[name=title]').val()

    Posts.update(currentPostId, $set: postProperties, (error) ->
      if error
        alert(error.reason)
      else
        Router.go('postPage', {_id:currentPostId})
      )

  "click .delete": (event) ->
    event.preventDefault()

    if confirm("Delete this post?")
      currentPostId = this._id
      Posts.remove(currentPostId)
      Router.go('postsList')
