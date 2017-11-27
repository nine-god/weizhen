//= require rails-ujs
//= require turbolinks
//= require application
//= require product
//= require article

$(document).on "turbolinks:load", ->
  if $('#ueditor_container').length >0
    init_ueditor()




