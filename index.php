<?php

require_once('functions.php');

$stories = get_index(INDEX_FILE_DEFAULT);

?>
<HTML>
<HEAD>
  <TITLE><?php echo TITLE_DEFAULT; ?></TITLE>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
  <link href="style.css" rel="stylesheet" type="text/css">
  <link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/>
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
  <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>
</HEAD>
<BODY>

<div id="passage"></div>

<div id="header">
  <h1><?php echo TITLE_DEFAULT; ?></h1>
  <h2><?php echo SLOGAN_DEFAULT; ?></h2>
</div>

<div id="search">
  <form id="searchform" onsubmit="return false;">
    <input name="searchtext" type="text" size="35" value="" />
  </form>
</div>

<div id="index">
  <span class="searchnoresults">There are no stories matching your search.</span>
  <table id="index_table" cellpadding="0" cellspacing="0" align="center">
    <colgroup>
      <col width="48%"/><col width="2%"/><col width="48%"/>
      <col width="48%"/><col width="2%"/><col width="48%"/>
    </colgroup>
    <tbody>
      <?php $story_id = 0; ?>
      <?php foreach($stories as $story) : ?>
      <tr id="story<?php echo $story_id; ?>" class="story">
        <td align="right" id="story_ref<?php echo $story_id; ?>" class="story_ref"><span class="index_text"><?php echo $story[STORY_REF]; ?></span></td>
        <td align="center" nowrap>&nbsp;</td>
        <td align="left" id="story_name<?php echo $story_id; ?>"><span class="index_text"><a href="/<?php echo $story[STORY_SHORT_NAME]; ?>"><?php echo $story[STORY_NAME]; ?></a></span></td>
      <?php $story_id++ ?>
      </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
</div>

<div id="footer">
  <?php include 'copyright.php'; ?>
</div>

<script type="text/javascript">
  $(document).ready(function() {
    $('.searchnoresults').hide();
    
    $.expr[":"].containsNoCase = function(el, i, m) {
      var search = m[3];
      if (!search) return true;
      return eval("/" + search + "/i").test($(el).text());
    };
    
    $('input[name=searchtext]').focus().keyup(function() {
      /* ESC Key */
      if (event.keyCode == 27) {
        $(this).val('');
      }
      /* Enter Key */
      if (event.keyCode == 13) {
        $(this).blur();
      }
      
      var rows_disabled = $('#index_table tr:not(:containsNoCase("' + $(this).val() + '"))');
      var rows_enabled = $('#index_table tr:containsNoCase("' + $(this).val() + '")');
      
      rows_disabled.hide();
      rows_enabled.show();
      
      if(rows_enabled.length==0) {
        $('.searchnoresults').show();
      }
      else {
        $('.searchnoresults').hide();
      }
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
