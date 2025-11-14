<?php
session_start();
require_once 'connection.php';
header('Content-Type: application/json');

// Accept input from POST
$input = json_decode(file_get_contents('php://input'), true);
$voter_id = $input['voter_id'] ?? null;
$event_id = $input['event_id'] ?? null;

if (!$voter_id || !$event_id) {
    echo json_encode(['status' => 'error', 'message' => 'Missing voter ID or event ID.']);
    exit;
}

// Fetch all questions and categories, LEFT JOINED with draft answers of this user
$query = "
    SELECT
        c.category_id,
        c.category_name,
        q.question_id,
        q.question_name,
        dc.choice_id,
        COALESCE(ch.choice_name, df.freetext) AS selected_answer_text,
        df.freetext AS manual_input
    FROM tbl_questions q
    JOIN tbl_categories c ON q.category_id = c.category_id
    LEFT JOIN tbl_draft_choice dc ON dc.question_id = q.question_id AND dc.voters_id = ?
    LEFT JOIN tbl_choices ch ON dc.choice_id = ch.choice_id
    LEFT JOIN tbl_draft_freetext df ON df.question_id = q.question_id AND df.voters_id = ?
    WHERE c.event_id = ? AND c.status = 1
    ORDER BY c.category_name, q.question_name
";

$stmt = $conn->prepare($query);
$stmt->bind_param("iii", $voter_id, $voter_id, $event_id);
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
        'category_id' => $row['category_id']
    ];
}

$stmt->close();
$conn->close();

echo json_encode(array_values($grouped));
?>