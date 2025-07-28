import '../src/jquery';
import '@popperjs/core';
import * as bootstrap from 'bootstrap';
import '@nathanvda/cocoon';
import 'dropify/dist/js/dropify';
import 'daterangepicker';
import introJs from 'intro.js';
import c3 from 'c3';
import * as ActiveStorage from "@rails/activestorage";
import Rails from '@rails/ujs';
import Sortable from 'sortablejs';
import moment from 'moment';
import TwCitySelector from 'tw-city-selector';
import TomSelect from 'tom-select'
import SortableTree from 'sortable-tree';
import '../admin/js/tinymce';
import '../admin/js/flatpickr';
import '../admin/js/errormeg';
import '../admin/js/seoChange';
import '../admin/js/notification';
import '../admin/js/role';
import '../admin/js/header';
import '../admin/js/leftsidebar';
// 以下評估
import SyncSelect from '../public/js/sync-select';

window.c3 = c3;
window.introJs = introJs;
window.SyncSelect = SyncSelect;
window.TomSelect = TomSelect;
window.SortableTree = SortableTree;

Rails.start();
ActiveStorage.start();

function initItems() {
  $('.tom-select-custom').each(function() {
    const url = '/tags';
    const placeholder = $(this).data('placeholder') || '請設定標籤';

    new TomSelect(this, {
      create: true,
      persist: true,
      preload: true,
      placeholder: placeholder,
      labelField: 'text',
      valueField: 'id',
      searchField: ['text'],
      plugins: ['remove_button'],
      load: function(query, callback) {
        if (!query.length) return callback();
        $.ajax({
          url: url,
          dataType: 'json',
          data: {
            keyword: query,
            page: 1
          },
          success: function(data) {
            const results = data.items.map(({ name }) => ({ id: name, text: name }));
            callback(results);
          },
          error: function() {
            callback();
          }
        });
      }
    });
  });

  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })

  $(".form-control-label.file").click(function(e) {
    e.preventDefault();
  });

  var drEvent = $('.dropify').dropify({
    messages: {
      default: '拖拉檔案到這裡，或點擊本區塊後選擇檔案上傳',
      replace: '拖拉新檔案或再次點擊，可替換其他檔案',
      remove: '移除',
      error: '出錯了，請重新整理頁面'
    },
    error: {
      'fileSize': '檔案太大超過 {{ value }}',
      'imageFormat': '僅支援格式為 ({{ value }} 的檔案).',
      'fileExtension': '僅支援格式為 ({{ value }} 的檔案).'
    }
  });

  drEvent.on('dropify.afterClear', function(event, element){
    var attr_name = element.input.attr('name').substring(
      element.input.attr('name').lastIndexOf("[") + 1,
      element.input.attr('name').lastIndexOf("]")
    );
    $('<input>').attr({
      type: 'hidden',
      id: 'destroy_' + attr_name,
      name: 'destroy_' + attr_name,
      value: 'true'
    }).appendTo('form');
  });

  $('#figures, .dropify-init').each(function(){
    $(this).on('cocoon:after-insert', function() {
      var drBizEvent = $('.dropify').dropify({
        messages: {
          default: '拖拉檔案到這裡，或點擊本區塊後選擇檔案上傳',
          replace: '拖拉新檔案或再次點擊，可替換其他檔案',
          remove: '移除',
          error: '出錯了，請重新整理頁面'
        },
        error: {
          'fileSize': '檔案太大超過 {{ value }}',
          'imageFormat': '僅支援格式為 ({{ value }} 的檔案).',
          'fileExtension': '僅支援格式為 ({{ value }} 的檔案).'
        }
      });

      drBizEvent.on('dropify.afterClear', function(event, element){
        var attr_name = element.input.attr('name').substring(
          element.input.attr('name').lastIndexOf("[") + 1,
          element.input.attr('name').lastIndexOf("]")
        );
        $('<input>').attr({
          type: 'hidden',
          id: 'destroy_' + attr_name,
          name: 'destroy_' + attr_name
        }).appendTo('form');
      });
    });
  });

  let sortTables = $('.sortable-items');
  if (sortTables.length) {
    sortTables.each(function() {
      let url = this.dataset.sortPath
      Sortable.create(this, {
        handle: '.handle' ,
        animation: 150,
        onEnd: event => {
          let id = event.item.dataset.item.split('_').pop()
          let data = new FormData();
          data.append("id", id);
          data.append("form", event.oldIndex);
          data.append("to", event.newIndex);
          console.log(`id: ${id}, form: ${event.oldIndex}, to: ${event.newIndex}`)
          Rails.ajax({
            url: url,
            type: 'PATCH',
            data: data,
            success: resp => {
              console.log(resp);
            },
            error: err => {
              console.log(err);
            }
          })
        }
      })
    })
  }

  if ($('#date-range').length) {
    $('#date-range').daterangepicker({
      "maxDate": moment().format('YYYY-MM-DD'),
      "locale": {
        "format": "YYYY-MM-DD",
        "separator": " ~ ",
        "applyLabel": "套用",
        "cancelLabel": "取消",
        "fromLabel": "From",
        "toLabel": "To",
        "customRangeLabel": "Custom",
        "weekLabel": "W",
        "daysOfWeek": [
            "日",
            "一",
            "二",
            "三",
            "四",
            "五",
            "六"
        ],
        "monthNames": [
          "1月",
          "2月",
          "3月",
          "4月",
          "5月",
          "6月",
          "7月",
          "8月",
          "9月",
          "10月",
          "11月",
          "12月"
        ],
        "firstDay": 0
      }
    });
  }

  $('#date-range').on('apply.daterangepicker', function(ev, picker) {
    $('.page-loader-wrapper').fadeIn('fast');
    document.getElementById("date-form").submit();
  });
  $("#date-form").on("change", "input:checkbox", function(){
    $('.page-loader-wrapper').fadeIn('fast');
    document.getElementById("date-form").submit();
  });

  // tabs
  $(function(){
    var $tab = $('.tabs-group .tabs-btn a.tab');
    $tab.on('click', function(event){
        event.preventDefault();
        $($(this).attr('href')).addClass('active').siblings().removeClass('active');
        $(this).addClass('active').siblings().removeClass('active');
    });
  });

  var categories = $('.product_categories');
  var packages = $('#produtct-packages');

  if ($("#product_is_bundle_false").is(":checked")) {
    $(categories).show().siblings(packages).hide();
  }else if ($("#product_is_bundle_true").is(":checked")) {
    $(packages).show().siblings(categories).hide();
  }
  $('.product_is_bundle input[type="radio"]').change(function(){
    if ($(this).attr("value") == "true") {
        $(packages).show().siblings(categories).hide();
    }
    if ($(this).attr("value") == "false") {
        $(categories).show().siblings(packages).hide();
    }
  });

  // tw-city-selector
  // 會員
  if ($('#user-area').length) {
    new TwCitySelector({
                     el: '#user-area',
               elCounty: '#user_city',
             elDistrict: '#user_dist',
              elZipcode: '#user_zip_code',
        countyFieldName: $('#user_city').attr('name'),
      districtFieldName: $('#user_dist').attr('name'),
       zipcodeFieldName: $('#user_zip_code').attr('name'),
    });
  }

  // 檔案管理
  function document_type(){
    var type = $("input[name='document[file_type]']:checked").val();
    if ( type == 'file' ) {
      $(".document-file").fadeIn();
      $(".document-link").hide();
    } else {
      $(".document-file").hide();
      $(".document-link").fadeIn();
    }
  }
  document_type();
  $("input[name='document[file_type]']").change(function(){
    document_type();
  })

  // 最新消息
  function article_type(){
    var type = $("input[name='article[post_type]']:checked").val();
    if ( type == 'post' ) {
      $(".text.article_content").fadeIn();
      $(".text.article_content_en").fadeIn();
      $(".string.article_source_link_zh_tw").hide();
      $(".string.article_source_link_en").hide();
    } else {
      $(".string.article_source_link_zh_tw").fadeIn();
      $(".string.article_source_link_en").fadeIn();
      $(".text.article_content").hide();
      $(".text.article_content_en").hide();
    }
  }
  article_type();
  $("input[name='article[post_type]']").change(function(){
    article_type();
  })

  // 自訂頁面
  function custom_page_type(){
    let type = $("input[name='custom_page[custom_type]']:checked").val() || $("input[name='custom_page[custom_type]'][type='hidden']").val();
    if ( type == 'info' ) {
      $(".text.custom_page_content").fadeIn();
      $(".text.custom_page_content_en").fadeIn();
    } else {
      $(".text.custom_page_content").hide();
      $(".text.custom_page_content_en").hide();
    }
  }
  custom_page_type();
  $("input[name='custom_page[custom_type]']").change(function(){
    custom_page_type();
  })

  $('.setting-collapse').click(function(){
    $(this).toggleClass('turn').siblings('.table-responsive').slideToggle();
  })
};

document.addEventListener('DOMContentLoaded', function() {
  initItems();
});

