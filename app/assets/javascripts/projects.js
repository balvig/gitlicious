$(function () {
  $(window).resize(function() { $('#graph').graph()});
  $('#graph').graph();
  $('.pills > li a:first').click();
});
