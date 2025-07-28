import '../src/jquery'
import Cookies from 'js-cookie';
import ahoy from "ahoy.js"
import Rails from "@rails/ujs"
import '../public/main'



Rails.start();

window.Cookies = Cookies;

// Example: Load Rails libraries in Vite.
//
// import * as Turbo from '@hotwired/turbo'
// Turbo.start()
//
// import ActiveStorage from '@rails/activestorage'
// ActiveStorage.start()
//
// // Import all channels.
// const channels = import.meta.globEager('./**/*_channel.js')

// Example: Import a stylesheet in app/frontend/index.css
// import '~/index.css'
