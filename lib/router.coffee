Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'
  waitOn: -> Meteor.subscribe 'posts'

Router.route '/', name: 'postsList'

Router.route '/posts/:_id',
  name: 'postPage'
  waitOn: -> Meteor.subscribe('comments', this.params._id)
  data: -> Posts.findOne(this.params._id)

Router.route '/posts/:_id/edit',
  name: 'postEdit'
  data: -> Posts.findOne(this.params._id)
  
Router.route '/submit', name: 'postSubmit'

requireLogin = ->
  if !Meteor.user()
    if Meteor.loggingIn()
      this.render(this.loadingTemplate)
    else
      this.render 'accessDenied'
  else
    this.next()

Router.onBeforeAction 'dataNotFound', only: 'postPage'
Router.onBeforeAction requireLogin, only: 'postSubmit'
