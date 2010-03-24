$(document).ready(function() {
  var input = $("#console-input > input");
  var output = $("#console-output");

  function outputExpression(code)
  {
    var code_div = $('<div class="code" />').text(code);

    $('<div class="expression" />').append(
      '<div class="prompt">&gt;&gt;</div>'
    ).append(code_div).appendTo(output);
  }

  function outputResult(code)
  {
    var code_div = $('<div class="code" />').text(code.value);

    $('<div class="result" />').append(
      '<div class="prompt">=&gt;</div>'
    ).append(code_div).appendTo(output);

    output.attr('scrollTop', output.attr('scrollHeight'));
  }

  function inputKeyEvent(e)
  {
    if (e.which == 13)
    {
      var code = $.trim(input.val());

      if (code.length > 0)
      {
        $.post('/console/push', {'code': code}, function(data) {
          input.val('');

          outputExpression(code);

          $.PeriodicalUpdater('/console/pull', {
            method: 'get',
            minTimeout: 1000,
            maxTimeout: 10000,
            multiplier: 2
            }, function(data) {
               if (data == null || data.length == 0) {
                 $.stop();
               }
               else
               {
                 outputResult(data);
               }
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
