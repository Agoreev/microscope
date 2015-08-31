Template.postSubmit.events
  "submit form": (event) ->
    event.preventDefault()
    post =
      url: $(event.target).find('[name=url]').val()
      title: $(event.target).find('[name=title]').val()

    post._id = Posts.insert(post);
    Router.go('postPage', post);
