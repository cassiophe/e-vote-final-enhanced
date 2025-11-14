<?php
ini_set('display_errors', 1);  // TEMP: Enable for debugging
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
ob_start();

include 'connection.php';
session_start();
header('Content-Type: application/json');

$data = json_decode(file_get_contents('php://input'), true);

// Validate JSON decode success
if (is_null($data)) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid JSON input.']);
    exit;
}

$otpInput = $data['otp'] ?? '';
$mobile = $data['mobile_number'] ?? ($data['mobile'] ?? '');

error_log("OTP VERIFY REQUEST: Mobile=$mobile, OTP=$otpInput");

// Validate input
if (!$otpInput || !$mobile) {
    echo json_encode(['status' => 'error', 'message' => 'Missing OTP or mobile number.']);
    exit;
}

// Validate session
if (!isset($_SESSION['otp'], $_SESSION['otp_mobile'], $_SESSION['otp_expiry'])) {
    file_put_contents("otp_debug.log", "Session not found for $mobile\n", FILE_APPEND);
    echo json_encode(['status' => 'error', 'message' => 'No OTP session found.']);
    exit;
}

// Check OTP expiration
if (time() > $_SESSION['otp_expiry']) {
    echo json_encode(['status' => 'expired', 'message' => 'OTP expired.']);
    exit;
}

// Check OTP match
if ((string)$_SESSION['otp'] !== (string)$otpInput || $_SESSION['otp_mobile'] !== $mobile) {
    echo json_encode(['status' => 'invalid', 'message' => 'OTP did not match.']);
    exit;
}

$_SESSION['verified_mobile'] = $mobile;

// Check if mobile already exists in tbl_voters
$query = $conn->prepare("SELECT voters_id, has_voted FROM tbl_voters WHERE mobile_number = ?");
$query->bind_param("s", $mobile);
$query->execute();
$query->bind_result($voterId, $hasVoted);
$exists = $query->fetch();
$query->close();

if (!$exists) {
    $insert = $conn->prepare("INSERT INTO tbl_voters (mobile_number) VALUES (?)");
    $insert->bind_param("s", $mobile);
    $insert->execute();
    $voterId = $insert->insert_id;
    $hasVoted = 0;
    $insert->close();
}

if ($hasVoted === 1 || $hasVoted === '1') {
    echo json_encode(['status' => 'blocked', 'message' => 'This mobile number has already submitted a vote.']);
    $conn->close();
    exit;
}

// Save session and respond
$_SESSION['voter_id'] = $voterId;
file_put_contents("otp_debug.log", json_encode($data) . "\n", FILE_APPEND);

ob_end_clean();
echo json_encode([
    'status' => 'verified',
    'voter_id' => $voterId
]);
$conn->close();
exit;

