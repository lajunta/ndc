# -*- encoding : utf-8 -*-
#encoding: utf-8
PDFKit.configure do |config|       
  config.wkhtmltopdf = '/usr/local/Cellar/wkhtmltopdf/0.11.0_rc1/bin/wkhtmltopdf'
  config.default_options = { 
    page_size: 'A4', 
    #print_media_type: true, 
    #toc: true,
    encoding: 'UTF-8',
    #cover: 'http://www.lwqzx.sdedu.net/kpy/dc/jiaoans/ja_cover',
    #footer_html: 'http://www.lwqzx.sdedu.net/kpy/static/dc/ja_footer.html',
    #footer_right: '[page/toPage]',
    #footer_line: true,
    #footer_spacing: 3,
    margin_bottom: '1.5cm',
    #toc_header_text: "Indexes"
  }
end 
