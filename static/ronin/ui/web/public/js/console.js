$(document).ready(function() {
  var input = $("#console-input > input");

  function inputKeyEvent(e)
  {
    if (e.which == 13)
    {
      var code = $.trim(input.val());

      if (code.length > 0)
      {
        // send code to be evaluated
      }

      input.val('');
    }
  }

  input.keypress(inputKeyEvent);
});
