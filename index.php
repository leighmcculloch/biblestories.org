<?php

define('STORY_NAME', 'name');
define('STORY_REF', 'ref');

$stories = array(
  array(STORY_NAME=>'Creation', STORY_REF=>'Genesis 1:1-2:25'),
  array(STORY_NAME=>'The Fall', STORY_REF=>'Genesis 1:1-2:25'),
  array(STORY_NAME=>'The Flood', STORY_REF=>'Genesis 1:1-2:25'),
  array(STORY_NAME=>'Leaving Egypt', STORY_REF=>'Exodus xx:yy'),
);

?>
<HTML>
<HEAD>
  <TITLE>Stories in the Bible</TITLE>
  <link href="style.css" rel="stylesheet" type="text/css">
  <link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/>
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
  <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>
</HEAD>
<BODY>

<div id="passage"></div>

<div id="header">
  <h1>Stories in the Bible</h1>
  <h2>An index of all the stories in the Old<br/>and New Testaments of the Christian Bible.</h2>
</div>

<div id="search">
  <form id="searchform" onsubmit="return false;">
    <input name="searchtext" type="text" size="50" value="Type your search here..." />
  </form>
</div>

<div id="index">
  <table id="index_table" width="100%" cellpadding="0" cellspacing="0">
    <colgroup>
      <col width="48%"/><col width="2%"/><col width="48%"/>
    </colgroup>
    <tbody>
      <?php $count = 0; ?>
      <?php foreach($stories as $story) : ?>
      <tr id="story<?php echo $count; ?>" class="story">
        <td align="right" id="story_name<?php echo $count; ?>"><?php echo $story[STORY_NAME]; ?></td>
        <td align="center">...</td>
        <td id="story_ref<?php echo $count; ?>" class="story_ref"><?php echo $story[STORY_REF]; ?></td>
      </tr>
      <?php $count++ ?>
      <?php endforeach; ?>
    </tbody>
  </table>
</div>

<div id="footer">
  Thanks to the <a href="http://www.tyndale.com">Tyndale House Publishers</a> for permitting use of the index they<br/>
  provide with their New Living Translations Bibles. This website was<br/>
  authored by <a href="http://leighmcculloch.com">Leigh McCulloch</a> with the goal to make this<br/>
  useful index accessible to everyone.
</div>

<script type="text/javascript">
  var default_values = new Array();

	$(document).ready(function() {
		$('.story').hover(function() {
			$(this).css('cursor','pointer');
		});
		$('.story').click(function () {
		  var id = $(this).attr('id').replace('story','');
		  var ref = $('#story_ref'+id).html();
		  var name = $('#story_name'+id).html() + ' - ' + ref;
		  passage_pop_up(name, ref);
		});
		
		$.expr[":"].containsNoCase = function(el, i, m) {
      var search = m[3];
      if (!search) return true;
      return eval("/" + search + "/i").test($(el).text());
    };
		
		$('input[name=searchtext]').focus().keyup(function() {
      if (event.keyCode == 27) {
        $(this).val('');
      }
      $('#index_table tr:not(:containsNoCase("' + $(this).val() + '"))').hide();
      $('#index_table tr:containsNoCase("' + $(this).val() + '")').show();
    });
    
    $('input[name=searchtext]').focus(function() {
      if (!default_values[this.id]) {
        default_values[this.id] = this.value;
      }
      if (this.value == default_values[this.id]) {
        this.value = '';
      }
      $(this).blur(function() {
        if (this.value == '') {
          this.value = default_values[this.id];
        }
      });
    });
	});

  function passage_pop_up(name, ref) {
    var margin = $(document).width()/10;
    
    if($('#passage')) {
      $('#passage').remove();
    }
    
    $('body').append('<div id="passage"></div>');
    
    $('#passage').dialog({
      title: name,
      modal: true,
      autoOpen: true,
      position: 'center',
      height: $(document).height()-(margin*2),
      width: $(document).width()-(margin*2),
      closeOnEscape: true,
      hide: 'fade',
      show: 'fade',
      open: function() {
        $(this).html('Loading...');
        $(this).load('ref.php?ref='+encodeURI(ref));
      },
      close: function() {
        $(this).html('Loading...');
      }
    });
  }
</script>

</BODY>
</HTML>
