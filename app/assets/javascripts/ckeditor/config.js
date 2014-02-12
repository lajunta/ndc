CKEDITOR.editorConfig = function(config){
  config.language = "zh-cn",
  config.height = "240px",
  config.toolbar = [
    [ 'Bold', 'Italic','Underline','Strike' ],
    ['Format','FontSize'],
    [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ],
    ['TextColor','BGColor'],
    ['Link','Unlink','Anchor'],
    ['JustifyLeft','JustifyCenter','JustifyRight'],
    ['NumberedList','BulletedList','Outdent','Indent'],
    ['Table','Image','Flash','HorizontalRule','SpecialChar','PageBreak'],
    ['Source']
    ];
}
