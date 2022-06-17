<?php
echo '<div class="table-wrapper">';
echo '<table class="table">';

echo '<tr>';
echo '<th>Użytkownik</th>';
echo '<th>E-mail</th>';
echo '<th>Liczba wiadomości</th>';
echo '<th>Data ostatniej wiadomości</th>';
echo '</tr>';

foreach($props['data'] as $d)
{
    echo '<tr>';
    echo '<td>' . $d['user_name'] . '</td>';
    echo '<td>' . $d['user_email'] . '</td>';
    echo '<td>' . $d['message_count'] . '</td>';
    echo '<td>' . $d['last_send_at'] . '</td>';
    echo '</tr>';
}

echo '</table>';
echo '</div>';
?>