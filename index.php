<?php

require_once('functions.php');

$stories = get_index(INDEX_FILE_DEFAULT);

?>
<HTML>
<HEAD>
  <TITLE><?php echo TITLE_DEFAULT; ?></TITLE>
  <link href="style.css" rel="stylesheet" type="text/css">
  <link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/>
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
  <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>
</HEAD>
<BODY>

<div id="passage"></div>

<div id="header">
  <h1>Stories of the Bible</h1>
  <h2>An index of great stories in the Bible.</h2>
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
        <td align="right" id="story_name<?php echo $story_id; ?>"><a href="/<?php echo $story[STORY_SHORT_NAME]; ?>"><?php echo $story[STORY_NAME]; ?></a></td>
        <td align="center" nowrap>&nbsp;&nbsp;&nbsp;</td>
        <td id="story_ref<?php echo $story_id; ?>" class="story_ref"><a href="/<?php echo $story[STORY_SHORT_NAME]; ?>"><?php echo $story[STORY_REF]; ?></a></td>
      <?php $story_id++ ?>
      </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
</div>

<div id="footer">
  Thanks to the <a href="http://www.tyndale.com">Tyndale House Publishers</a> for permitting use of the index they provide with their New Living Translations Bibles.
  
  This website was authored by <a href="http://leighmcculloch.com">Leigh McCulloch</a> with the goal to make this useful index accessible to everyone.
  
  Scripture taken from The Holy Bible, English Standard Version. Copyright &copy;2001 by <a href="http://www.crosswaybibles.org">Crossway Bibles</a>, a publishing ministry of Good News Publishers. Used by permission. All rights reserved. Text provided by the <a href="http://www.gnpcb.org/esv/share/services/">Crossway Bibles Web Service</a>.
</div>

<script type="text/javascript">
  $(document).ready(function() {
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
</script>

</BODY>
</HTML>
