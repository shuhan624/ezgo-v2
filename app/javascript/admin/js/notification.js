import 'bootstrap-notify';

const showNotification = (colorName = 'bg-black', text = 'Hello') => {
  // placementFrom: bottom / top
  // placementAlign: left / center / right
  // colorName: bg-red / bg-green / bg-orange / bg-blue / bg-teal / bg-cyan / bg-pink / bg-purple / bg-blue-grey / bg-deep-orange / bg-light-green / bg-black
  // colorName: alert-danger / alert-success / alert-warning / alert-info
  $.notify({ message: text },
  {
    type: colorName,
    allow_dismiss: true,
    newest_on_top: true,
    timer: 3000,
    placement: { from: 'top', align: 'center' },
    animate: { enter: 'animated fadeInDown', exit: 'animated fadeOutUp' },
    template: `<div data-notify="container" class="flash-custom bootstrap-notify-container alert {0}" role="alert">
               <span data-notify="icon"></span>
               <span data-notify="title">{1}</span>
               <span data-notify="message">{2}</span>
               <div class="progress" data-notify="progressbar">
               <div class="progress-bar progress-bar-{0}" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"></div>
               </div>
               <a href="{3}" target="{4}" data-notify="url"></a>
               </div>`
  });
}

window.notify = {
  success: (message) => showNotification('alert-success', message),
  info: (message) => showNotification('alert-info', message),
  warning: (message) => showNotification('alert-warning', message),
  error: (message) => showNotification('alert-danger', message),
}
