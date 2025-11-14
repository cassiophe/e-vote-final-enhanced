<?php
include '../tocca_admin/db_connection.php';
function getConfig($key, $default = '') {
    global $conn;
    $stmt = $conn->prepare("SELECT config_value FROM tbl_config WHERE config_key = ?");
    $stmt->bind_param("s", $key);
    $stmt->execute();
    $stmt->bind_result($val);
    if ($stmt->fetch()) return $val;
    return $default;
}

header("Content-Type: application/json");

echo json_encode([
    'bgColor' => getConfig('voter_bg_color', '#ffffff'),
    'textColor' => getConfig('voter_text_color', '#000000'),
    'fontSize' => getConfig('voter_font_size', '16px'),
    'headerLogo' => getConfig('voter_header_logo', 'img/tocca2023.jpg'),
    'primaryColor' => getConfig('voterPrimaryColor', '#007bff'),
    'buttonColor' => getConfig('voterButtonColor', '#007bff')
]);
