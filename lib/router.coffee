Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'
  waitOn: -> Meteor.subscribe 'notifications'

@PostsListController = RouteController.extend
  template: 'postsList'
  increment: 5
  postsLimit: -> parseInt(this.params.postsLimit) || this.increment
  findOptions: ->
    sort: {submitted: -1}
    limit: this.postsLimit()
  subscriptions: -> this.postsSub = Meteor.subscribe('posts', this.findOptions())
  posts: -> Posts.find({}, this.findOptions())
  data: ->
    hasMore = this.posts().count() == this.postsLimit()
    nextPath = this.route.path(postsLimit: this.postsLimit() + this.increment)
    return {
      posts: this.posts()
      ready: this.postsSub.ready
      nextPath: if hasMore then nextPath else null
    }

Router.route '/posts/:_id',
  name: 'postPage'
  waitOn: -> [
    Meteor.subscribe('singlePost', this.params._id)
    Meteor.subscribe('comments', this.params._id)
  ]
  data: -> Posts.findOne(this.params._id)

Router.route '/posts/:_id/edit',
  name: 'postEdit'
  waitOn: -> Meteor.subscribe('singlePost', this.params._id)
  data: -> Posts.findOne(this.params._id)

Router.route '/submit', name: 'postSubmit'

Router.route '/:postsLimit?',
  name: 'postsList'

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
