// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require sisyphus
//= require select2
//= require fuelux
//= require plugins
//= require jquery-easing-1.3.js
//= require_tree .

function popupCenter(url, width, height, name) {
  var left = (screen.width/2)-(width/2);
  var top = (screen.height/2)-(height/2);
  return window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top);
}

$(function() {
  $("a.popup").on('click', function(e) {
    popupCenter($(this).attr("href"), $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");
    e.stopPropagation(); return false;
  });
})

jQuery(document).ready(function($) {

  /* ########## */
  /*  CAROUSEL  */
  /* ########## */

  // Setting variables
  $home_carousel = $('#myCarousel');

  // Setting up homepage carousel
  $home_carousel.carousel({
    interval: false 
  })

  // animate first caption on website load
  $home_carousel.find('.active .caption p').animate({opacity: 1}, 600);
  // animate captions on slide (turn on/off)
  $home_carousel.bind('slid', function() {
    $(this).find('.active .caption p').animate({opacity: 1}, 600);
  }).bind('slide', function() {
    $(this).find('.active .caption p').animate({opacity: 0}, 300);
  });

});
