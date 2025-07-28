document.addEventListener('DOMContentLoaded', function() {
  // 會員
  var userArea = $('#user-area');
  if (userArea.length) {
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
  // 訂單
  var recipientArea = $('#recipient-area');
  if (recipientArea.length) {
    new TwCitySelector({
                     el: '#recipient-area',
               elCounty: '#order_receiver_city',
             elDistrict: '#order_receiver_dist',
        countyFieldName: $('#order_receiver_city').attr('name'),
      districtFieldName: $('#order_receiver_dist').attr('name'),
    });
  }
});
