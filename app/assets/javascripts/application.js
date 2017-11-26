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
  
  try
  {
  var ue = UE.getEditor('ueditor_container')
  ue.setShow()
  ue.render('ueditor_container');
  }
catch(err)
  {
  	// var ue = UE.getEditor('ueditor_container')
  	console.log(err)
  	// console.log(111)
  //在这里处理错误
  }

  console.log(333)
    // ue.render('ueditor_container');
  // ue = UE.getEditor('ueditor_container')
  // console.log(ue)
  // if(ue){
    // var ue = UE.getEditor('ueditor_container').render('ueditor_container');
  // }
  // console.log(222)
};
