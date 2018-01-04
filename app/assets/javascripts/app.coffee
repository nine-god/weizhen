//= require rails-ujs
//= require turbolinks
//= require application
//= require home
//= require product
//= require article

$(document).on "turbolinks:load", ->
  if $("script.ueditor_container_script").length >0
    init_ueditor()
  init_nav()




