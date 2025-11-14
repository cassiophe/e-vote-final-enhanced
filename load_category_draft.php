<?php
session_start();
header('Content-Type: application/json');
require_once 'connection.php'; 

$response = ['status' => 'error', 'message' => 'An unknown error occurred.', 'selections' => []];

// Accept voter identifier from session OR POST (anon or verified)
$input_voter_id = $_SESSION['voter_id'] ?? $_GET['voter_id'] ?? $_POST['voter_id'] ?? null;
if (!$input_voter_id) {
    $response['message'] = 'No voter identifier provided.';
    echo json_encode($response);
    exit;
}

$event_id = $_GET['event_id'] ?? $_POST['event_id'] ?? null;
if (!$event_id) {
    $response['message'] = 'Event ID not provided.';
    echo json_encode($response);
    exit;
}

if (!isset($_GET['category_id'])) {
    $response['message'] = 'Category ID not provided.';
    echo json_encode($response);
    exit;
}

$category_id = filter_var($_GET['category_id'], FILTER_VALIDATE_INT);
if ($category_id === false) {
    $response['message'] = 'Invalid Category ID format.';
    echo json_encode($response);
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
    $response['message'] = 'Invalid voter identifier.';
    echo json_encode($response);
    exit;
}

try {
    $stmt = $conn->prepare(
        "SELECT q.question_id, 
         COALESCE(pc.choice_id, dc.choice_id) AS choice_id, 
         COALESCE(ch.choice_name, ch2.choice_name, '') AS choice_text, 
         COALESCE(pf.freetext, df.freetext) AS manual_input
         FROM tbl_questions q
         JOIN tbl_categories c ON q.category_id = c.category_id
         LEFT JOIN tbl_poll_choice pc ON pc.question_id = q.question_id AND pc.voters_id = ?
         LEFT JOIN tbl_choices ch ON pc.choice_id = ch.choice_id
         LEFT JOIN tbl_poll_freetext pf ON pf.question_id = q.question_id AND pf.voters_id = ?
         LEFT JOIN tbl_draft_choice dc ON dc.question_id = q.question_id AND dc.voters_id = ? AND pc.choice_id IS NULL
         LEFT JOIN tbl_choices ch2 ON dc.choice_id = ch2.choice_id
         LEFT JOIN tbl_draft_freetext df ON df.question_id = q.question_id AND df.voters_id = ? AND pf.freetext IS NULL
         WHERE c.event_id = ? AND c.status = 1 AND q.category_id = ?"
    );
    if (!$stmt) {
        throw new Exception('Database prepare statement failed: ' . $conn->error);
    }
    $stmt->bind_param('iiiiii', $voter_id, $voter_id, $voter_id, $voter_id, $event_id, $category_id);
    if (!$stmt->execute()) {
        throw new Exception('Database execute failed: ' . $stmt->error);
    }

    $result = $stmt->get_result();
    $selections = $result->fetch_all(MYSQLI_ASSOC);
    $stmt->close();

    $response['status'] = 'success';
    $response['selections'] = $selections;
    $response['message'] = count($selections) > 0 ? 'Selections loaded successfully.' : 'No selections found for this category.';
} catch (Exception $e) {
    $response['message'] = 'Database error while loading drafts: ' . $e->getMessage();
}

$conn->close();
echo json_encode($response);
?>
