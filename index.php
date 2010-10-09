<?php

define('SEARCH_DEFAULT', 'Type your search here...');
define('STORY_NAME', 'name');
define('STORY_REF', 'ref');

$stories = array(
  array(STORY_NAME=>'Creation', STORY_REF=>'Genesis 1:1-2:25'),
  array(STORY_NAME=>'The Fall', STORY_REF=>'Genesis 1:1-2:25'),
  array(STORY_NAME=>'The Flood', STORY_REF=>'Psalm 1:1-160:25'),
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
    <input name="searchtext" type="text" size="50" value="" />
  </form>
</div>

<div id="index">
  <table id="index_table" cellpadding="0" cellspacing="0" align="center">
    <colgroup>
      <col width="48%"/><col width="2%"/><col width="48%"/>
      <col width="48%"/><col width="2%"/><col width="48%"/>
    </colgroup>
    <tbody>
      <?php $story_id = 0; ?>
      <?php foreach($stories as $story) : ?>
      <tr id="story<?php echo $story_id; ?>" class="story">
        <td align="right" id="story_name<?php echo $story_id; ?>"><?php echo $story[STORY_NAME]; ?></td>
        <td align="center" nowrap>&nbsp;&nbsp;&nbsp;</td>
        <td id="story_ref<?php echo $story_id; ?>" class="story_ref"><?php echo $story[STORY_REF]; ?></td>
      <?php $story_id++ ?>
      </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
</div>

<div id="footer">
  Thanks to the <a href="http://www.tyndale.com">Tyndale House Publishers</a> for permitting use of the index they provide with their New Living Translations Bibles.
  
  This website was authored by <a href="http://leighmcculloch.com">Leigh McCulloch</a> with the goal to make this useful index accessible to everyone.
  
  Scripture quotations marked &quot;ESV&quot; are taken from The Holy Bible, English Standard Version. Copyright &copy;2001 by <a href="http://www.crosswaybibles.org">Crossway Bibles</a>, a publishing ministry of Good News Publishers. Used by permission. All rights reserved. Text provided by the <a href="http://www.gnpcb.org/esv/share/services/">Crossway Bibles Web Service</a>.
</div>

<script type="text/javascript">
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
    }).focus(function() {
      if (this.value == '<?php echo SEARCH_DEFAULT; ?>') {
        this.value = '';
      }
    }).blur(function() {
      if (this.value == '') {
        this.value = '<?php echo SEARCH_DEFAULT; ?>';
      }
    }).value = '<?php echo SEARCH_DEFAULT; ?>';
    
	});

  function passage_pop_up(name, ref) {
    var margin = $(document).width()/50;
    
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
        $(window).unbind('resize');
        $('input[name=searchtext]').focus();
      }
    });
    
    $(window).bind('resize', function() {
      $('#passage').dialog('option', 'position', $('#passage').dialog('option', 'position'))
      .dialog('option', 'height', $(document).height()-(margin*2))
      .dialog('option', 'width', $(document).width()-(margin*2));
    });
  }
</script>

</BODY>
</HTML>
