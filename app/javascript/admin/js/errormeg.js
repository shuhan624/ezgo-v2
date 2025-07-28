// 畫面不重整情況下，調整瀏覽器預設的錯誤訊息提示
var createAllErrors = function() {
  var form = $(this);

  var showAllErrorMessages = function() {
    var invalidFields = form.find( ":invalid" ).each( function( index, node ) {
      var label = $( "label[for=' + node.id + '] "),
        message = node.validationMessage || 'Invalid value.';
        form.prepend( '<ul class="errorMessages"><li><span>' + label.html() + "</span> " + message + "</li></ul>" );
    });
  };

  // Support Safari
  form.on( "submit", function( event ) {
    if ( this.checkValidity && !this.checkValidity() ) {
      $( this ).find( ":invalid" ).first().focus();
      event.preventDefault();
    }
  });

  $("input[type=submit]", form).on("click", function(){
    showAllErrorMessages();

    let $errorMessages = $("ul.errorMessages");
    if ($errorMessages.length > 0) {
      $("html,body").animate({scrollTop: $errorMessages.offset().top});
    }
  });
};

document.addEventListener('DOMContentLoaded', function() {
  $("form").each(createAllErrors);
});
