import flatpickr from 'flatpickr';
import FlatpickrLanguages from 'flatpickr/dist/l10n';

function initFlatpickr() {
  flatpickr('.datetimepicker', {
    enableTime: true,
    dateFormat: 'Y-m-d H:i',
    allowInput: true,
    locale: { ...FlatpickrLanguages.zh_tw },
    onOpen(selectedDates, _dateStr, flatpickrInstance) {
      if (selectedDates.length === 0) {
        flatpickrInstance.setDate(new Date());
      }
    },
  });

  flatpickr('.datepicker', {
    dateFormat: 'Y-m-d',
    allowInput: true,
    locale: { ...FlatpickrLanguages.zh_tw },
    format: 'LT',
  });
}

document.addEventListener('DOMContentLoaded', function() {
  initFlatpickr();
});
