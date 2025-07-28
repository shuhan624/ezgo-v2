var seoChange = function() {
  $('input, textarea').on('input', function() {
    var idChange = $(this).data('meta');
    var metaValChange = $(this).val();
    $("[data-id=" + idChange + "]").html(metaValChange);
  });
}

document.addEventListener('DOMContentLoaded', function() {
  $(".seo-preview-card").each(seoChange);
});
