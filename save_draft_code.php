<?php
require_once 'connection.php';
header('Content-Type: application/json');

$data = json_decode(file_get_contents('php://input'), true);
$mobile = $data['mobile'] ?? '';
$draft_code = $data['draft_code'] ?? '';

if (!$mobile || !preg_match('/^09\d{9}$/', $mobile) || !preg_match('/^\d{4}$/', $draft_code)) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid input.']);
    exit;
}

try {
    $stmt = $conn->prepare("SELECT voters_id FROM tbl_voters WHERE mobile_number = ?");
    $stmt->bind_param("s", $mobile);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        $insert = $conn->prepare("INSERT INTO tbl_voters (mobile_number, draft_code) VALUES (?, ?)");
        $insert->bind_param("ss", $mobile, $draft_code);
        $insert->execute();
        $voter_id = $insert->insert_id;
        $insert->close();
    } else {
        $voter = $result->fetch_assoc();
        $voter_id = $voter['voters_id'];

        $update = $conn->prepare("UPDATE tbl_voters SET draft_code = ? WHERE voters_id = ?");
        $update->bind_param("si", $draft_code, $voter_id);
        $update->execute();
        $update->close();
    }

    echo json_encode(['status' => 'success', 'voter_id' => $voter_id]);
} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => 'Server error: ' . $e->getMessage()]);
}
?>