// 編輯器模板
// 最後面加上 '<p></p>' 避免使用者離不開有 flex 的 div
export const templates = [
  {
    title: '一列二張圖片',
    description: '兩兩一排，只放圖片，手機版會變單排',
    content: '<div class="ck-template-flex-box ck-flex-pt-sm">' +
              '<div class="ck-col ck-col-50">' +
                '<img src="/images/tmp/default-image.jpg">' +
              '</div>' +
              '<div class="ck-col ck-col-50">' +
                '<img src="/images/tmp/default-image.jpg">' +
              '</div>' +
            '</div>' +
            '<p></p>'
  },
  {
    title: '一列三張圖片',
    description: '三三一排，只放圖片，手機版會變單排',
    content: '<div class="ck-template-flex-box ck-flex-pt-sm">' +
              '<div class="ck-col ck-col-33">' +
                '<img src="/images/tmp/default-image.jpg">' +
              '</div>' +
              '<div class="ck-col ck-col-33">' +
                '<img src="/images/tmp/default-image.jpg">' +
              '</div>' +
              '<div class="ck-col ck-col-33">' +
                '<img src="/images/tmp/default-image.jpg">' +
              '</div>' +
            '</div>' +
            '<p></p>'
  },
  {
    title: '一列二段文字',
    description: '兩兩一排，只放標題及文字，手機版會變單排',
    content: '<div class="ck-template-flex-box ck-flex-pt-sm">' +
              '<div class="ck-col ck-col-50">' +
                '<h3>Lorem Ipsum</h3>' +
                "<p>Lorem ipsum dolor sit amet, mel paulo perpetua salutatus in, ne pro constituto moderatius. Eu melius graecis temporibus vis, sea an modo docendi dissentiunt. Utroque quaestio mei eu, te ius impetus interesset.</p>" +
              '</div>' +
              '<div class="ck-col ck-col-50">' +
                '<h3>Lorem Ipsum</h3>' +
                "<p>Lorem ipsum dolor sit amet, mel paulo perpetua salutatus in, ne pro constituto moderatius. Eu melius graecis temporibus vis, sea an modo docendi dissentiunt. Utroque quaestio mei eu, te ius impetus interesset.</p>" +
              '</div>' +
            '</div>' +
            '<p></p>'
  },
  {
    title: '文50%圖50%',
    description: '圖文排列',
    content: '<div class="ck-template-flex-box ck-flex-pt ck-flex-center">' +
              '<div class="ck-col ck-col-50">' +
                '<h3>Lorem Ipsum</h3>' +
                "<p>Lorem ipsum dolor sit amet, mel paulo perpetua salutatus in, ne pro constituto moderatius. Eu melius graecis temporibus vis, sea an modo docendi dissentiunt. Utroque quaestio mei eu, te ius impetus interesset.</p>" +
              '</div>' +
              '<div class="ck-col ck-col-50">' +
                '<img src="/images/tmp/default-image.jpg">' +
              '</div>' +
            '</div>'+
            '<div class="ck-template-flex-box ck-flex-pt ck-flex-center ck-web-flex-reverse">' +
              '<div class="ck-col ck-col-50">' +
                '<h3>Lorem Ipsum</h3>' +
                "<p>Lorem ipsum dolor sit amet, mel paulo perpetua salutatus in, ne pro constituto moderatius. Eu melius graecis temporibus vis, sea an modo docendi dissentiunt. Utroque quaestio mei eu, te ius impetus interesset.</p>" +
              '</div>' +
              '<div class="ck-col ck-col-50">' +
                '<img src="/images/tmp/default-image.jpg">' +
              '</div>' +
            '</div>' +
            '<p></p>'
  },
  {
    title: '圖40%文60%',
    description: '圖文排列',
    content: '<div class="ck-template-flex-box ck-flex-pt ck-flex-center">' +
              '<div class="ck-col ck-col-40">' +
                '<img src="/images/tmp/default-image.jpg">' +
              '</div>' +
              '<div class="ck-col ck-col-60">' +
                '<h3>Lorem Ipsum</h3>' +
                "<p>Lorem ipsum dolor sit amet, mel paulo perpetua salutatus in, ne pro constituto moderatius. Eu melius graecis temporibus vis, sea an modo docendi dissentiunt. Utroque quaestio mei eu, te ius impetus interesset.</p>" +
              '</div>' +
            '</div>'+
            '<div class="ck-template-flex-box ck-flex-pt ck-flex-center ck-web-flex-reverse">' +
              '<div class="ck-col ck-col-40">' +
                '<img src="/images/tmp/default-image.jpg">' +
              '</div>' +
              '<div class="ck-col ck-col-60">' +
                '<h3>Lorem Ipsum</h3>' +
                "<p>Lorem ipsum dolor sit amet, mel paulo perpetua salutatus in, ne pro constituto moderatius. Eu melius graecis temporibus vis, sea an modo docendi dissentiunt. Utroque quaestio mei eu, te ius impetus interesset.</p>" +
              '</div>' +
            '</div>' +
            '<p></p>'
  },
  {
    title: '一列二個圖文組合',
    description: '兩兩一排',
    content: '<div class="ck-template-flex-box ck-flex-pt">' +
              '<div class="ck-col ck-col-50">' +
                '<img src="/images/tmp/default-image.jpg">' +
                '<h3>Lorem Ipsum</h3>' +
                "<p>Lorem ipsum dolor sit amet, mel paulo perpetua salutatus in, ne pro constituto moderatius. Eu melius graecis temporibus vis, sea an modo docendi dissentiunt. Utroque quaestio mei eu, te ius impetus interesset.</p>" +
              '</div>' +
              '<div class="ck-col ck-col-50">' +
                '<img src="/images/tmp/default-image.jpg">' +
                '<h3>Lorem Ipsum</h3>' +
                "<p>Lorem ipsum dolor sit amet, mel paulo perpetua salutatus in, ne pro constituto moderatius. Eu melius graecis temporibus vis, sea an modo docendi dissentiunt. Utroque quaestio mei eu, te ius impetus interesset.</p>" +
              '</div>' +
            '</div>' +
            '<p></p>'
  },
  {
    title: '一列三個圖文組合',
    description: '三三一排，手機版會變單排',
    content: '<div class="ck-template-flex-box ck-flex-pt-sm">' +
              '<div class="ck-col ck-col-33">' +
                '<img src="/images/tmp/default-image.jpg">' +
                '<h3>Lorem Ipsum</h3>' +
                "<p>Lorem ipsum dolor sit amet, mel paulo perpetua salutatus in, ne pro constituto moderatius. Eu melius graecis temporibus vis, sea an modo docendi dissentiunt. Utroque quaestio mei eu, te ius impetus interesset.</p>" +
              '</div>' +
              '<div class="ck-col ck-col-33">' +
                '<img src="/images/tmp/default-image.jpg">' +
                '<h3>Lorem Ipsum</h3>' +
                "<p>Lorem ipsum dolor sit amet, mel paulo perpetua salutatus in, ne pro constituto moderatius. Eu melius graecis temporibus vis, sea an modo docendi dissentiunt. Utroque quaestio mei eu, te ius impetus interesset.</p>" +
              '</div>' +
              '<div class="ck-col ck-col-33">' +
                '<img src="/images/tmp/default-image.jpg">' +
                '<h3>Lorem Ipsum</h3>' +
                "<p>Lorem ipsum dolor sit amet, mel paulo perpetua salutatus in, ne pro constituto moderatius. Eu melius graecis temporibus vis, sea an modo docendi dissentiunt. Utroque quaestio mei eu, te ius impetus interesset.</p>" +
              '</div>' +
            '</div>' +
            '<p></p>'
  },
  {
    title: '勾選清單',
    description: '',
    content: '<ul class="checklist">' +
              '<li>Lorem ipsum dolor sit amet</li>' +
              '<li>Lorem ipsum dolor sit amet, mel paulo</li>' +
              '<li>Lorem Ipsum</li>' +
            '</ul>' +
            '<p></p>'
  },
  {
    title: '一列二段勾選清單',
    description: '兩兩一排，只放勾選清單，手機版會變單排',
    content: '<div class="ck-template-flex-box ck-flex-pt-sm">' +
              '<div class="ck-col ck-col-50">' +
                '<ul class="checklist">' +
                  '<li>Lorem ipsum dolor sit amet</li>' +
                  '<li>Lorem ipsum dolor sit amet, mel paulo</li>' +
                  '<li>Lorem Ipsum</li>' +
                '</ul>' +
              '</div>' +
              '<div class="ck-col ck-col-50">' +
                '<ul class="checklist">' +
                  '<li>Lorem ipsum dolor sit amet</li>' +
                  '<li>Lorem ipsum dolor sit amet, mel paulo</li>' +
                  '<li>Lorem Ipsum</li>' +
                '</ul>' +
              '</div>' +
            '</div>' +
            '<p></p>'
  },
]
