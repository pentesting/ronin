$(document).ready(function() {
  $("#sub-apps-menu > div.bottom").click(function() {
    $("#sub-apps-menu > ul").slideToggle("fast");
  });

  $("#sub-apps-menu > ul").click(function() {
    $(this).slideUp("fast");
  });

  $("p.flash").click(function() { $(this).slideUp(); });
});
