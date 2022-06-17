<?php
use AI\Core\Session;

if($success = Session::get('success'))
{
    echo '<div class="alert alert--success font-size-xs">' . $success . '</div>';
    Session::unset('success');
}

if($error = Session::get('error'))
{
    echo '<div class="alert alert--error font-size-xs">' . $error . '</div>';
    Session::unset('error');
}
?>