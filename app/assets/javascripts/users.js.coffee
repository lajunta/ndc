# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.ui.form')
.form({
  login: {
   identifier  : 'login',
   rules: [
    {
      type   : 'empty',
      prompt : '请填写你的登录名'
    }
    ]
  },
})
;
