# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(window).scroll ->
  if $(".navbar").offset().top > 50
    $(".navbar-fixed-top").addClass("top-nav-collapse")
  else 
    $(".navbar-fixed-top").removeClass("top-nav-collapse")

#jQuery for page scrolling feature - requires jQuery Easing plugin
$(()->
  $('a.page-scroll').bind('click',(event) ->
    $anchor = $(this)
    $('html, body').stop().animate {
      scrollTop: $($anchor.attr('href')).offset().top}, 1500, 'easeInOutExpo'
    event.preventDefault)
)
$(window).load ->
  # reveal sign up form when user cliks the sign up button
  $('#sign-up-button').click ->
    $('.sign-up').animate {"height": "100%"}, "slow"
    $('#sign-up-button').css "display", 'none'
    $('#sign-in-button').css "display", "none"
    $('.form-signup').animate {"margin-top": "4%", "opacity": "1"}, "slow"
  #hides sign up form when user clicks the form cancel label (that looks like a button)
  $('#cancel-signup-label').click ->
    $('.form-signup').animate {"margin-top": "0%", "opacity": "0"}, "slow"
    $('.sign-up').animate {"height": "0"}, "slow"
    $('#sign-up-button').css "display", 'block'
    $('#sign-in-button').css "display", "block"

  #shows the sign in form when user clicks the sign in button
  $('#sign-in-button').click ->
    $('#welcome-nav-bar').animate {"padding-left": "6.59%"}, 'slow'
    $('#sign-up-button').css "display", 'none'
    $('#sign-in-button').css "display", "none"
    $('.sign-in').css "display", "block"
  $(".intro-header").click ->
    $('.sign-in').css "display", "none"
    $('#welcome-nav-bar').animate {"padding-left": "61.59%"}, 'slow'
    $('#sign-up-button').css "display", 'block'
    $('#sign-in-button').css "display", "block"

