<?php
session_start();
require_once 'connection.php';
header('Content-Type: application/json');

// Accept input from POST
$input = json_decode(file_get_contents('php://input'), true);
$input_voter_id = $input['voter_id'] ?? null;
$event_id = $input['event_id'] ?? null;

if (!$input_voter_id || !$event_id) {
    echo json_encode(['status' => 'error', 'message' => 'Missing voter ID or event ID.']);
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
    echo json_encode(['status' => 'error', 'message' => 'Invalid voter_id']);
    exit;
}

// Fetch only active categories and their user selections (preferring finalized over drafts)
$query = "
    SELECT
        c.category_id,
        c.category_name,
        q.question_id,
        q.question_name,
        COALESCE(pc.choice_id, dc.choice_id) AS choice_id,
        COALESCE(ch.choice_name, ch2.choice_name, pf.freetext, df.freetext) AS selected_answer_text,
        COALESCE(pf.freetext, df.freetext) AS manual_input,
        CASE WHEN pc.choice_id IS NOT NULL OR pf.freetext IS NOT NULL THEN 1 ELSE 0 END AS is_finalized
    FROM tbl_questions q
    INNER JOIN tbl_categories c ON q.category_id = c.category_id
    LEFT JOIN tbl_poll_choice pc ON pc.question_id = q.question_id AND pc.voters_id = ?
    LEFT JOIN tbl_choices ch ON pc.choice_id = ch.choice_id
    LEFT JOIN tbl_poll_freetext pf ON pf.question_id = q.question_id AND pf.voters_id = ?
    LEFT JOIN tbl_draft_choice dc ON dc.question_id = q.question_id AND dc.voters_id = ? AND pc.choice_id IS NULL
    LEFT JOIN tbl_choices ch2 ON dc.choice_id = ch2.choice_id
    LEFT JOIN tbl_draft_freetext df ON df.question_id = q.question_id AND df.voters_id = ? AND pf.freetext IS NULL
    WHERE c.status = 1 AND c.event_id = ?
    ORDER BY c.category_name, q.question_name
";

$stmt = $conn->prepare($query);
$stmt->bind_param("iiiii", $voter_id, $voter_id, $voter_id, $voter_id, $event_id);
$stmt->execute();
$result = $stmt->get_result();

$grouped = [];
while ($row = $result->fetch_assoc()) {
    $cat_id = $row['category_id'];

    if (!isset($grouped[$cat_id])) {
        $grouped[$cat_id] = [
            'category_id' => $cat_id,
            'category_name' => $row['category_name'],
            'questions' => []
        ];
    }

    $grouped[$cat_id]['questions'][] = [
        'is_answered' => $row['choice_id'] !== null || (isset($row['manual_input']) && trim($row['manual_input']) !== ''),
        'question_id' => $row['question_id'],
        'question_name' => $row['question_name'],
        'choice_id' => $row['choice_id'],
        'selected_answer_text' => $row['selected_answer_text'],
        'manual_input' => $row['manual_input'],
        'is_finalized' => (int)$row['is_finalized'],
        'category_id' => $row['category_id'],         // ✅ embedded per-question
        'category_name' => $row['category_name']      // ✅ optional
    ];
}

$stmt->close();
$conn->close();

echo json_encode(array_values($grouped));
?>