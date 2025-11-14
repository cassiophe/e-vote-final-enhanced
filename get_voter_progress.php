<?php
include 'connection.php';
header('Content-Type: application/json');

$mobile = $_GET['mobile'] ?? '';
$eventId = $_GET['event_id'] ?? '';

if (!$mobile || !$eventId) {
    echo json_encode(['status' => 'error', 'message' => 'Missing parameters']);
    exit;
}

$mobile = preg_replace('/\D/', '', $mobile);

// Lookup voter ID
$stmt = $conn->prepare("SELECT voters_id FROM tbl_voters WHERE mobile_number = ?");
$stmt->bind_param('s', $mobile);
$stmt->execute();
$result = $stmt->get_result();
if (!($row = $result->fetch_assoc())) {
    echo json_encode(['status' => 'error', 'message' => 'Voter not found']);
    exit;
}
$voterId = (int)$row['voters_id'];
$stmt->close();

// Total questions for event
$total = 0;
$stmt = $conn->prepare("SELECT COUNT(*) AS total FROM tbl_questions q INNER JOIN tbl_categories c ON q.category_id = c.category_id WHERE c.event_id = ? AND c.is_archived = 0");
$stmt->bind_param('i', $eventId);
$stmt->execute();
$res = $stmt->get_result();
if ($row = $res->fetch_assoc()) {
    $total = (int)$row['total'];
}
$stmt->close();

// Answered questions from choice table
$answered = 0;
$stmt = $conn->prepare("SELECT COUNT(*) AS cnt FROM tbl_poll_choice WHERE voters_id = ? AND event_id = ?");
$stmt->bind_param('ii', $voterId, $eventId);
$stmt->execute();
$res = $stmt->get_result();
if ($row = $res->fetch_assoc()) {
    $answered += (int)$row['cnt'];
}
$stmt->close();

// Answered questions from freetext table
$stmt = $conn->prepare("SELECT COUNT(*) AS cnt FROM tbl_poll_freetext WHERE voters_id = ? AND event_id = ?");
$stmt->bind_param('ii', $voterId, $eventId);
$stmt->execute();
$res = $stmt->get_result();
if ($row = $res->fetch_assoc()) {
    $answered += (int)$row['cnt'];
}
$stmt->close();

$unanswered = max($total - $answered, 0);
$percent = $total ? round(($answered / $total) * 100) : 0;

echo json_encode([
    'answered' => $answered,
    'unanswered' => $unanswered,
    'percent' => $percent
]);
?>