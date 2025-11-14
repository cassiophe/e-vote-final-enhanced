<?php
require_once '../tocca_admin/db_connection.php';

header('Content-Type: application/json');
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

try {
    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['mobile_number']) || !preg_match('/^09\d{9}$/', $data['mobile_number'])) {
        http_response_code(400);
        echo json_encode(['status' => 'error', 'message' => 'Invalid mobile number.']);
        exit;
    }

    $mobile = $data['mobile_number'];

    // Check if voter already exists
    $stmt = $conn->prepare("SELECT voters_id FROM tbl_voters WHERE mobile_number = ?");
    $stmt->bind_param("s", $mobile);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        // Voter already exists
        $stmt->bind_result($voter_id);
        $stmt->fetch();
        echo json_encode([
            'status' => 'success',
            'message' => 'Voter already registered.',
            'voter_id' => $voter_id
        ]);
        exit;
    }
    $stmt->close();

    // Insert new voter
    $insert = $conn->prepare("INSERT INTO tbl_voters (mobile_number, date_verified, has_voted) VALUES (?, NOW(), 0)");
    $insert->bind_param("s", $mobile);
    $insert->execute();
    $voter_id = $insert->insert_id;

    echo json_encode([
        'status' => 'success',
        'message' => 'Voter registered successfully.',
        'voter_id' => $voter_id
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'message' => 'Server error: ' . $e->getMessage()
    ]);
}
