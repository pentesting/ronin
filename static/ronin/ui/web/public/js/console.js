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

          $.PeriodicalUpdater('/console/pull', {
            method: 'get',
            minTimeout: 800,
            maxTimeout: 3000,
            multiplier: 2,
            type: 'json',
          }, function(data) {
              alert(data);
          });
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
