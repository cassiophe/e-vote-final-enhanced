<?php
session_start();
header('Content-Type: application/json');
require_once 'connection.php';

$raw = file_get_contents("php://input");
file_put_contents("debug_save_draft.txt", "\n[RAW INPUT] " . $raw . "\n", FILE_APPEND);
$data = json_decode($raw, true);

if (json_last_error() !== JSON_ERROR_NONE) {
    echo json_encode(["status" => "error", "message" => "Invalid JSON."]);
    exit;
}

if (!$data || !isset($data['category_id'], $data['category_name'], $data['selections'])) {
    file_put_contents("debug_save_draft.txt", "[Validation Failed] Data: " . print_r($data, true) . "\n", FILE_APPEND);
    echo json_encode(['status' => 'error', 'message' => 'Incomplete draft data.']);
    exit;
}

$input_voter_id = $data['voter_id'] ?? $_SESSION['voter_id'] ?? null;
if (!$input_voter_id) {
    echo json_encode(['status' => 'error', 'message' => 'No voter ID found.']);
    exit;
}

// Function to resolve voter_id
function resolve_voter_id($conn, $input_voter_id) {
    if (preg_match('/^\d{11}$/', $input_voter_id)) {
        $stmt = $conn->prepare("SELECT voters_id FROM tbl_voters WHERE mobile_number = ?");
        $stmt->bind_param("s", $input_voter_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $voter = $result->fetch_assoc();
        $stmt->close();
        return $voter ? $voter['voters_id'] : null;
    } elseif (is_numeric($input_voter_id)) {
        return intval($input_voter_id);
    } else {
        $stmt = $conn->prepare("SELECT voters_id FROM tbl_voters WHERE mobile_number = ?");
        $stmt->bind_param("s", $input_voter_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $voter = $result->fetch_assoc();
        $stmt->close();
        return $voter ? $voter['voters_id'] : null;
    }
}

$voter_id = resolve_voter_id($conn, $input_voter_id);
if (!$voter_id) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid voter ID.']);
    exit;
}

$selections = $data['selections'];

try {
    $conn->begin_transaction();

    foreach ($selections as $item) {
        $question_id = intval($item['question_id']);
        $choice_id = isset($item['choice_id']) && $item['choice_id'] !== "" ? intval($item['choice_id']) : null;
        $freetext = isset($item['freetext']) ? trim($item['freetext']) : '';

        // Remove any existing draft entries for this voter/question
        $stmt = $conn->prepare("DELETE FROM tbl_draft_choice WHERE voters_id = ? AND question_id = ?");
        $stmt->bind_param("ii", $voter_id, $question_id);
        $stmt->execute();
        $stmt->close();

        $stmt = $conn->prepare("DELETE FROM tbl_draft_freetext WHERE voters_id = ? AND question_id = ?");
        $stmt->bind_param("ii", $voter_id, $question_id);
        $stmt->execute();
        $stmt->close();

        if ($choice_id !== null) {
            $stmt = $conn->prepare("INSERT INTO tbl_draft_choice (voters_id, question_id, choice_id) VALUES (?, ?, ?)");
            $stmt->bind_param("iii", $voter_id, $question_id, $choice_id);
            $stmt->execute();
            $stmt->close();
        }

        if (!empty($freetext)) {
            $stmt = $conn->prepare("INSERT INTO tbl_draft_freetext (voters_id, question_id, freetext) VALUES (?, ?, ?)");
            $stmt->bind_param("iis", $voter_id, $question_id, $freetext);
            $stmt->execute();
            $stmt->close();
        }
    }

    $conn->commit();
    echo json_encode(['status' => 'success', 'message' => 'Draft saved successfully.']);
 } catch (Exception $e) {
    $conn->rollback();
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
 }
?>
