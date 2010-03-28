$(document).ready(function() {
  var input = $("#console-input > input");
  var output = $("#console-output");
  var current_line = 0;

  function outputExpression(code)
  {
    var line_number = $('<span class="line-number" />').text(current_line);

    line_number.hide();

    var line_div = $('<div id="console-line-' + current_line + '" />');
    var code_div = $('<div class="code" />').text(code);
    var expression_div = $('<div class="expression" />').append(
      '<div class="prompt">&gt;&gt;</div>'
    ).append(code_div).append(line_number);

    expression_div.hover(
      function() { $("span.line-number",this).show(); },
      function() { $("span.line-number",this).hide(); }
    );

    line_div.append(expression_div).appendTo(output);
  }

  function outputResult(code)
  {
    var line_div = $('#console-line-' + code.line, output);
    var code_div = $('<div class="code" />');

    if (code.type == 'object')
    {
      $('<a target="new" />').attr({
        href: '/docs/' + code.class_name
      }).text(code.value).appendTo(code_div);
    }
    else if (code.type == 'exception')
    {
      var backtrace_link = $('<a class="backtrace-link" />').text(code.value);

      backtrace_link.click(function() {
        $(this).next().toggle();
      });
      
      backtrace_link.appendTo(code_div);

      var backtrace_div = $('<div class="backtrace" />');
      var i;

      for (i=0;i<code.backtrace.length;i++)
      {
        $('<p>').text(code.backtrace[i]).appendTo(backtrace_div);
      }

      backtrace_div.appendTo(code_div);
    }

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
        $.post('/console/push', {'code': code}, function(pending_line) {
          current_line = pending_line;
          input.val('');

          outputExpression(code);

          $.PeriodicalUpdater('/console/pull', {
            method: 'get',
            minTimeout: 1000,
            maxTimeout: 10000,
            multiplier: 2
            }, function(result) {
               if (result != null)
               {
                 outputResult(result);

                 if (result.line == pending_line)
                 {
                   $.stop();
                 }
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
