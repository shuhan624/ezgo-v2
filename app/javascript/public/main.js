import Swiper from 'swiper';
import { Navigation, Pagination, Autoplay, EffectFade , Thumbs } from 'swiper/modules';
import 'swiper/css/bundle';

Swiper.use([Navigation, Pagination, Autoplay, EffectFade, Thumbs]);
window.Swiper = Swiper;

// JavaScript
$(document).ready( function () {
  //scroll top
  // $('.back-to-top').click(function(event){
  //   $("html,body").animate({scrollTop: 0}, 1000);
  // });

  // transparent header
  function headerScroll() {
    if ($(window).scrollTop() > 100) {
      $('.header').addClass("min-header");
    } else {
      $('.header').removeClass("min-header");
    }
  }
  headerScroll();
  $(window).on('scroll', function () {
    headerScroll();
  });

  $('.header-mobile-menu').on('click', function () {
    $(this).toggleClass('active');
    $('.header-menu-outer').toggleClass('active');
  });

  $('.menu-link').click(function(e) {
      $(this).parent().toggleClass('active').siblings().removeClass('active');
  });

  var indexBanner = new Swiper('#indexBanner', {
    effect: 'fade',
    autoplay: {
      delay: 5000,
    },
    loop: true,
    peed: 1000,
    pagination: {
      el: ".swiper-pagination",
      clickable: true
    },
  });

  // dropdown
  $('.dropdown-btn').on('click', function () {
    const id = $(this).attr('id');
    const dropdown_is_active = $('[aria-labelledby=' + id + ']').hasClass("is-active");
    if (dropdown_is_active >= 1) {
      $('[aria-labelledby=' + id + ']').removeClass('is-active');
      if (window.innerWidth <= 640) {
        $('body').css({
          'height': '',
          'overflow': '',
        })
      }
    } else {
      $(".dropdown-list:not([aria-labelledby=" + id + "]").removeClass('is-active');
      $('[aria-labelledby=' + id + ']').addClass('is-active');
      if (window.innerWidth <= 640) {
        $('body').css({
          'height': '100vh',
          'overflow': 'hidden',
        })
      }
    }
  });

  $(document).click(function (event) {
    if (!$(event.target).closest('.dropdown-btn').length) {
      if ($('.dropdown-list').is(":visible")) {
        $(".dropdown-list").removeClass('is-active');
        if (window.innerWidth <= 640) {
          $('body').css({
            'height': '',
            'overflow': '',
          })
        }
      }
    }
  });
});

//Header
document.addEventListener("DOMContentLoaded", () => {
  const toggleBtn = document.querySelector(".menu-toggle-btn");
  const closeBtn = document.querySelector(".menu-close");
  const overlay = document.querySelector(".menu-overlay");

  toggleBtn?.addEventListener("click", () => overlay.classList.add("open"));
  closeBtn?.addEventListener("click", () => overlay.classList.remove("open"));
});

document.addEventListener("DOMContentLoaded", function () {
  const header = document.querySelector(".header");

  window.addEventListener("scroll", () => {
    if (window.scrollY > 10) {
      header.classList.add("scrolled");
    } else {
      header.classList.remove("scrolled");
    }
  });
});

//Back to Top
document.addEventListener("DOMContentLoaded", function () {
  const backToTopBtn = document.getElementById("backToTopBtn");

  backToTopBtn.addEventListener("click", function () {
    window.scrollTo({
      top: 0,
      behavior: "smooth"
    });
  });
});

//tab
document.querySelectorAll('.tab-item').forEach(tab => {
  tab.addEventListener('click', () => {
    // 切換 tab 標籤
    document.querySelectorAll('.tab-item').forEach(item => item.classList.remove('active'));
    tab.classList.add('active');

    // 顯示對應內容
    const target = tab.dataset.tab;
    document.querySelectorAll('.tab-panel').forEach(panel => {
      panel.classList.remove('active');
    });
    document.getElementById(target).classList.add('active');
  });
});

//country
document.addEventListener("DOMContentLoaded", function () {
  const tabs = document.querySelectorAll(".hero-tabs li");

  tabs.forEach(tab => {
    tab.addEventListener("click", function () {
      // 切換 active 樣式
      tabs.forEach(t => t.classList.remove("active"));
      this.classList.add("active");

      // 捲動至對應 section
      const targetSelector = this.getAttribute("data-tab-target");
      const targetSection = document.querySelector(targetSelector);
      if (targetSection) {
        window.scrollTo({
          top: targetSection.offsetTop - 100, // 調整 offset
          behavior: "smooth"
        });
      }
    });
  });
});

const swiper = new Swiper('.mySwiper', {
  loop: true,
  spaceBetween: 24,
  slidesPerView: 3,
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },
  breakpoints: {
    0: {
      slidesPerView: 1.2, // 手機時顯示
    },
    768: {
      slidesPerView: 2,
    },
    1024: {
      slidesPerView: 3, // 桌面三張
    },
  },
});

document.querySelectorAll('.news-tabs .tab').forEach(tab => {
  tab.addEventListener('click', () => {
    const target = tab.dataset.tab;

    // 切換 tab 樣式
    document.querySelectorAll('.news-tabs .tab').forEach(t => t.classList.remove('active'));
    tab.classList.add('active');

    // 切換內容區
    document.querySelectorAll('.tab-content-news').forEach(c => {
      c.classList.toggle('active', c.dataset.tab === target);
    });
  });
});
