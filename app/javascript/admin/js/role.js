function autoCheckPermission() {
  // 當勾選 show 的時候，自動勾選 index
  $('input[id$="_show"]').on('change', function() {
    if ($(this).is(':checked')) {
        // 找到同一個 permissions 區塊內的 index (列表) checkbox 並勾選
        $(this).closest('.permisssions')
               .find('input[id$="_index"]')
               .prop('checked', true);
    }
  });

  // 當勾選 new, create, edit, update, destroy 的時候，自動勾選 show 與 index
  const permissionTypes = ['new', 'create', 'edit', 'update', 'destroy'];
  const selector = permissionTypes.map(type => `input[id$="_${type}"]`).join(', ');

  $(selector).on('change', function() {
    if ($(this).is(':checked')) {
      // 找到同一個 permissions 區塊內的 show 與 index checkbox 並勾選
      $(this).closest('.permisssions')
             .find('input[id$="_show"], input[id$="_index"]')
             .prop('checked', true);
    }
  });
}


document.addEventListener('DOMContentLoaded', function() {
autoCheckPermission();
});
