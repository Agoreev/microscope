Template.postEdit.onCreated -> Session.set('postEditErrors', {})

Template.postEdit.helpers
  errorMessage: (field) -> Session.get('postEditErrors')[field]
  errorClass: (field) ->
    if Session.get('postEditErrors')[field]
      'has-error'
    else
      ''

Template.postEdit.events
  "submit form": (event) ->
    event.preventDefault()

    currentPostId = this._id
    postProperties =
      url: $(event.target).find('[name=url]').val()
      title: $(event.target).find('[name=title]').val()

    errors = validatePost(postProperties)
    if errors.title || errors.url
      return Session.set('postEditErrors', errors)

    Posts.update(currentPostId, $set: postProperties, (error) ->
      if error
        throwError(error.reason)
      else
        Router.go('postPage', {_id:currentPostId})
      )

  "click .delete": (event) ->
    event.preventDefault()

    if confirm("Delete this post?")
      currentPostId = this._id
      Posts.remove(currentPostId)
      Router.go('postsList')
