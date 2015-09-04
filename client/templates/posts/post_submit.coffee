Template.postSubmit.onCreated -> Session.set('postSubmitErrors', {})

Template.postSubmit.helpers
  errorMessage: (field) -> Session.get('postSubmitErrors')[field]
  errorClass: (field) ->
    if Session.get('postSubmitErrors')[field]
      'has-error'
    else
      ''

Template.postSubmit.events
  "submit form": (event) ->
    event.preventDefault()
    post =
      url: $(event.target).find('[name=url]').val()
      title: $(event.target).find('[name=title]').val()

    errors = validatePost(post)
    if errors.title || errors.url
      return Session.set('postSubmitErrors', errors)

    Meteor.call('postInsert', post, (error, result) ->
      if error
        throwError(error.reason)

      if result.postExists
        throwError('This link has already been posted')

      Router.go('postPage', _id: result._id))
