<?php
require_once '../tocca_admin/db_connection.php';
require_once '../tocca_admin/get_logo.php';

// Defensive: don't let missing columns crash the page
mysqli_report(MYSQLI_REPORT_OFF);

function h($s){ return htmlspecialchars((string)$s, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8'); }

/**
 * Try multiple sources to find the company logo for a given choice_id.
 * Priority:
 *   1) tbl_choices.(logo_path|logo|logo_url|image_path)
 *   2) Latest nomination for this choice_id whose field label/name suggests "logo"
 *      via tbl_nomination_answers JOIN tbl_nomination_fields.
 */
function findCompanyLogoForChoice(mysqli $conn, int $choiceId): ?string {
  // --- 1) Try tbl_choices with a few likely column names ---
  $choiceCols = ['logo_path','logo','logo_url','image_path'];
  foreach ($choiceCols as $col) {
    try {
      $sql = "SELECT $col AS p FROM tbl_choices WHERE choice_id = ? LIMIT 1";
      if ($stmt = $conn->prepare($sql)) {
        $stmt->bind_param('i', $choiceId);
        $stmt->execute();
        $stmt->bind_result($p);
        if ($stmt->fetch() && $p !== null && $p !== '') { $stmt->close(); return (string)$p; }
        $stmt->close();
      }
    } catch (Throwable $e) {
      // Column may not exist—ignore and try the next option.
    }
  }

  // --- 2) Look up latest nomination's "logo" answer (dynamic fields) ---
  try {
    // Latest nomination for this business (merged_choice_id = choiceId)
    $sql = "
      SELECT a.answer
      FROM tbl_nominations n
      JOIN tbl_nomination_answers a ON a.nomination_id = n.nomination_id
      JOIN tbl_nomination_fields  f ON f.id = a.field_id
      WHERE n.merged_choice_id = ?
        AND (
          LOWER(f.name)  IN ('logo','logo_path','business_logo','company_logo')
          OR LOWER(f.label) LIKE '%logo%'
        )
      ORDER BY n.updated_at DESC, a.created_at DESC, a.id DESC
      LIMIT 1
    ";
    if ($stmt = $conn->prepare($sql)) {
      $stmt->bind_param('i', $choiceId);
      $stmt->execute();
      $stmt->bind_result($ans);
      if ($stmt->fetch() && $ans !== null && $ans !== '') { $stmt->close(); return (string)$ans; }
      $stmt->close();
    }
  } catch (Throwable $e) {
    // If schema differs, just skip—page will render without a logo.
  }

  return null;
}

$companyLogoPath = null;
$choiceId = isset($_GET['choice_id']) ? (int)$_GET['choice_id'] : 0;
if ($choiceId > 0) {
  $companyLogoPath = findCompanyLogoForChoice($conn, $choiceId);
  if ($companyLogoPath) $companyLogoPath = resolveAssetPath($companyLogoPath);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>QR Vote | Tatak Ormoc</title>
  <link rel="icon" type="image/png" href="<?php echo $faviconPath; ?>">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <script src="https://www.gstatic.com/firebasejs/10.12.1/firebase-app-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/10.12.1/firebase-auth-compat.js"></script>
  <script src="https://www.google.com/recaptcha/api.js" async defer></script>
  <link rel="stylesheet" href="css/user-style.css">
  <script>
    const firebaseConfig = {
      apiKey: "AIzaSyD3nY0rVvAczMRmbUEdHs2-liek3EOCvuo",
      authDomain: "tatakormoc-a9bc1.firebaseapp.com",
      projectId: "tatakormoc-a9bc1",
      storageBucket: "tatakormoc-a9bc1.appspot.com",
      messagingSenderId: "398460032274",
      appId: "1:398460032274:web:fbd32f43b023789d34cfcb",
      measurementId: "G-KD7X3DQYLP"
    };
    firebase.initializeApp(firebaseConfig);
  </script>
  <style>
    body { font-size: var(--voter-font-size, 1rem); color: var(--voter-text-color, #000); }
    .category-layout-container { display:flex; flex-direction:column; align-items:center; min-height:100vh; }
    .category-title { font-weight:bold; color:#010066; }
    .question-entry { background-color:#fff; padding:1rem; margin-bottom:0.5rem; border-radius:0.375rem; }
    .btn-vote { border-radius:0.375rem; }
    .category-box { padding:1rem; border-radius:10px; margin-bottom:1rem; }
    .footer { background:#f1f6fc; border-top:1px solid #dee2e6; color:#333; margin-top:auto; padding:clamp(.85rem,2vw,1.1rem) 1rem; width:100%; font-size:clamp(.7rem,1.5vw,.85rem); line-height:1.35; }
    .footer-content { display:flex; flex-direction:column; align-items:center; justify-content:center; gap:clamp(.5rem,1.4vw,.75rem); width:100%; text-align:center; }
    .footer-section { display:flex; align-items:center; justify-content:center; gap:clamp(.3rem,1vw,.45rem); flex-wrap:wrap; color:inherit; width:100%; }
    .footer-right { gap:clamp(.3rem,1vw,.45rem); row-gap:.15rem; }
    .footer-link { color:inherit; text-decoration:none; white-space:nowrap; }
    .footer-link:hover { text-decoration:underline; }
    .footer-separator { color:inherit; }
    .footer-logo { height:clamp(14px,1.8vw,18px); margin-left:8px; }
    @media (min-width:768px){
      .footer-content { flex-direction:row; align-items:center; justify-content:space-between; text-align:left; }
      .footer-section { width:auto; flex:1 1 0; }
      .footer-left{ justify-content:flex-start; } .footer-center{ justify-content:center; } .footer-right{ justify-content:flex-end; }
    }
    @media (max-width:480px){ .footer-right{ justify-content:center; } }
    #openLegacyBtn { font-weight:normal; }
  </style>
</head>
<body>
  <div class="category-layout-container">
    <div class="header">
      <img id="headerLogo" src="img/tocca2023.jpg" alt="TOCCA Header Image" class="header-logo" style="max-width:100%;height:auto;" />
    </div>

    <?php if (!empty($companyLogoPath)): ?>
      <div class="container-fluid d-flex justify-content-center mb-4" style="margin-top:20px;">
        <div class="company-logo-container shadow-sm p-3 bg-white d-flex align-items-center justify-content-center" style="max-width:500px; max-height:200px; border-radius:10px;">
          <img src="<?php echo h($companyLogoPath); ?>" alt="Company Logo" style="max-width:100%; max-height:100%; object-fit:contain;">
        </div>
      </div>
    <?php endif; ?>

    <div class="container-fluid mb-4 justify-content-center" style="margin-top:20px;">
      <div class="info-box bg-light shadow-sm p-3 w-100 text-center">
        <h2 id="businessName" class="fw-bold text-uppercase text-primary mb-0" style="font-size:1.8rem;"></h2>
      </div>
    </div>

    <div class="container-fluid mb-4" style="margin-top:20px;">
      <div class="d-flex flex-column align-items-center">
        <button id="signOutBtn" class="btn btn-outline-danger" data-bs-toggle="modal">Sign Out</button>
      </div>
    </div>

    <div class="container-fluid mb-4">
      <div id="summaryContainer" class="accordion category-panel"></div>
    </div>

    <div class="container-fluid d-flex mt-3 mb-4 flex-column flex-sm-row align-items-center gap-2 justify-content-center button-group-summary text-center">
      <button id="voteAllBtn" class="btn btn-success btn-custom mb-2">Vote All</button>
      <button id="openLegacyBtn" class="btn btn-link btn-custom mb-1">Go to Main Voting Site</button>
    </div>

    <div class="footer">
      <div class="footer-content">
        <div class="footer-section footer-left">
          <span class="footer-text">&copy; <?php echo date('Y'); ?> Tatak Ormoc Consumers&rsquo; Choice Awards</span>
        </div>
        <div class="footer-section footer-center">
          <span class="footer-text">STI College Ormoc <img class="footer-logo" src="img/sti.png" alt="STI Logo"></span>
        </div>
        <div class="footer-section footer-right">
          <a class="footer-link" href="privacy_policy.php">Privacy Policy</a>
          <span class="footer-separator" aria-hidden="true">&bull;</span>
          <a class="footer-link" href="terms_and_conditions.php">Terms &amp; Conditions</a>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="progress_helper.js"></script>
  <script type="module" src="qr_selected_category.js"></script>
  <script src="apply_voter_style.js"></script>
  <script src="toast.js"></script>
  <script src="signout.js"></script>

  <div class="modal fade" id="confirmSignOutModal" tabindex="-1" aria-labelledby="confirmSignOutLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header"><h5 class="modal-title" id="confirmSignOutLabel">Confirm Sign Out</h5></div>
        <div class="modal-body" id="confirmSignOutMessage"></div>
        <div class="modal-footer">
          <button id="confirmSignOutBtn" class="btn btn-outline-danger">Sign Out</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        </div>
      </div>
    </div>
  </div>

  <div class="toast-container position-fixed top-0 start-50 translate-middle-x p-3">
    <div id="validationToast" class="toast text-bg-info" role="alert" aria-live="assertive" aria-atomic="true">
      <div class="d-flex">
        <div class="toast-body"></div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
      </div>
    </div>
  </div>

  <script>
    function DisableBackButton(){ window.history.forward(); }
    DisableBackButton();
    window.onload = DisableBackButton;
    window.onpageshow = function(evt){ if (evt.persisted) DisableBackButton(); }
    window.onunload = function(){};
  </script>
</body>
</html>
