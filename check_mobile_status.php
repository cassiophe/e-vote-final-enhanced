<?php
include 'connection.php';
header('Content-Type: application/json');

$data = json_decode(file_get_contents('php://input'), true);
$mobile = trim($data['mobile_number'] ?? '');
$mobile = preg_replace('/\D/', '', $mobile);

if ($mobile === '') {
    echo json_encode(['status' => 'error', 'message' => 'Missing mobile number.']);
    exit;
}

$stmt = $conn->prepare("SELECT voters_id, has_voted FROM tbl_voters WHERE mobile_number = ?");
$stmt->bind_param('s', $mobile);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    $voterId = (int)$row['voters_id'];
    $hasVoted = (int)$row['has_voted'];

    $hasData = false;
    $check = $conn->prepare("SELECT 1 FROM tbl_poll_choice WHERE voters_id = ? LIMIT 1");
    $check->bind_param('i', $voterId);
    $check->execute();
    $r = $check->get_result();
    if ($r->num_rows > 0) {
        $hasData = true;
    }
    $check->close();

    if (!$hasData) {
        $check = $conn->prepare("SELECT 1 FROM tbl_poll_freetext WHERE voters_id = ? LIMIT 1");
        $check->bind_param('i', $voterId);
        $check->execute();
        $r = $check->get_result();
        if ($r->num_rows > 0) {
            $hasData = true;
        }
        $check->close();
    }

    echo json_encode([
        'status' => 'exists',
        'has_voted' => $hasVoted,
        'has_data' => $hasData
    ]);
} else {
    echo json_encode(['status' => 'new']);
}
?>