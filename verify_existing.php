<?php
include '../tocca_admin/db_connection.php';
header('Content-Type: application/json');

$data = json_decode(file_get_contents("php://input"), true);
$mobile = $data['mobile_number'] ?? '';
$draftCode = $data['draft_code'] ?? '';

$response = ['status' => 'error', 'message' => 'Invalid credentials'];

if (!empty($mobile) && !empty($draftCode)) {
    $stmt = $conn->prepare("SELECT * FROM tbl_voters WHERE mobile_number = ? AND draft_code = ?");
    $stmt->bind_param("ss", $mobile, $draftCode);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $voter = $result->fetch_assoc();
        $voter_id = $voter['voters_id'];
        $has_voted = $voter['has_voted'];

        // Early exit if already voted
        if ($has_voted == 1) {
            echo json_encode([
                'status' => 'success',
                'voter_info' => $voter,
                'unanswered_questions' => [],
                'completion_status' => 'completed'
            ]);
            exit;
        }

        // Fetch all questions from active categories
        $questions = $conn->query(
            "SELECT q.question_id, q.category_id
             FROM tbl_questions q
             JOIN tbl_categories c ON q.category_id = c.category_id
             WHERE c.status = 1"
        );
        $allQuestions = [];
        while ($q = $questions->fetch_assoc()) {
            $allQuestions[$q['question_id']] = $q['category_id'];
        }

        // Get answered question_ids
        $answered = [];

        $res1 = $conn->query(
            "SELECT pc.question_id
             FROM tbl_poll_choice pc
             JOIN tbl_questions q ON pc.question_id = q.question_id
             JOIN tbl_categories c ON q.category_id = c.category_id
             WHERE pc.voters_id = $voter_id AND c.status = 1"
        );
        while ($row = $res1->fetch_assoc()) {
            $answered[] = $row['question_id'];
        }

        $res2 = $conn->query(
            "SELECT pf.question_id
             FROM tbl_poll_freetext pf
             JOIN tbl_questions q ON pf.question_id = q.question_id
             JOIN tbl_categories c ON q.category_id = c.category_id
             WHERE pf.voters_id = $voter_id AND c.status = 1"
        );
        while ($row = $res2->fetch_assoc()) {
            $answered[] = $row['question_id'];
        }

        $answered = array_unique($answered);

        // Compute unanswered
        $unanswered = [];
        foreach ($allQuestions as $qid => $catid) {
            if (!in_array($qid, $answered)) {
                $unanswered[] = [
                    'question_id' => $qid,
                    'category_id' => $catid
                ];
            }
        }

        $response = [
            'status' => 'success',
            'voter_info' => $voter,
            'unanswered_questions' => $unanswered,
            'completion_status' => empty($unanswered) ? 'completed' : 'incomplete'
        ];
    }
}

echo json_encode($response);
