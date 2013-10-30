CKEDITOR.editorConfig = (config) ->
  config.language = 'en'
  config.forcePasteAsPlainText = true
  config.bodyClass = 'contents';
  config.toolbar_Pure = [
      '/',
  { name: 'styles',      items: [ 'Styles','Format','Font','FontSize' ] }

  ];

  config.toolbar = 'Pure'
  #config.skin = 'BootstrapCK-Skin';
  true