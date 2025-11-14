<?php
include 'connection.php';
header('Content-Type: application/json');
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

$data = json_decode(file_get_contents("php://input"), true);
file_put_contents("debug_submit_vote.log", print_r($data, true));

if (!$data || !isset($data['voters_id'])) {
    echo json_encode(['status' => 'error', 'message' => 'Missing or invalid data.']);
    exit;
}

$voters_id = $data['voters_id'];
$answers = $data['answers'] ?? [];
$finalized = $data['finalized_votes'] ?? [];
$draft_code = $data['draft_code'] ?? null;

try {
    $conn->begin_transaction();
    if (preg_match('/^\d{11}$/', $voters_id)) {
        // Numeric but looks like a mobile number
        $stmt = $conn->prepare("SELECT voters_id, has_voted FROM tbl_voters WHERE mobile_number = ?");
        $stmt->bind_param("s", $voters_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $voter = $result->fetch_assoc();
        $stmt->close();

        if (!$voter) {
            $insert = $conn->prepare("INSERT INTO tbl_voters (mobile_number) VALUES (?)");
            $insert->bind_param("s", $voters_id);
            $insert->execute();
            $voters_id = $insert->insert_id;
            $insert->close();
        } else {
            if ($voter['has_voted'] == 1) {
                echo json_encode(['status' => 'error', 'message' => 'You have already submitted your vote.']);
                exit;
            }
            $voters_id = $voter['voters_id'];
        }
    } elseif (is_numeric($voters_id)) {
        // Looks like an existing voter ID
        $stmt = $conn->prepare("SELECT voters_id, has_voted FROM tbl_voters WHERE voters_id = ?");
        $stmt->bind_param("i", $voters_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $voter = $result->fetch_assoc();
        $stmt->close();

        if (!$voter) {
            echo json_encode(['status' => 'error', 'message' => 'Invalid voter identifier.']);
            exit;
        }

        if ($voter['has_voted'] == 1) {
            echo json_encode(['status' => 'error', 'message' => 'You have already submitted your vote.']);
            exit;
        }
        $voters_id = $voter['voters_id'];
    } else {
        // Treat anything else as a mobile number
        $stmt = $conn->prepare("SELECT voters_id, has_voted FROM tbl_voters WHERE mobile_number = ?");
        $stmt->bind_param("s", $voters_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $voter = $result->fetch_assoc();
        $stmt->close();

        if (!$voter) {
            $insert = $conn->prepare("INSERT INTO tbl_voters (mobile_number) VALUES (?)");
            $insert->bind_param("s", $voters_id);
            $insert->execute();
            $voters_id = $insert->insert_id;
            $insert->close();
        } else {
            if ($voter['has_voted'] == 1) {
                echo json_encode(['status' => 'error', 'message' => 'You have already submitted your vote.']);
                exit;
            }
            $voters_id = $voter['voters_id'];
        }
    }

    if ($draft_code) {
        $stmt = $conn->prepare("UPDATE tbl_voters SET draft_code = ? WHERE voters_id = ?");
        $stmt->bind_param("si", $draft_code, $voters_id);
        $stmt->execute();
        $stmt->close();
    }

    // Get all already finalized question_ids
    $stmt = $conn->prepare("
        SELECT question_id FROM tbl_poll_choice WHERE voters_id = ?
        UNION
        SELECT question_id FROM tbl_poll_freetext WHERE voters_id = ?
    ");
    $stmt->bind_param("ii", $voters_id, $voters_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $alreadyFinalized = [];
    while ($row = $result->fetch_assoc()) {
        $alreadyFinalized[] = (int)$row['question_id'];
    }
    $stmt->close();

    // Handle finalized votes
    foreach ($finalized as $question_id => $detail) {
        $question_id = intval($question_id);
        if (in_array($question_id, $alreadyFinalized)) continue;

        $choice_id = isset($detail['choice_id']) && is_numeric($detail['choice_id']) ? intval($detail['choice_id']) : null;
        $freetext = trim($detail['freetext'] ?? '');

        if (!is_null($choice_id)) {
            $stmt = $conn->prepare("SELECT 1 FROM tbl_poll_choice WHERE voters_id = ? AND question_id = ?");
            $stmt->bind_param("ii", $voters_id, $question_id);
            $stmt->execute();
            $res = $stmt->get_result();
            if ($res->num_rows === 0) {
                $insert = $conn->prepare("INSERT INTO tbl_poll_choice (voters_id, question_id, choice_id, vote_at) VALUES (?, ?, ?, NOW())");
                $insert->bind_param("iii", $voters_id, $question_id, $choice_id);
                $insert->execute();
                $insert->close();

                $deleteDraftChoice = $conn->prepare("DELETE FROM tbl_draft_choice WHERE voters_id = ? AND question_id = ?");
                $deleteDraftChoice->bind_param("ii", $voters_id, $question_id);
                $deleteDraftChoice->execute();
                $deleteDraftChoice->close();

                $deleteDraftFreetext = $conn->prepare("DELETE FROM tbl_draft_freetext WHERE voters_id = ? AND question_id = ?");
                $deleteDraftFreetext->bind_param("ii", $voters_id, $question_id);
                $deleteDraftFreetext->execute();
                $deleteDraftFreetext->close();
            }
            $stmt->close();
        }

        if ($freetext !== '') {
            $stmt = $conn->prepare("SELECT 1 FROM tbl_poll_freetext WHERE voters_id = ? AND question_id = ?");
            $stmt->bind_param("ii", $voters_id, $question_id);
            $stmt->execute();
            $res = $stmt->get_result();
            if ($res->num_rows === 0) {
                $insert = $conn->prepare("INSERT INTO tbl_poll_freetext (voters_id, question_id, freetext, vote_at) VALUES (?, ?, ?, NOW())");
                $insert->bind_param("iis", $voters_id, $question_id, $freetext);
                $insert->execute();
                $insert->close();

                $deleteDraftChoice = $conn->prepare("DELETE FROM tbl_draft_choice WHERE voters_id = ? AND question_id = ?");
                $deleteDraftChoice->bind_param("ii", $voters_id, $question_id);
                $deleteDraftChoice->execute();
                $deleteDraftChoice->close();

                $deleteDraftFreetext = $conn->prepare("DELETE FROM tbl_draft_freetext WHERE voters_id = ? AND question_id = ?");
                $deleteDraftFreetext->bind_param("ii", $voters_id, $question_id);
                $deleteDraftFreetext->execute();
                $deleteDraftFreetext->close();
            }
            $stmt->close();
        }
    }

    // Handle fallback answers
    foreach ($answers as $answer) {
        $question_id = intval($answer['question_id']);
        if (in_array($question_id, $alreadyFinalized)) continue;

        $choice_id = isset($answer['choice_id']) && is_numeric($answer['choice_id']) ? intval($answer['choice_id']) : null;
        $freetext = trim($answer['freetext'] ?? '');

        if (!is_null($choice_id)) {
            $stmt = $conn->prepare("SELECT 1 FROM tbl_poll_choice WHERE voters_id = ? AND question_id = ?");
            $stmt->bind_param("ii", $voters_id, $question_id);
            $stmt->execute();
            $res = $stmt->get_result();
            if ($res->num_rows === 0) {
                $insert = $conn->prepare("INSERT INTO tbl_poll_choice (voters_id, question_id, choice_id, vote_at) VALUES (?, ?, ?, NOW())");
                $insert->bind_param("iii", $voters_id, $question_id, $choice_id);
                $insert->execute();
                $insert->close();
            }
            $stmt->close();
        }

        if ($freetext !== '') {
            $stmt = $conn->prepare("SELECT 1 FROM tbl_poll_freetext WHERE voters_id = ? AND question_id = ?");
            $stmt->bind_param("ii", $voters_id, $question_id);
            $stmt->execute();
            $res = $stmt->get_result();
            if ($res->num_rows === 0) {
                $insert = $conn->prepare("INSERT INTO tbl_poll_freetext (voters_id, question_id, freetext, vote_at) VALUES (?, ?, ?, NOW())");
                $insert->bind_param("iis", $voters_id, $question_id, $freetext);
                $insert->execute();
                $insert->close();
            }
            $stmt->close();
        }
    }

    // Check if voter finalized all active questions
    $result = $conn->query(
        "SELECT COUNT(*) AS total
         FROM tbl_questions q
         JOIN tbl_categories c ON q.category_id = c.category_id
         WHERE c.status = 1"
    );
    $totalQuestions = $result->fetch_assoc()['total'] ?? 0;

    $result = $conn->query(
        "SELECT COUNT(DISTINCT question_id) AS finalized_total FROM (
            SELECT q.question_id
            FROM tbl_poll_choice pc
            JOIN tbl_questions q ON pc.question_id = q.question_id
            JOIN tbl_categories c ON q.category_id = c.category_id
            WHERE pc.voters_id = $voters_id AND c.status = 1
            UNION
            SELECT q.question_id
            FROM tbl_poll_freetext pf
            JOIN tbl_questions q ON pf.question_id = q.question_id
            JOIN tbl_categories c ON q.category_id = c.category_id
            WHERE pf.voters_id = $voters_id AND c.status = 1
        ) AS finalized_questions"
    );
    $finalizedCount = $result->fetch_assoc()['finalized_total'] ?? 0;

    if ($finalizedCount >= $totalQuestions && $totalQuestions > 0) {
        $conn->query("UPDATE tbl_voters SET has_voted = 1 WHERE voters_id = $voters_id");
    }

    $conn->commit();

    echo json_encode([
        'status' => 'success',
        'message' => ($finalizedCount >= $totalQuestions)
            ? 'Your response has been successfully casted.'
            : 'Your responses have been saved. You can continue later.'
    ]);

} catch (Exception $e) {
    $conn->rollback();
    file_put_contents("submit_vote_error.txt", $e->getMessage());
    echo json_encode([
        'status' => 'error',
        'message' => 'Vote submission failed.',
        'error' => $e->getMessage()
    ]);
}
?>
