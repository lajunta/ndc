// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require chosen-jquery
//= require chosen
//= require turbolinks
//= require ckeditor/override
//= require ckeditor/init
//= require_tree .

function insert_medias(s){
  //var app_path="/kpy/dc";
  var app_path="/ec";
  if(s==1){
    $(".ui.modal").modal('hide');
    jsonurl=app_path+"/tempmedias/show";
    see_prefix=app_path+"/see/";
    $.getJSON(jsonurl, function(data) {
    var items = [];
    $.each(data, function(index, media) { 
      mediasrc=see_prefix+media.grid_id;
      if(media.content_type.indexOf("image") != -1){
        items.push("\n<p><center><img class='img' src="+mediasrc+"></center></p>\n");
        }
      if(media.content_type.indexOf("flash") != -1){
        items.push("\n<p><center><embed src="+mediasrc+"></embed></center></p>\n");
        }
     });
    CKEDITOR.instances.jiaoan_content.insertHtml(items);
    //disselect file 
    $('form.file_upload').each(function(){ this.reset(); });
    });
  }else{
    alert("文件上传出错");
  }  
}
