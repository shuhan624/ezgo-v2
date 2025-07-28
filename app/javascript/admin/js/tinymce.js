import tinymce from 'tinymce';
import { templates } from './tinymce_templates.js';

/* Default icons are required. After that, import custom icons if applicable */
import 'tinymce/icons/default/icons.min.js';

/* Required TinyMCE components */
import 'tinymce/themes/silver/theme.min.js';
import 'tinymce/models/dom/model.min.js';

/* Import a skin (can be a custom skin instead of the default) */
import 'tinymce/skins/ui/oxide/skin.js';

/* Import plugins */
import 'tinymce/plugins/anchor';
import 'tinymce/plugins/image';
import 'tinymce/plugins/code';
import 'tinymce/plugins/emoticons';
import 'tinymce/plugins/emoticons/js/emojis';
import 'tinymce/plugins/link';
import 'tinymce/plugins/lists';
import 'tinymce/plugins/table';
import 'tinymce/plugins/template';
import 'tinymce/plugins/media';
import 'tinymce/plugins/searchreplace';

function initTinyMce() {
  $('.tinymce').each(function() {
    var element = this;
    tinymce.init({
      target: element,
      skin_url: '/tinymce/skins/ui/oxide',
      language: 'zh_TW',
      language_url: '/tinymce/lang/zh_TW.js',
      plugins: [
          "anchor", "code", "image", "link", "lists", "media",
          "searchreplace", "table", "template", "emoticons"
      ],
      menubar: 'edit view insert format tools table',
      toolbar: "template undo redo  | styles | bold italic underline strikethrough | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | image media emoticons table link | searchreplace code ",
      height: 600,
      content_css: [
        '/tinymce/skins/content/default/content.min.css', // TinyMCE 預設樣式
        '/tinymce/template.css' // 客製化樣式
      ],
      paste_merge_formats: false,
      templates: templates,
      file_picker_types: 'image',
      setup: function (editor) {
        editor.on('init', function () {
          console.log(`TinyMCE ${$(element).attr('id')} 已初始化`);
        });
      },

      // 客製字體格式
      invalid_elements: 'h1',
      font_size_formats: '8pt 10pt 12pt 14pt 16pt 18pt 24pt 36pt 48pt',
      style_formats: [
        { title: '標題與文字', items: [
          { title: '標題 H2', format: 'h2' },
          { title: '標題 H3', format: 'h3' },
          { title: '標題 H4', format: 'h4' },
          { title: '標題 H5', format: 'h5' },
          { title: '標題 H6', format: 'h6' },
          { title: '段落文字', format: 'p' },
        ]},
        { title: '字體格式', items: [
          { title: '粗體', format: 'bold' },
          { title: '斜體', format: 'italic' },
          { title: '底線', format: 'underline' },
          { title: '刪除線', format: 'strikethrough' },
          { title: '上標', format: 'superscript' },
          { title: '下標', format: 'subscript' },
        ]},
        { title: '對齊', items: [
          { title: '置左', format: 'alignleft' },
          { title: '置中', format: 'aligncenter' },
          { title: '置右', format: 'alignright' },
          { title: '左右對齊', format: 'alignjustify' }
        ]}
      ],

      // 客製化圖片
      file_picker_callback: (cb, value, meta) => {
        const input = document.createElement('input');
        input.setAttribute('type', 'file');
        input.setAttribute('accept', 'image/*');

        input.addEventListener('change', (e) => {
          const file = e.target.files[0];

          const reader = new FileReader();
          reader.addEventListener('load', () => {
            const id = 'blobid' + (new Date()).getTime();
            const blobCache =  tinymce.activeEditor.editorUpload.blobCache;
            const base64 = reader.result.split(',')[1];
            const blobInfo = blobCache.create(id, file, base64);
            blobCache.add(blobInfo);
            cb(blobInfo.blobUri(), { title: file.name });
          });
          reader.readAsDataURL(file);
        });

        input.click();
      },
    });
  });
}

document.addEventListener('DOMContentLoaded', function() {
  initTinyMce();
});
