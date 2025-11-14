<?php
header('Content-Type: application/json');
require_once '../tocca_admin/db_connection.php';

if (!isset($_GET['category_id']) || !is_numeric($_GET['category_id'])) {
    echo json_encode(['status' => 'error', 'message' => 'Missing or invalid category_id']);
    exit;
}

$category_id = (int)$_GET['category_id'];

try {
    // Query questions and their choices in one go
    $stmt = $conn->prepare("
        SELECT q.question_id, q.question_name, q.category_id, q.choice_type,
               c.choice_id, c.choice_name
        FROM tbl_questions q
        LEFT JOIN tbl_question_choices qc ON q.question_id = qc.question_id
        LEFT JOIN tbl_choices c ON qc.choice_id = c.choice_id AND c.status = 1
        WHERE q.category_id = ?
        ORDER BY q.question_id ASC, c.choice_name ASC
    ");
    $stmt->bind_param("i", $category_id);
    $stmt->execute();
    $result = $stmt->get_result();

    $questions = [];
    while ($row = $result->fetch_assoc()) {
        $qid = (int)$row['question_id'];
        if (!isset($questions[$qid])) {
            $questions[$qid] = [
                'question_id' => $qid,
                'question_name' => $row['question_name'],
                'category_id' => (int)$row['category_id'],
                'choice_type' => (int)$row['choice_type'],
                'choices' => []
            ];
        }
        if ($row['choice_id'] !== null) {
            $questions[$qid]['choices'][] = [
                'choice_id' => (int)$row['choice_id'],
                'choice_name' => $row['choice_name']
            ];
        }
    }

    // Re-index questions array
    $questions = array_values($questions);

    echo json_encode(['status' => 'success', 'questions' => $questions]);
} catch (Exception $e) {
    error_log('Error in load_questions_with_choices.php: ' . $e->getMessage());
    echo json_encode(['status' => 'error', 'message' => 'Server error']);
}
exit;
?>
