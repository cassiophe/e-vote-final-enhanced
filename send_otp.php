<?php
session_start();
header('Content-Type: application/json');
require_once 'connection.php';

$rawInput = file_get_contents('php://input');
$data = json_decode($rawInput, true);

if (!is_array($data)) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Invalid JSON payload.'
    ]);
    exit;
}

$mobile = trim($data['mobile_number'] ?? ($data['mobile'] ?? ''));
$mobile = preg_replace('/\D/', '', $mobile);

if (!preg_match('/^09\d{9}$/', $mobile)) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Invalid mobile number format.'
    ]);
    exit;
}

// Check if mobile already exists and whether it has votes
$stmt = $conn->prepare("SELECT voters_id, has_voted FROM tbl_voters WHERE mobile_number = ?");
$stmt->bind_param("s", $mobile);
$stmt->execute();
$stmt->bind_result($voterId, $hasVoted);
if ($stmt->fetch()) {
    $stmt->close();

    if ((int)$hasVoted === 1) {
        echo json_encode([
            'status' => 'blocked',
            'message' => 'This mobile number has already submitted a vote.'
        ]);
        exit;
    }

    // Check for partially completed votes
    $check = $conn->prepare(
        "SELECT 1 FROM tbl_poll_choice WHERE voters_id = ?\n" .
        "UNION\n" .
        "SELECT 1 FROM tbl_poll_freetext WHERE voters_id = ?\n" .
        "LIMIT 1"
    );
    $check->bind_param("ii", $voterId, $voterId);
    $check->execute();
    $check->store_result();
    if ($check->num_rows > 0) {
        echo json_encode([
            'status' => 'incomplete',
            'message' => 'You have an unfinished vote. Please continue as an existing voter.'
        ]);
        $check->close();
        exit;
    }
    $check->close();

    // Mobile exists but has no votes yet
    echo json_encode([
        'status' => 'exists',
        'message' => 'Mobile number already registered. Please continue as an existing voter.'
    ]);
    exit;
}
$stmt->close();
$otp = rand(100000, 999999);
$_SESSION['otp'] = $otp;
$_SESSION['otp_mobile'] = $mobile;
$_SESSION['otp_expiry'] = time() + 300;

$logEntry = date("Y-m-d H:i:s") . " | $mobile => $otp\n";
file_put_contents(__DIR__ . '/otp_log.txt', $logEntry, FILE_APPEND);

echo json_encode([
  'status' => 'sent',
  'debug_otp' => $otp
]);
$conn->close();