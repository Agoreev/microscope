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
    sort: this.sort
    limit: this.postsLimit()
  subscriptions: -> this.postsSub = Meteor.subscribe('posts', this.findOptions())
  posts: -> Posts.find({}, this.findOptions())
  data: ->
    hasMore = this.posts().count() == this.postsLimit()
    return {
      posts: this.posts()
      ready: this.postsSub.ready
      nextPath: if hasMore then this.nextPath() else null
    }

@NewPostsController = PostsListController.extend
  sort: {submitted: -1, _id: -1}
  nextPath: -> Router.routes.newPosts.path(postsLimit: this.postsLimit() + this.increment)

@BestPostsController = PostsListController.extend
  sort: {votes: -1, submitted: -1, _id: -1}
  nextPath: -> Router.routes.bestPosts.path(postsLimit: this.postsLimit() + this.increment)

Router.route '/',
  name: 'home'
  controller: NewPostsController

Router.route '/new/:postsLimit?',
  name: 'newPosts'

Router.route '/best/:postsLimit?',
  name: 'bestPosts'

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
