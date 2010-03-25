$(document).ready(function() {
  var input = $("#console-input > input");
  var output = $("#console-output");
  var line = 0;

  function outputExpression(code)
  {
    var line_div = $('<div id="console-line-' + line + '" />');
    var code_div = $('<div class="code" />').text(code);
    var expression_div = $('<div class="expression" />').append(
      '<div class="prompt">&gt;&gt;</div>'
    ).append(code_div);

    line_div.append(expression_div).appendTo(output);
  }

  function outputResult(code)
  {
    var line_div = $('#console-line-' + code.line, output);

    var code_div = $('<div class="code" />').text(code.value);
    var result_div = $('<div class="result" />').append(
      '<div class="prompt">=&gt;</div>'
    ).append(code_div);
      
    line_div.append(result_div);

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
          line = data;
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
        }, 'json');
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
