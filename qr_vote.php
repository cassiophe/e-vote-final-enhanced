<?php
require_once '../tocca_admin/db_connection.php';
require_once '../tocca_admin/get_logo.php';

date_default_timezone_set('Asia/Manila');

$now = date('Y-m-d H:i:s');

// Assign choice_id from GET parameter or default 0
$choice_id = isset($_GET['choice_id']) ? (int)$_GET['choice_id'] : 0;

// Fetch the currently active event
$result = $conn->query("SELECT * FROM tbl_events WHERE is_active = 1 LIMIT 1");
$event = $result->fetch_assoc();

// Store event_id in localStorage
if (
    !$event || 
    $now < $event['voting_start'] || 
    $now > $event['voting_end']
) {
    header("Location: message.php");
    exit;
}

$choice_id = isset($_GET['choice_id']) ? (int)$_GET['choice_id'] : 0;

//Fetch business name
$stmt = $conn->prepare("SELECT choice_name, status FROM tbl_choices WHERE choice_id = ?");
$stmt->bind_param("i", $choice_id);
$stmt->execute();
$choiceRow = $stmt->get_result()->fetch_assoc();
$choice_name = $choiceRow['choice_name'] ?? 'Unknown Business';
$choice_status = $choiceRow['status'] ?? 0;

//If business is inactive
if (!$choiceRow || (int)$choice_status !== 1) {
    $message = htmlspecialchars($choice_name, ENT_QUOTES) . ' is currently unavailable for voting.';
    echo <<<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Establishment Unavailable</title>
  <link rel="icon" type="image/png" href="$faviconPath">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="css/user-style.css">
</head>
<body class="d-flex flex-column justify-content-center align-items-center p-4">
  <div class="text-center">
    <p class="fs-4 fw-bold text-danger mb-3">$message</p>
    <p>Would you like to continue voting in the main voting site instead?</p>
    <div class="mt-3">
      <a href="index.php" class="btn btn-primary me-2">Go to Main Voting</a>
    </div>
  </div>
</body>
</html>
HTML;
    exit;
}

//Fetch categories linked to this business
$stmt = $conn->prepare("
    SELECT DISTINCT c.category_id, c.category_name
    FROM tbl_categories c
    JOIN tbl_questions q ON c.category_id = q.category_id
    JOIN tbl_question_choices qc ON q.question_id = qc.question_id
    WHERE qc.choice_id = ?
    AND c.status = 1
");
$stmt->bind_param("i", $choice_id);
$stmt->execute();
$categories = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Tatak Ormoc Consumers' Choice Awards 2024</title>
  <link rel="icon" type="image/png" href="<?php echo $faviconPath; ?>">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <link rel="stylesheet" href="css/user-style.css" />
  <script src="https://www.google.com/recaptcha/api.js" async defer></script>
  <script src="https://www.gstatic.com/firebasejs/10.12.1/firebase-app-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/10.12.1/firebase-auth-compat.js"></script>
  <style>
    .footer {
      background-color: #f1f6fc;
      border-top: 1px solid #dee2e6;
      color: #333;
      margin-top: auto;
      padding: clamp(0.85rem, 2vw, 1.1rem) 1rem;
      width: 100%;␊
      font-size: clamp(0.7rem, 1.5vw, 0.85rem);
      line-height: 1.35;
    }


    .footer-content {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: clamp(0.5rem, 1.4vw, 0.75rem);
      width: 100%;
      text-align: center;
    }

    .footer-section {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: clamp(0.3rem, 1vw, 0.45rem);
      flex-wrap: wrap;
      color: inherit;
      width: 100%;
    }

    .footer-right {
      column-gap: clamp(0.3rem, 1vw, 0.45rem);s
      row-gap: 0.15rem;
    }

    .footer-center {
      justify-content: center;
      text-align: center;
    }

    .footer-right {
      justify-content: flex-end;
      text-align: right;
      flex-wrap: wrap;
      column-gap: clamp(0.3rem, 1vw, 0.45rem);
      row-gap: 0.15rem;
    }

    .footer-link {
      color: inherit;
      text-decoration: none;
      white-space: nowrap;
    }

    .footer-link:hover {
      text-decoration: underline;
    }

    .footer-separator {
      color: inherit;
    }

    .footer-logo {
      height: clamp(14px, 1.8vw, 18px);
    }

    @media (min-width: 768px) {
      .footer-content {
        flex-direction: row;
        align-items: center;
        justify-content: space-between;
        text-align: left;
      }

      .footer-section {
        width: auto;
        flex: 1 1 0;
      }

      .footer-left {
        justify-content: flex-start;
        text-align: left;
      }

      .footer-center {
        justify-content: center;
        text-align: center;
      }

      .footer-right {
        justify-content: flex-end;
        text-align: right;
      }
    }

    @media (max-width: 480px) {
      .footer-right {
        justify-content: center;
      }
    }
  </style>
  <script>
    const firebaseConfig = {
      apiKey: "AIzaSyBWSN9I0gH2YrF-y53hgRiwzLKkMcGOKCg",
      authDomain: "tocca-voting-system.firebaseapp.com",
      projectId: "tocca-voting-system",
      storageBucket: "tocca-voting-system.firebasestorage.app",
      messagingSenderId: "197035166608",
      appId: "1:197035166608:web:35c18bc393bf5f17a18115"
    };
    firebase.initializeApp(firebaseConfig);
  </script>
</head>
<body>

<!-- Business info injection -->
<script>
  localStorage.setItem("qr_choice_id", "<?php echo $choice_id; ?>");
  localStorage.setItem("qr_business", <?php echo json_encode($choice_name); ?>);
  localStorage.setItem("qr_categories", JSON.stringify(<?php echo json_encode($categories); ?>));
  localStorage.setItem("current_event_id", "<?php echo $event['event_id']; ?>");
</script>

<!-- Intro modal -->
<div class="modal fade" id="introModal" tabindex="-1" aria-labelledby="introModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content overflow-hidden">
      <div class="modal-header modal-header-custom"></div>
     <div class="modal-body p-4">
        <p>The City Government of Ormoc through the Tatak Ormoc Business Awards Organizing Committee in partnership with the Ormoc City Chamber of Commerce and Industry and STI College – Ormoc is pleased to inform the public of the opening of the <strong>2024 Tatak Ormoc Consumers’ Choice Awards (TOCCA)</strong>.</p>
        <p>The 2024 TOCCA determines which Ormocanon products and services are top of mind to the citizens, and recognizes the best among them. Vote and choose which of your favorites deserves to be called one of Tatak Ormoc!</p>
        <p>A nomination was held last <strong>August 4–28, 2024</strong>, to the general public through Google Form and drop boxes located in a conspicuous place within the City. The top businesses are then placed in each award category.</p>
        <p>Thereafter, polling will begin starting on <strong>July 1, 2025, until September 15, 2025</strong>. Qualified business establishments which receive the highest votes shall be declared as 2024 Tatak Ormoc Consumers’ Choice Award Winners.</p>
        <p><strong>QUALIFICATIONS:</strong></p>
        <ul>
          <li>Duly registered and in good standing per records of the Business Permits and Licensing Office (BPLO) and other regulatory offices;</li>
          <li>The nominated business must have been in operation for at least one (1) year at the time of the award.</li>
        </ul>
        <div class="mt-4">
          <p class="mb-2">Please review and acknowledge the following before proceeding:</p>
          <div class="form-check mb-2">
            <input class="form-check-input intro-consent-checkbox" type="checkbox" value="" id="agreeTerms" />
            <label class="form-check-label" for="agreeTerms">
              I have read and agree to the <a href="terms_and_conditions.php" target="_blank" rel="noopener noreferrer">Terms and Conditions</a>.
            </label>
          </div>
          <div class="form-check">
            <input class="form-check-input intro-consent-checkbox" type="checkbox" value="" id="agreePrivacy" />
            <label class="form-check-label" for="agreePrivacy">
              I have read and agree to the <a href="privacy_policy.php" target="_blank" rel="noopener noreferrer">Privacy Policy</a>.
            </label>
          </div>
        </div>
      </div>
      <div class="modal-footer modal-footer-custom justify-content-end">
        <button type="button" class="btn btn-tocca-close disabled" id="closeIntroBtn" disabled>Close</button>
      </div>
    </div>
  </div>
</div>


<!-- Voting instructions -->
  <div class="main-container">
    <div class="text-center mb-4">
      <img id="headerLogo" src="img/tocca2023.jpg" alt="TOCCA Logo with Partners" class="header-logo mb-3" />
    </div>

    <div class="instruction-box">
      <h5><strong>INSTRUCTION:</strong></h5>
      <p>The 2024 Tatak Ormoc Consumers’ Choice awards have 20 award categories in total which determine Ormoc best product and service provider. Please answer all categories by choosing your best product and service provider thru:</p>
      <ol>
        <li>Choose your Tatak Ormoc's Best per category thru:
          <ul>
            <li>By choosing from the top businesses which resulted from the Nomination Round last August 4-28, 2023;</li>
            <li>If your preferred business is not on the top list, click on the “Select from the List of Registered Businesses in the BPLO” and search from list of registered businesses. You may also type the business name on the box provided to search.</li>
            <li>If your preferred business is not on the top nor on the list of registered businesses in the BPLO, you may input the name of the business directly on the last box after clicking on the button.</li>
          </ul>
          <em>Please note, however, that inputted businesses are subject for further review by the awards body based on the qualifications.</em>
        </li>
        <li>Once done, click <strong>“SUBMIT VOTE AND PROCEED TO MOBILE NUMBER VERIFICATION”</strong> found at the bottom of the website.</li>
        <li>Review the summary of your choices. If you wish to change anything, click on the back button to redo.</li>
        <li>If satisfied with your choices, input your valid mobile number. Please note that one vote is allowed per mobile number.</li>
        <li>Click on the reCaptcha and follow the instructions.</li>
        <li>Once done, click the SEND CODE button. A One-Time Password (OTP) will be sent to the mobile number provided.</li>
        <li>If the OTP is verified, click on the CAST VOTE button. A pop-up message will appear informing you that your votes have been successfully casted.</li>
      </ol>
    </div>

    <button class="proceed-button">PROCEED TO VOTING</button>

<!-- Footer -->
<div class="footer">
  <div class="footer-content">
    <div class="footer-section footer-left">
      <span class="footer-text">&copy; <?php echo date('Y'); ?> Tatak Ormoc Consumers&rsquo; Choice Awards</span>
    </div>
    <div class="footer-section footer-center">
      <span class="footer-text">STI College Ormoc <img class="footer-logo" src="img/sti.png" alt="STI Logo" /></span>
    </div>
    <div class="footer-section footer-right">
      <a class="footer-link" href="privacy_policy.php">Privacy Policy</a>
      <span class="footer-separator" aria-hidden="true">&bull;</span>
      <a class="footer-link" href="terms_and_conditions.php">Terms &amp; Conditions</a>
    </div>
  </div>
</div>

<div class="modal fade" id="voterVerificationModal" tabindex="-1" aria-labelledby="voterVerificationLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content p-3">
      <div class="modal-header">
        <h5 class="modal-title">Voter Type</h5>
      </div>
      <div class="modal-body">
        <div id="voterQuestion">
          <div class="d-flex justify-content-center gap-2">
            <button id="newVoterBtn" class="btn btn-success mb-3 w-100" data-bs-target="#otpModal" data-bs-toggle="modal" data-bs-dismiss="modal">New Voter</button>
            <button class="btn btn-outline-primary w-100 h-50" data-bs-target="#existingVoterModal" data-bs-toggle="modal" data-bs-dismiss="modal">Existing Voter</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="newVoterModal" tabindex="-1" aria-labelledby="newVoterLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="newVoterLabel">Welcome!</h5>
      </div>
      <div class="modal-body text-center">
        <p class="text-success fw-bold">You are about to begin the voting process.</p>
      </div>
    </div>
  </div>
</div>

<!-- Existing Voter Modal (unchanged from your original) -->
<div class="modal fade" id="existingVoterModal" tabindex="-1" aria-labelledby="existingVoterLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="existingVoterLabel">Existing Voter Login</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body text-start px-4">
        <div class="mb-3">
          <label for="existingMobile" class="form-label fw-bold">Mobile Number</label>
          <input type="text" class="form-control" id="existingMobile" maxlength="11" pattern="[0-9]{11}" placeholder="09XXXXXXXXX">
        </div>
        <div class="mb-3">
          <label for="draftCode" class="form-label fw-bold">Draft Access Code</label>
          <input type="password" class="form-control" id="draftCode" maxlength="4" placeholder="4-digit PIN">
        </div>
        <div class="text-center">
          <button id="checkDraftBtn" class="btn btn-primary px-4">Continue</button>
        </div>
        <div id="loginError" class="text-danger text-center mt-2" style="display: none;"></div>
        <div class="text-center mt-2">
          <a href="#" id="forgotCodeLink">Forgot Access Code?</a>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Modal: Forgot Access Code -->
<div class="modal fade" id="forgotModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content p-3">
      <div class="modal-header">
        <h5 class="modal-title">Forgot Access Code</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div id="forgotStep1" class="d-block">
          <div class="mb-3">
            <label for="forgotMobile" class="form-label">Enter Mobile Number (09xxxxxxxxx)</label>
            <input type="tel" id="forgotMobile" class="form-control" maxlength="11" pattern="09\d{9}" placeholder="09xxxxxxxxx" required>
          </div>
          <div id="forgotRecaptchaContainer" class="mb-3"></div>
          <div id="forgotMessage" class="mt-2 small"></div>
          <button id="sendForgotOtpBtn" class="btn btn-primary w-100 mb-2" disabled>
            <span id="sendForgotOtpSpinner" class="spinner-border spinner-border-sm me-2 d-none" role="status" aria-hidden="true"></span>
            <span>Send OTP</span>
          </button>
        </div>
        <div id="forgotStep2" class="d-none">
          <div class="mb-3 mt-3">
            <label for="forgotOtpCode" class="form-label">Enter OTP</label>
            <input type="text" id="forgotOtpCode" class="form-control" placeholder="Enter OTP received" />
            <small id="forgotOtpSentToMobileMessage" class="form-text text-muted"></small>
          </div>
          <button id="verifyForgotOtpBtn" class="btn btn-success w-100">
            <span id="verifyForgotOtpSpinner" class="spinner-border spinner-border-sm me-2 d-none" role="status" aria-hidden="true"></span>
            <span>Verify OTP</span>
          </button>
          <button type="button" id="resendForgotOtpBtn" class="btn btn-link w-100 mt-2" style="display: none;">Resend OTP</button>
        </div>
        <div id="forgotVerifyMessage" class="mt-2 alert" style="display:none;"></div>
      </div>
    </div>
  </div>
</div>

<!-- OTP Modal -->
<div class="modal fade" id="otpModal" tabindex="-1" aria-labelledby="otpModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content p-3">
      <div class="modal-header">
        <h5 class="modal-title" id="otpModalLabel">Mobile Number Verification</h5>
      </div>
      <div class="modal-body" style="min-height: 200px;">
        <div id="otpStep1" class="d-block">
          <div class="mb-3">
            <label for="otpMobile" class="form-label">Enter Mobile Number (09xxxxxxxxx)</label>
            <input type="tel" id="otpMobile" class="form-control" maxlength="11" pattern="09\d{9}" placeholder="09xxxxxxxxx" required>
          </div>
          <div id="recaptchaContainer" class="mb-3"></div>

          <div id="otpMessage" class="mt-2 small"></div>
            <button id="sendOtpBtn" class="btn btn-primary w-100 mb-2" disabled>
              <span id="sendOtpSpinner" class="spinner-border spinner-border-sm me-2 d-none" role="status" aria-hidden="true"></span>
              <span>Send OTP</span>
            </button>
          </div>

        <div id="otpStep2" class="d-none">
          <div class="mb-3 mt-3">
            <label for="otpCode" class="form-label">Enter OTP</label>
            <input type="text" id="otpCode" class="form-control" placeholder="Enter OTP received" />
            <small id="otpSentToMobileMessage" class="form-text text-muted"></small>
          </div>
          <button id="verifyOtpBtn" class="btn btn-success w-100">Verify OTP &amp; Cast Vote</button>
          <button type="button" id="resendOtpBtn" class="btn btn-link w-100 mt-2" style="display: none;">Resend OTP</button>
        </div>
        <div id="otpVerifyMessage" class="mt-2 alert" style="display:none;"></div>
      </div>
    </div>
  </div>
</div>

<!-- Access Code Modal -->
<div class="modal fade" id="draftCodeModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Set Access Code</h5>
      </div>
      <div class="modal-body">
        <p>Please create a 4-digit access code to save your draft securely.</p>
        <input type="password" id="draftCodeInput" class="form-control mb-2" maxlength="4" placeholder="Enter 4-digit code" />
        <input type="password" id="draftCodeConfirmInput" class="form-control mb-2" maxlength="4" placeholder="Confirm 4-digit code" />
        <div id="draftCodeError" class="text-danger d-none">Invalid code. Must be 4 digits and match confirmation.</div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary" id="saveDraftCodeBtn">
          <span id="saveDraftSpinner" class="spinner-border spinner-border-sm me-2 d-none" role="status" aria-hidden="true"></span>
          <span>Save Code</span>
        </button>
      </div>
    </div>
  </div>
</div>

<!-- Incomplete Vote Modal -->
<div class="modal fade" id="incompleteModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Notice</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body" id="incompleteModalMessage"></div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="apply_voter_style.js"></script>
<script src="toast.js"></script>
<script>
  let voterModal;
function showVoterVerificationModal() {
  if (voterModal) {
    voterModal.show();
  }
}

const RECAPTCHA_VALID_MS = 2 * 60 * 1000;
let recaptchaSolveTime = null;
let recaptchaExpirationTimer = null;
let isSendingOtp = false;

// Elements used for OTP flow will be assigned after DOMContentLoaded
let otpMobileInput;
let sendOtpBtn;
let sendOtpSpinner;
let otpCodeInput;
let verifyOtpBtn;
let verifyOtpSpinner;
let saveDraftSpinner;
let otpMessage;
let otpVerifyMessage;
let otpSentToMobileMessage;
let otpStep1;
let otpStep2;
let forgotMobileInput;
let sendForgotOtpBtn;
let sendForgotOtpSpinner;
let forgotOtpCodeInput;
let verifyForgotOtpBtn;
let verifyForgotOtpSpinner;
let forgotMessage;
let forgotVerifyMessage;
let forgotOtpSentToMobileMessage;
let forgotStep1;
let forgotStep2;

function handleRecaptchaSolved() {
  recaptchaSolveTime = Date.now();
  clearTimeout(recaptchaExpirationTimer);
  recaptchaExpirationTimer = setTimeout(handleRecaptchaExpired, RECAPTCHA_VALID_MS);
  updateSendOtpState();
}

function handleRecaptchaExpired() {
  recaptchaSolveTime = null;
  clearTimeout(recaptchaExpirationTimer);
  recaptchaExpirationTimer = null;
  if (typeof window.onSummaryRecaptchaExpired === "function") window.onSummaryRecaptchaExpired();
  updateSendOtpState();
}

async function initRecaptcha(forceReset = false) {
  const container = document.getElementById("recaptchaContainer");
  if (!container || container.offsetParent === null) {
    setTimeout(() => initRecaptcha(forceReset), 300);
    return;
  }
  if (forceReset) {
    try {
      if (window.recaptchaVerifier?.grecaptchaWidgetId !== undefined) {
        grecaptcha.reset(window.recaptchaVerifier.grecaptchaWidgetId);
      }
    } catch (e) {}
    try { container.innerHTML = ""; } catch (e) {}
    window.recaptchaVerifier = null;
  }
  if (window.recaptchaVerifier && !forceReset) return;
  try {
    window.recaptchaVerifier = new firebase.auth.RecaptchaVerifier(
      "recaptchaContainer",
      {
        size: "normal",
        callback: handleRecaptchaSolved,
        "expired-callback": handleRecaptchaExpired,
        "error-callback": handleRecaptchaExpired
      }
    );
    recaptchaSolveTime = null;
    clearTimeout(recaptchaExpirationTimer);
    const widgetId = await window.recaptchaVerifier.render();
    window.recaptchaVerifier.grecaptchaWidgetId = widgetId;
    updateSendOtpState();
  } catch (err) {
    console.error("initRecaptcha failed:", err);
  }
}

function updateSendOtpState() {
  const mobile = otpMobileInput.value.trim();
  const isValidMobile = /^(?:\+639|09)\d{9}$/.test(mobile);
  let recaptchaSolved = false;
  try {
    if (window.recaptchaVerifier && typeof grecaptcha !== "undefined" && window.recaptchaVerifier.grecaptchaWidgetId !== undefined) {
      const resp = grecaptcha.getResponse(window.recaptchaVerifier.grecaptchaWidgetId);
      recaptchaSolved = resp && resp.length > 0;
    }
  } catch (e) {
    recaptchaSolved = false;
  }
  const withinTime = recaptchaSolveTime && Date.now() - recaptchaSolveTime < RECAPTCHA_VALID_MS;
  if (sendOtpBtn) sendOtpBtn.disabled = !(isValidMobile && recaptchaSolved && withinTime);
}

function updateSendForgotOtpState() {
  if (!forgotMobileInput || !sendForgotOtpBtn) return;
  const mobile = forgotMobileInput.value.trim();
  const isValidMobile = /^(?:\+639|09)\d{9}$/.test(mobile);
  let recaptchaSolved = false;
  try {
    if (window.forgotRecaptchaVerifier && typeof grecaptcha !== "undefined") {
      const widgetId = window.forgotRecaptchaVerifier.grecaptchaWidgetId;
      if (widgetId !== undefined) {
        const resp = grecaptcha.getResponse(widgetId);
        recaptchaSolved = resp && resp.length > 0;
      }
    }
  } catch (e) {
    recaptchaSolved = false;
  }
  sendForgotOtpBtn.disabled = !(isValidMobile && recaptchaSolved);
}

document.addEventListener("DOMContentLoaded", async () => {
  const introModalEl = document.getElementById("introModal");
  const instructionModalEl = document.getElementById("instructionModal");
  const voterModalEl = document.getElementById("voterVerificationModal");
  const newVoterModalEl = document.getElementById("newVoterModal");
  const existingVoterModalEl = document.getElementById("existingVoterModal");
  const otpModalEl = document.getElementById("otpModal");
  const draftCodeModalEl = document.getElementById("draftCodeModal");
  const incompleteModalEl = document.getElementById("incompleteModal");
  const forgotModalEl = document.getElementById("forgotModal");

  const instructionModal = instructionModalEl ? new bootstrap.Modal(instructionModalEl) : null;
  const introModal = new bootstrap.Modal(introModalEl);
  voterModal = new bootstrap.Modal(voterModalEl);
  const newVoterModal = new bootstrap.Modal(newVoterModalEl);
  const existingVoterModal = new bootstrap.Modal(existingVoterModalEl);
  const otpModal = new bootstrap.Modal(otpModalEl);
  const draftCodeModal = new bootstrap.Modal(draftCodeModalEl);
  const incompleteModal = new bootstrap.Modal(incompleteModalEl);
  const forgotModal = new bootstrap.Modal(forgotModalEl);
  const draftModalTitleEl = document.getElementById("draftCodeModal")?.querySelector(".modal-title");
  const draftModalDefaultTitle = draftModalTitleEl?.textContent || "Set Access Code";
  otpMobileInput = document.getElementById("otpMobile");
  sendOtpBtn = document.getElementById("sendOtpBtn");
  sendOtpSpinner = document.getElementById("sendOtpSpinner");
  otpCodeInput = document.getElementById("otpCode");
  verifyOtpBtn = document.getElementById("verifyOtpBtn");
  otpMessage = document.getElementById("otpMessage");
  otpVerifyMessage = document.getElementById("otpVerifyMessage");
  otpSentToMobileMessage = document.getElementById("otpSentToMobileMessage");
  otpStep1 = document.getElementById("otpStep1");
  otpStep2 = document.getElementById("otpStep2");
  forgotMobileInput = document.getElementById("forgotMobile");
  sendForgotOtpBtn = document.getElementById("sendForgotOtpBtn");
  sendForgotOtpSpinner = document.getElementById("sendForgotOtpSpinner");
  forgotOtpCodeInput = document.getElementById("forgotOtpCode");
  verifyForgotOtpBtn = document.getElementById("verifyForgotOtpBtn");
  verifyForgotOtpSpinner = document.getElementById("verifyForgotOtpSpinner");
  forgotMessage = document.getElementById("forgotMessage");
  forgotVerifyMessage = document.getElementById("forgotVerifyMessage");
  forgotOtpSentToMobileMessage = document.getElementById("forgotOtpSentToMobileMessage");
  forgotStep1 = document.getElementById("forgotStep1");
  forgotStep2 = document.getElementById("forgotStep2");

  window.forgotRecaptchaVerifier = new firebase.auth.RecaptchaVerifier(
    "forgotRecaptchaContainer",
    {
      size: "normal",
      callback: () => updateSendForgotOtpState(),
      "expired-callback": () => updateSendForgotOtpState(),
      "error-callback": () => updateSendForgotOtpState()
    }
  );

  const modalMap = {
    introModal,
    voterVerificationModal: voterModal,
    newVoterModal,
    existingVoterModal,
    otpModal,
    forgotModal,
  };

  await initRecaptcha();

  const savedModal = localStorage.getItem("currentIndexModal");
  if (savedModal === "otpModal") {
    const step = localStorage.getItem("otpStep") || "1";
    otpStep1.classList.toggle("d-none", step === "2");
    otpStep2.classList.toggle("d-none", step === "1");
    otpModal.show();
  } else if (savedModal === "draftCodeModal") {
    draftCodeModal.show();
    bindSaveDraftButton(() => newVoterModal.show());
  } else if (savedModal && modalMap[savedModal]) {
    modalMap[savedModal].show();
  } else {
    introModal.show();
  }

  [introModalEl, voterModalEl, newVoterModalEl, existingVoterModalEl, otpModalEl, draftCodeModalEl, forgotModalEl].forEach(el => {
    if (!el) return;
    el.addEventListener("shown.bs.modal", () => {
      localStorage.setItem("currentIndexModal", el.id);
      if (el.id === "otpModal") {
        const step = otpStep2.classList.contains("d-none") ? "1" : "2";
        localStorage.setItem("otpStep", step);
        initRecaptcha();
      } else if (el.id === "forgotModal") {
        if (window.forgotRecaptchaVerifier && !window.forgotRecaptchaVerifier.grecaptchaWidgetId) {
          window.forgotRecaptchaVerifier.render().then(widgetId => {
            window.forgotRecaptchaVerifier.grecaptchaWidgetId = widgetId;
            updateSendForgotOtpState();
          }).catch(err => console.error("Forgot recaptcha render failed:", err));
        } else {
          updateSendForgotOtpState();
        }
      }
    });
    el.addEventListener("hidden.bs.modal", () => {
      if (localStorage.getItem("currentIndexModal") === el.id) {
        localStorage.removeItem("currentIndexModal");
        if (el.id === "otpModal") {
          localStorage.removeItem("otpStep");
        } else if (el.id === "forgotModal") {
          forgotStep1?.classList.remove("d-none");
          forgotStep2?.classList.add("d-none");
          if (forgotMessage) {
            forgotMessage.innerHTML = "";
            forgotMessage.style.display = "none";
          }
          if (forgotVerifyMessage) {
            forgotVerifyMessage.innerHTML = "";
            forgotVerifyMessage.style.display = "none";
          }
          if (forgotMobileInput) forgotMobileInput.value = "";
          if (forgotOtpCodeInput) forgotOtpCodeInput.value = "";
          if (window.forgotRecaptchaVerifier?.grecaptchaWidgetId !== undefined && typeof grecaptcha !== "undefined") {
            try {
              grecaptcha.reset(window.forgotRecaptchaVerifier.grecaptchaWidgetId);
            } catch (err) {
              console.warn("Failed to reset forgot reCAPTCHA:", err);
            }
          }
          updateSendForgotOtpState();
        } else if (el.id === "draftCodeModal") {
          if (draftModalTitleEl) {
            draftModalTitleEl.textContent = draftModalDefaultTitle;
          }
        }
      }
    });
  });

  // 2. On "Close" from Intro Modal, show Instruction Modal
  const closeIntroBtn = document.getElementById("closeIntroBtn");
  const introConsentCheckboxes = document.querySelectorAll(".intro-consent-checkbox");

  const updateIntroCloseState = () => {
    if (!closeIntroBtn) return;
    const allChecked = Array.from(introConsentCheckboxes).every(cb => cb.checked);
    closeIntroBtn.disabled = !allChecked;
    closeIntroBtn.classList.toggle("disabled", !allChecked);
  };

  if (introConsentCheckboxes.length > 0) {
    introConsentCheckboxes.forEach(cb => cb.addEventListener("change", updateIntroCloseState));
    updateIntroCloseState();
  }

  if (closeIntroBtn) {
    closeIntroBtn.addEventListener("click", () => {
      introModal.hide();
    });
  }
  
  // 3. On "Proceed" from Instruction Modal, show Voter Modal
  if (instructionModal) {
    const proceedInstructionBtn = document.getElementById("instructionProceedBtn");
    if (proceedInstructionBtn) {
      proceedInstructionBtn.addEventListener("click", () => {
        instructionModal.hide();
        setTimeout(() => voterModal.show(), 400);
      });
    }
  }

  const proceedBtn = document.querySelector(".proceed-button");
  if (proceedBtn) {
    proceedBtn.addEventListener("click", showVoterVerificationModal);
  }
  const forgotCodeLink = document.getElementById("forgotCodeLink");
  if (forgotCodeLink) {
    forgotCodeLink.addEventListener("click", (e) => {
      e.preventDefault();
      existingVoterModal.hide();
      forgotModal.show();
    });
  }
  // 4. Auto-redirect new voter to category.html after modal shows
  const newVoterModalElShow = document.getElementById("newVoterModal");
  if (newVoterModalElShow) {
    newVoterModalElShow.addEventListener("shown.bs.modal", () => {
      setTimeout(() => {
        localStorage.removeItem("currentIndexModal");
        window.location.href = "qr_selected_category.php?choice_id=" + localStorage.getItem("qr_choice_id");
      }, 2000);
    });
  }

sendOtpBtn?.addEventListener("click", async () => {
  if (isSendingOtp) return;
  isSendingOtp = true;

  const mobile = otpMobileInput.value.trim();
  otpMessage.style.display = "block";

  if (!/^09\d{9}$/.test(mobile)) {
    otpMessage.innerHTML = `<span class="text-danger">Enter a valid mobile number in 09XXXXXXXXX format.</span>`;
    isSendingOtp = false;
    return;
  }
  // Check if reCAPTCHA has valid response
  const response = grecaptcha.getResponse(window.recaptchaVerifier?.grecaptchaWidgetId);
  if (!response) {
    otpMessage.innerHTML = `<span class="text-danger">Please solve the reCAPTCHA first.</span>`;
    isSendingOtp = false;
    return;
  }

  otpMessage.innerHTML = `<span class="text-muted">Sending OTP...</span>`;
  sendOtpBtn.disabled = true;

  try {
    const fullPhone = "+63" + mobile.slice(1);

    const confirmationResult = await firebase.auth().signInWithPhoneNumber(fullPhone, window.recaptchaVerifier);
    window.confirmationResult = confirmationResult;

    otpMessage.innerHTML = `<span class="text-success">OTP sent to ${mobile}</span>`;
    otpSentToMobileMessage.textContent = `OTP sent to ${mobile}`;
    otpStep1.classList.add("d-none");
    otpStep2.classList.remove("d-none");

    localStorage.setItem("otp_mobile", mobile);
    localStorage.setItem("currentIndexModal", "otpModal");
    localStorage.setItem("otpStep", "2");
  } catch (error) {
    console.error("OTP sending failed:", error);
    otpMessage.innerHTML = `<span class="text-danger">Failed to send OTP: ${error.message}</span>`;
    sendOtpBtn.disabled = false;
    if (error.code === "auth/invalid-app-credential" || error.code === "auth/missing-app-credential") {
      initRecaptcha(true);
    }
  } finally {
    isSendingOtp = false;
  }
});

sendForgotOtpBtn?.addEventListener("click", async () => {
  const mobile = forgotMobileInput.value.trim();
  if (forgotMessage) {
    forgotMessage.innerHTML = "";
    forgotMessage.style.display = "block";
  }

  if (!/^09\d{9}$/.test(mobile)) {
    if (forgotMessage) {
      forgotMessage.innerHTML = `<span class="text-danger">Enter a valid mobile number in 09XXXXXXXXX format.</span>`;
    }
    showToast("Enter a valid mobile number.", "danger");
    return;
  }

  try {
    const statusRes = await fetch("check_has_draft.php", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ mobile_number: mobile })
    });
    const statusData = await statusRes.json();
    if (statusData.status !== "has_draft") {
      if (forgotMessage) {
        forgotMessage.innerHTML = `<span class="text-danger">No access code found for this mobile number.</span>`;
      }
      showToast("No access code found for this mobile number.", "danger");
      return;
    }
  } catch (err) {
    console.error("Draft check failed:", err);
    showToast("Error checking access code.", "danger");
    return;
  }

  let recaptchaSolved = false;
  try {
    if (window.forgotRecaptchaVerifier && typeof grecaptcha !== "undefined") {
      const widgetId = window.forgotRecaptchaVerifier.grecaptchaWidgetId;
      if (widgetId !== undefined) {
        const resp = grecaptcha.getResponse(widgetId);
        recaptchaSolved = resp && resp.length > 0;
      }
    }
  } catch (e) {
    recaptchaSolved = false;
  }

  if (!recaptchaSolved) {
    if (forgotMessage) {
      forgotMessage.innerHTML = `<span class="text-danger">Please solve the reCAPTCHA first.</span>`;
    }
    showToast("Please solve the reCAPTCHA first.", "danger");
    return;
  }

  sendForgotOtpBtn.disabled = true;
  const sendText = sendForgotOtpBtn.querySelector("span:nth-child(2)");
  if (sendForgotOtpSpinner) sendForgotOtpSpinner.classList.remove("d-none");
  if (sendText) sendText.textContent = "Sending...";

  try {
    const fullPhone = "+63" + mobile.slice(1);
    const confirmationResult = await firebase.auth().signInWithPhoneNumber(fullPhone, window.forgotRecaptchaVerifier);
    window.forgotConfirmationResult = confirmationResult;
    if (forgotMessage) {
      forgotMessage.innerHTML = `<span class="text-success">OTP sent to ${mobile}</span>`;
    }
    if (forgotOtpSentToMobileMessage) {
      forgotOtpSentToMobileMessage.textContent = `OTP sent to ${mobile}`;
    }
    forgotStep1?.classList.add("d-none");
    forgotStep2?.classList.remove("d-none");
    localStorage.setItem("forgot_mobile", mobile);
  } catch (error) {
    console.error("OTP sending failed:", error);
    if (forgotMessage) {
      forgotMessage.innerHTML = `<span class="text-danger">Failed to send OTP: ${error.message}</span>`;
    }
    showToast("Failed to send OTP.", "danger");
    sendForgotOtpBtn.disabled = false;
  } finally {
    if (sendForgotOtpSpinner) sendForgotOtpSpinner.classList.add("d-none");
    if (sendText) sendText.textContent = "Send OTP";
  }
});

  verifyOtpBtn?.addEventListener("click", async () => {
    const code = otpCodeInput.value.trim();
    const mobile = otpMobileInput.value.trim();
    if (!code) {
      if (otpVerifyMessage) {
        otpVerifyMessage.innerHTML = `<span class="text-danger">Please enter the OTP code.</span>`;
        otpVerifyMessage.style.display = "block";
      }
      return;
    }

    verifyOtpBtn.disabled = true;
    const originalText = verifyOtpBtn.textContent;
    verifyOtpBtn.textContent = "Verifying...";

  try {
      const result = await window.confirmationResult.confirm(code); // Firebase OTP check
      const idToken = await result.user.getIdToken(); // Optional: for token-based auth
      const mobile = otpMobileInput.value.trim();
      const response = await fetch("register_new_voter.php", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ mobile_number: mobile })
      });

      const data = await response.json();

      if (response.ok && data.status === "success") {
        localStorage.setItem("otp_mobile", mobile);
        localStorage.setItem("voter_mobile", mobile);
        localStorage.setItem("voter_id", data.voter_id);
        localStorage.setItem("voter_type", "new");

        otpModal.hide();
        if (draftModalTitleEl) {
          draftModalTitleEl.textContent = draftModalDefaultTitle;
        }
        draftCodeModal.show();
        localStorage.setItem("currentIndexModal", "draftCodeModal");
        localStorage.removeItem("otpStep");

        bindSaveDraftButton(() => {
          draftCodeModal.hide();
          newVoterModal.show();
        });
      } else {
        const msg = data.message || "Failed to register. Please try again.";
        if (otpVerifyMessage) {
          otpVerifyMessage.innerHTML = `<span class='text-danger'>${msg}</span>`;
          otpVerifyMessage.style.display = "block";
        }
      }
    } catch (err) {
      console.error("OTP verification failed:", err);
      if (otpVerifyMessage) {
        otpVerifyMessage.innerHTML = "<span class='text-danger'>Failed to verify. Please try again.</span>";
        otpVerifyMessage.style.display = "block";
      }
    } finally {
      verifyOtpBtn.disabled = false;
      verifyOtpBtn.textContent = originalText;
    }
  });

  verifyForgotOtpBtn?.addEventListener("click", async () => {
    const code = forgotOtpCodeInput.value.trim();
    if (forgotVerifyMessage) {
      forgotVerifyMessage.innerHTML = "";
      forgotVerifyMessage.style.display = "none";
    }
    if (!code) {
      if (forgotVerifyMessage) {
        forgotVerifyMessage.innerHTML = `<span class="text-danger">Please enter the OTP code.</span>`;
        forgotVerifyMessage.style.display = "block";
      }
      return;
    }

    const verifyText = verifyForgotOtpBtn.querySelector("span:nth-child(2)");
    if (!window.forgotConfirmationResult) {
      if (forgotVerifyMessage) {
        forgotVerifyMessage.innerHTML = `<span class="text-danger">Please request a new OTP first.</span>`;
        forgotVerifyMessage.style.display = "block";
      }
      verifyForgotOtpBtn.disabled = false;
      if (verifyForgotOtpSpinner) verifyForgotOtpSpinner.classList.add("d-none");
      if (verifyText) verifyText.textContent = "Verify OTP";
      return;
    }

    verifyForgotOtpBtn.disabled = true;
    if (verifyForgotOtpSpinner) verifyForgotOtpSpinner.classList.remove("d-none");
    if (verifyText) verifyText.textContent = "Verifying...";

    try {
      const result = await window.forgotConfirmationResult.confirm(code);
      const firebasePhone = result?.user?.phoneNumber || "";
      let verifiedMobile = "";

      if (firebasePhone.startsWith("+63")) {
        const digitsOnly = firebasePhone.replace(/\D/g, "");
        if (digitsOnly.startsWith("63") && digitsOnly.length === 12) {
          verifiedMobile = "0" + digitsOnly.slice(2);
        }
      } else if (/^09\d{9}$/.test(firebasePhone)) {
        verifiedMobile = firebasePhone;
      }

      if (!verifiedMobile) {
        const storedForgotMobile = localStorage.getItem("forgot_mobile") || "";
        if (/^09\d{9}$/.test(storedForgotMobile)) {
          verifiedMobile = storedForgotMobile;
        }
      }

      if (!/^09\d{9}$/.test(verifiedMobile)) {
        throw new Error("missing-verified-mobile");
      }

      localStorage.setItem("forgot_mobile", verifiedMobile);
      localStorage.setItem("otp_mobile", verifiedMobile);
      localStorage.setItem("voter_mobile", verifiedMobile);
      forgotModal.hide();
      if (draftModalTitleEl) {
        draftModalTitleEl.textContent = "Reset Access Code";
      }
      draftCodeModal.show();
      bindSaveDraftButton(() => {
        draftCodeModal.hide();
        showToast("Access code reset successfully. Please login with your new code.", "success");
        existingVoterModal.show();
      });
    } catch (err) {
      console.error("OTP verification failed:", err);
      const errorMsg = err?.message === "missing-verified-mobile"
        ? "<span class='text-danger'>We couldn't confirm your verified mobile number. Please restart the reset process.</span>"
        : "<span class='text-danger'>Failed to verify. Please try again.</span>";
      if (forgotVerifyMessage) {
        forgotVerifyMessage.innerHTML = errorMsg;
        forgotVerifyMessage.style.display = "block";
      }
      if (err?.message === "missing-verified-mobile") {
        showToast("Unable to confirm your mobile number. Please restart the reset process.", "danger");
      }
    } finally {
      verifyForgotOtpBtn.disabled = false;
      if (verifyForgotOtpSpinner) verifyForgotOtpSpinner.classList.add("d-none");
      if (verifyText) verifyText.textContent = "Verify OTP";
    }
  });

  otpMobileInput?.addEventListener("input", updateSendOtpState);
  forgotMobileInput?.addEventListener("input", updateSendForgotOtpState);
  window.recaptchaCallback = function () { handleRecaptchaSolved(); };
  window.onSummaryRecaptchaExpired = function () {
    console.log("reCAPTCHA expired");
    initRecaptcha(true);
    if (sendOtpBtn) sendOtpBtn.disabled = true;
    if (otpMessage) {
      otpMessage.innerHTML = "<span class='text-danger'>reCAPTCHA expired. Please try again.</span>";
      otpMessage.style.display = "block";
    }
    updateSendOtpState();
  };
  window.onSummaryRecaptchaError = function () {
    console.error("reCAPTCHA error");
    initRecaptcha(true);
    if (sendOtpBtn) sendOtpBtn.disabled = true;
    if (otpMessage) {
      otpMessage.innerHTML = "<span class='text-danger'>reCAPTCHA error. Please try again.</span>";
      otpMessage.style.display = "block";
    }
    updateSendOtpState();
  };

const checkDraftBtn = document.getElementById("checkDraftBtn");
if (checkDraftBtn) {
checkDraftBtn.addEventListener("click", () => {
  const mobile = document.getElementById("existingMobile").value.trim();
  const draftCode = document.getElementById("draftCode").value.trim();
  const errorDisplay = document.getElementById("loginError");

  // Validate mobile format and draft code
  if (!mobile.match(/^09\d{9}$/) || draftCode.length !== 4) {
    errorDisplay.textContent = "Invalid mobile number or draft code.";
    errorDisplay.style.display = "block";
    return;
  }

  // Call backend to verify voter and get unanswered questions
  fetch("verify_existing.php", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ mobile_number: mobile, draft_code: draftCode })
  })
    .then(res => res.json())
    .then(data => {
      if (data.status === "success") {
        localStorage.setItem("verified_mobile", mobile);
        localStorage.setItem("draft_code", draftCode);
        localStorage.setItem("voter_id", data.voter_info.voters_id);
        localStorage.setItem("voter_type", "existing");

        const unanswered = data.unanswered_questions || [];
        localStorage.setItem("unanswered", JSON.stringify(unanswered));

        // Extract and store category IDs
        const categoryIds = [...new Set(unanswered.map(q => q.category_id))];
        localStorage.setItem("unanswered_categories", JSON.stringify(categoryIds));

        // Group unanswered questions by category
        const grouped = unanswered.reduce((acc, q) => {
          if (!acc[q.category_id]) acc[q.category_id] = [];
          acc[q.category_id].push(q);
          return acc;
        }, {});

        // Find first category with at least one unanswered question
        const firstValidCategory = Object.keys(grouped).find(catId => grouped[catId].length > 0);

        // Redirect based on answered categories and completion status
        if (data.completion_status === "completed") {
          alert("Your voting process is complete from Tatak Ormoc Consumers’ Choice Awards. Thank you for your participation!");
          localStorage.removeItem("currentIndexModal");
          localStorage.clear();
        } else if (firstValidCategory) {
          localStorage.removeItem("currentIndexModal");
          window.location.href = "qr_selected_category.php?choice_id=" + localStorage.getItem("qr_choice_id");
        } else {
          localStorage.removeItem("currentIndexModal");
          window.location.href = "summarypoll.php";
        }
      } else {
        errorDisplay.textContent = "Incorrect credentials or no draft found.";
        errorDisplay.style.display = "block";
      } 
    })
    .catch(() => {
      errorDisplay.textContent = "Something went wrong. Try again.";
      errorDisplay.style.display = "block";
      });
    });
  }

  // 5. Bind save draft button
  const saveDraftCodeBtn = document.getElementById("saveDraftCodeBtn");
  if (saveDraftCodeBtn) {
    bindSaveDraftButton(() => {
      newVoterModal.show();
      localStorage.removeItem("currentIndexModal");
    });
  }

  function bindSaveDraftButton(callback) {
    const saveDraftBtn = document.getElementById("saveDraftCodeBtn");
    const draftInput = document.getElementById("draftCodeInput");
    const draftConfirmInput = document.getElementById("draftCodeConfirmInput");
    const errorDisplay = document.getElementById("draftCodeError");

    saveDraftBtn?.addEventListener("click", async () => {
      const code = draftInput.value.trim();
      const confirm = draftConfirmInput.value.trim();

      if (!/^\d{4}$/.test(code) || code !== confirm) {
        errorDisplay.classList.remove("d-none");
        return;
      }

      errorDisplay.classList.add("d-none");
      const mobile = localStorage.getItem("otp_mobile") || localStorage.getItem("voter_mobile");

      try {
        const res = await fetch("save_draft_code.php", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ mobile, draft_code: code })
        });
        const result = await res.json();

        if (result.status === "success") {
          localStorage.setItem("draft_code", code);
          if (typeof callback === "function") callback();
        } else {
          alert(result.message || "Sorry, we couldn't save the draft code.");
        }
      } catch (err) {
        console.error("Error saving draft code:", err);
        alert("Oops! Something went wrong while saving your draft code.");
      }
    });
  }
  // 6. Apply dynamic styling from DB
  fetch("get_voter_style.php")
    .then(res => res.json())
    .then(data => {
      document.body.style.backgroundColor = data.bgColor;
      document.body.style.color = data.textColor;
      document.body.style.fontSize = data.fontSize;

      const headerLogo = document.getElementById("headerLogo");
      if (headerLogo) headerLogo.src = data.headerLogo;
    });

  // 7. Fallback toggle (optional legacy)
  const existingVoterBtn = document.getElementById("existingVoterBtn");
  if (existingVoterBtn) {
    existingVoterBtn.addEventListener("click", () => {
      const q = document.getElementById("voterQuestion");
      const s = document.getElementById("existingVoterSection");
      if (q) q.style.display = "none";
      if (s) s.style.display = "block";
    });
  }
});

</script>
<div class="toast-container position-fixed top-0 start-50 translate-middle-x p-3">
  <div id="validationToast" class="toast text-bg-info" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="d-flex">
      <div class="toast-body"></div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
  </div>
</div>
<script language='javascript' type='text/javascript'>
function DisableBackButton() {
window.history.forward()
}
DisableBackButton();
window.onload = DisableBackButton;
window.onpageshow = function(evt) { if (evt.persisted) DisableBackButton() }
window.onunload = function() { void (0) }
</script>

</body>
</html>