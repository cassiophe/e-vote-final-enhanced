<?php
require_once '../tocca_admin/db_connection.php';
header('Content-Type: application/json');

$data = json_decode(file_get_contents("php://input"), true);
$voterId = $data['voter_id'] ?? '';
$eventId = $data['event_id'] ?? '';
$categoryId = $data['category_id'] ?? null;

if (!$voterId || !$eventId) {
    echo json_encode(['status' => 'error', 'message' => 'Missing voter ID or event ID']);
    exit;
}

$answers = [];

$choiceSql = "SELECT pc.question_id FROM tbl_poll_choice pc ".
    "JOIN tbl_questions q ON pc.question_id = q.question_id ".
    "JOIN tbl_categories c ON q.category_id = c.category_id ".
    "WHERE pc.voters_id = ? AND c.event_id = ? AND c.status = 1";
if ($categoryId) {
    $choiceSql .= " AND c.category_id = ?";
}
$query1 = $conn->prepare($choiceSql);
if ($categoryId) {
    $query1->bind_param("iii", $voterId, $eventId, $categoryId);
} else {
    $query1->bind_param("ii", $voterId, $eventId);
}
$query1->execute();
$result1 = $query1->get_result();
while ($row = $result1->fetch_assoc()) {
    $answers[] = $row;
}
$query1->close();

$freetextSql = "SELECT pf.question_id FROM tbl_poll_freetext pf ".
    "JOIN tbl_questions q ON pf.question_id = q.question_id ".
    "JOIN tbl_categories c ON q.category_id = c.category_id ".
    "WHERE pf.voters_id = ? AND c.event_id = ? AND c.status = 1";
if ($categoryId) {
    $freetextSql .= " AND c.category_id = ?";
}
$query2 = $conn->prepare($freetextSql);
if ($categoryId) {
    $query2->bind_param("iii", $voterId, $eventId, $categoryId);
} else {
    $query2->bind_param("ii", $voterId, $eventId);
}
$query2->execute();
$result2 = $query2->get_result();
while ($row = $result2->fetch_assoc()) {
    $answers[] = $row;
}
$query2->close();

$finalizedIds = array_map(fn($row) => $row['question_id'], $answers);
echo json_encode(['status' => 'success', 'answers' => $finalizedIds]);

?>