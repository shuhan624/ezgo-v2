function adminSideBar() {
  // 後台 leftsidebar
  $(".sidebar-collapse").on('click', function(){
    if (window.innerWidth > 992) {
      $(this).toggleClass('active-collapse');
      $('#leftsidebar, #adminHeader').toggleClass('active-collapse');
    } else {
      $(this).removeClass('active-collapse');
      $('#leftsidebar, #adminHeader').removeClass('active-collapse');
    }
  });

  // 後台 index mobile table
  $("[data-mobile]").on('click', function(){
    const targetId = $(this).data('mobile');
    const $targetRow = $(`#${targetId}`);
    if ($targetRow.length) {
      $targetRow.toggleClass('is-expanded');
    }
  });
  $(".nav-item").on('click', function(){
    if (window.innerWidth > 992) {
      $(this).toggleClass('open');
    }
    else {
      $(this).removeClass('active-collapse');
      $('#leftsidebar, #adminHeader').removeClass('active-collapse');
    }
  });

};

document.addEventListener('DOMContentLoaded', function() {
  adminSideBar();
});
