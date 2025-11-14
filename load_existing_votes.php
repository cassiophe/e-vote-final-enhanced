<?php
header('Content-Type: application/json');
include 'connection.php';

$input_voter_id = isset($_REQUEST['voter_id']) ? $_REQUEST['voter_id'] : null;
$event_id = isset($_REQUEST['event_id']) ? intval($_REQUEST['event_id']) : null;
$category_id = isset($_REQUEST['category_id']) ? intval($_REQUEST['category_id']) : null;

if (!$input_voter_id || !$event_id) {
  echo json_encode(['status' => 'error', 'message' => 'Missing voter_id or event_id']);
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

// This array will hold both finalized and draft answers keyed by question_id
$answers = [];

// Helper to run a choice query and merge into $answers without overwriting
// existing finalized answers.
function load_choice_answers($conn, $sql, $types, ...$params) {
  global $answers;
  $stmt = $conn->prepare($sql);
  $stmt->bind_param($types, ...$params);
  $stmt->execute();
  $result = $stmt->get_result();
  while ($row = $result->fetch_assoc()) {
    if (!isset($answers[$row['question_id']])) {
      $answers[$row['question_id']] = [
        'question_id' => $row['question_id'],
        'choice_id' => $row['choice_id'],
        'choice_text' => $row['choice_text'],
        'manual_input' => ''
      ];
    }
  }
}

// Helper to run a freetext query and merge into $answers without overwriting
// existing finalized answers.
function load_freetext_answers($conn, $sql, $types, ...$params) {
  global $answers;
  $stmt = $conn->prepare($sql);
  $stmt->bind_param($types, ...$params);
  $stmt->execute();
  $result = $stmt->get_result();
  while ($row = $result->fetch_assoc()) {
    if (isset($answers[$row['question_id']])) {
      $answers[$row['question_id']]['manual_input'] = $row['manual_input'];
    } else {
      $answers[$row['question_id']] = [
        'question_id' => $row['question_id'],
        'choice_id' => null,
        'choice_text' => '',
        'manual_input' => $row['manual_input']
      ];
    }
  }
}

// 1. Load finalized choice answers
$baseChoiceSql = "
  SELECT pc.question_id, pc.choice_id, ch.choice_name AS choice_text
  FROM tbl_poll_choice pc
  JOIN tbl_choices ch ON pc.choice_id = ch.choice_id
  JOIN tbl_questions q ON pc.question_id = q.question_id
  JOIN tbl_categories c ON q.category_id = c.category_id
  WHERE pc.voters_id = ? AND c.event_id = ? AND c.status = 1";
if ($category_id) {
  $baseChoiceSql .= " AND c.category_id = ?";
}
load_choice_answers(
  $conn,
  $baseChoiceSql,
  $category_id ? "iii" : "ii",
  $voter_id,
  $event_id,
  ...($category_id ? [$category_id] : [])
);

// 2. Load finalized freetext answers
$baseFreetextSql = "
  SELECT pf.question_id, pf.freetext AS manual_input
  FROM tbl_poll_freetext pf
  JOIN tbl_questions q ON pf.question_id = q.question_id
  JOIN tbl_categories c ON q.category_id = c.category_id
  WHERE pf.voters_id = ? AND c.event_id = ? AND c.status = 1";
if ($category_id) {
  $baseFreetextSql .= " AND c.category_id = ?";
}
load_freetext_answers(
  $conn,
  $baseFreetextSql,
  $category_id ? "iii" : "ii",
  $voter_id,
  $event_id,
  ...($category_id ? [$category_id] : [])
);

// 3. Load draft choice answers (only if not already finalized)
$draftChoiceSql = "
  SELECT dc.question_id, dc.choice_id, ch.choice_name AS choice_text
  FROM tbl_draft_choice dc
  JOIN tbl_choices ch ON dc.choice_id = ch.choice_id
  JOIN tbl_questions q ON dc.question_id = q.question_id
  JOIN tbl_categories c ON q.category_id = c.category_id
  WHERE dc.voters_id = ? AND c.event_id = ? AND c.status = 1";
if ($category_id) {
  $draftChoiceSql .= " AND c.category_id = ?";
}
load_choice_answers(
  $conn,
  $draftChoiceSql,
  $category_id ? "iii" : "ii",
  $voter_id,
  $event_id,
  ...($category_id ? [$category_id] : [])
);

// 4. Load draft freetext answers (only if not already finalized)
$draftFreetextSql = "
  SELECT df.question_id, df.freetext AS manual_input
  FROM tbl_draft_freetext df
  JOIN tbl_questions q ON df.question_id = q.question_id
  JOIN tbl_categories c ON q.category_id = c.category_id
  WHERE df.voters_id = ? AND c.event_id = ? AND c.status = 1";
if ($category_id) {
  $draftFreetextSql .= " AND c.category_id = ?";
}
load_freetext_answers(
  $conn,
  $draftFreetextSql,
  $category_id ? "iii" : "ii",
  $voter_id,
  $event_id,
  ...($category_id ? [$category_id] : [])
);

echo json_encode([
  'status' => 'success',
  'answers' => array_values($answers)
]);
?>
