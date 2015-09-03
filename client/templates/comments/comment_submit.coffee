Template.commentSubmit.onCreated ->
  Session.set('commentSubmitErrors', {})

Template.commentSubmit.helpers
  errorMessage: (field) -> Session.get('commentSubmitErrors')[field]
  errorClass: (field) ->
    if Session.get('commentSubmitErrors')[field]
      'has-error'
    else
      ''

Template.commentSubmit.events
  "submit form": (event, template) ->
    event.preventDefault()

    $body = $(event.target).find('[name=body]')
    comment =
      body: $body.val()
      postId: template.data._id

    errors = {}
    if !comment.body
      errors.body = "Please write some content"
      return Session.set('commentSubmitErrors', errors)

    Meteor.call('commentInsert', comment, (error, commentId) ->
      if error
        throwError(error.reason)
      else
        $body.val(''))
