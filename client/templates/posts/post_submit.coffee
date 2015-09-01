Template.postSubmit.events
  "submit form": (event) ->
    event.preventDefault()
    post =
      url: $(event.target).find('[name=url]').val()
      title: $(event.target).find('[name=title]').val()

    Meteor.call('postInsert', post, (error, result) ->
      if error
        alert(error.reason)

      if result.postExists
        alert('This link has already been posted')

      Router.go('postPage', _id: result._id))
