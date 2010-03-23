$(document).ready(function() {
  $("#sub-apps-menu > div.bottom").click(function() {
    $("#sub-apps-menu > ul").slideToggle("fast");
  });

  $("#sub-apps-menu > ul").click(function() {
    $(this).slideUp("fast");
  });

  $("p.flash-notice, p.flash-error").click(function() {
    $(this).slideUp();
  });
});
