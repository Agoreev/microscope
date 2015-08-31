Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'
  waitOn: -> Meteor.subscribe "posts"

Router.route '/', name: 'postsList'
Router.route '/posts/:_id', name: 'postPage', data: -> Posts.findOne this.params._id
Router.route '/submit', name: 'postSubmit'

Router.onBeforeAction 'dataNotFound', only: 'postPage'
