// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
function init_ueditor(){
  // console.log("111")
  // console.log($("script.ueditor_container_script"))
  var ueditor_container_script = $("script.ueditor_container_script")
  // console.log(ueditor_container_script[0].id)
  try
  {
  var ue = UE.getEditor(ueditor_container_script[0].id)
  ue.setShow()
  ue.render(ueditor_container_script[0].id);
  }
catch(err)
  {
  	// var ue = UE.getEditor('ueditor_container')
  	// console.log(err)
  	// console.log(111)
  //在这里处理错误
  }
  // console.log(UE.getEditor('ueditor_container').getOpt('serverUrl'))
};
