<?php
include '../tocca_admin/db_connection.php';
header('Content-Type: application/json');

$data = json_decode(file_get_contents("php://input"), true);
$mobile = $data['mobile_number'] ?? '';

if (!preg_match('/^09\d{9}$/', $mobile)) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid mobile number.']);
    exit;
}

$stmt = $conn->prepare("SELECT draft_code FROM tbl_voters WHERE mobile_number = ?");
$stmt->bind_param("s", $mobile);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $voter = $result->fetch_assoc();
    if (!empty($voter['draft_code'])) {
        echo json_encode(['status' => 'has_draft']);
    } else {
        echo json_encode(['status' => 'no_draft']);
    }
} else {
    echo json_encode(['status' => 'no_draft']);
}
?>
