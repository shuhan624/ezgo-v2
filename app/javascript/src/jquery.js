// 不要將 jQuery 移進去主要的 entrypoints/admin.js
// 因為他不會照順序執行，但放在 import 裡面會先跑完，
// 這樣才會有 window.$ & window.jQuery 可以給後面的 code 用
import $ from 'jquery';
window.$ = window.jQuery = $;
