<?php

require_once('functions.php');

$input = array(
	'ref'=>FILTER_SANITIZE_STRING
);

$input=filter_var_array($_REQUEST, $input);
$ref=$input['ref'];

echo get_passage($ref);

?>
