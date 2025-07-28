function adminHeader() {
  function headerScroll() {
    if ($(window).scrollTop() > 10) {
      $('.admin-header').addClass("min-header");
    } else {
      $('.admin-header').removeClass("min-header");
    }
  }
  $(window).on("scroll", function () {
    headerScroll();
  });

  $(document).on("click", function (e) {
    if (
      !$(e.target).closest("#leftsidebar, #headerMobileMenu").length &&
      $("#leftsidebar").hasClass("active")
    ) {
      $("#leftsidebar").removeClass("active");
      $("#headerMobileMenu").removeClass("active");
    }
  });

  $("#headerMobileMenu").on("click", function (e) {
    e.stopPropagation();
    $("#leftsidebar").toggleClass("active");
    $(this).toggleClass("active");
  });
};

document.addEventListener('DOMContentLoaded', function() {
  adminHeader();
});
