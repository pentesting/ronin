$(document).ready(function() {
  var input = $("#console-input > input");

  function inputKeyEvent(e)
  {
    if (e.which == 13)
    {
      var code = $.trim(input.val());

      if (code.length > 0)
      {
        $.post('/console/push', {'code': code}, function(data) {
          input.val('');
        });
      }
      else
      {
        input.val('');
      }
    }
  }

  input.keypress(inputKeyEvent);
  input.focus();
});
