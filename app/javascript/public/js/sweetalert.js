import 'sweetalert2/dist/sweetalert2.min.css';
import Swal from 'sweetalert2/dist/sweetalert2.min.js';

const Swal_lg = Swal.mixin({
  width: 880,
  showCloseButton: true,
  showConfirmButton: false,
  customClass: {
    container: 'mobile-full',
  },
});

const Swal_hint = Swal.mixin({
  width: 300,
  showCloseButton: true,
  showConfirmButton: false,
  backdrop: 'transparent',
  customClass: {
    popup: 'popup-hint',
    htmlContainer: 'html-hint',
  },
});

window.Swal = Swal;
window.Swal_lg = Swal_lg;
window.Swal_hint = Swal_hint;
