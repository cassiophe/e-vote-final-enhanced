<?php
require_once '../tocca_admin/db_connection.php';
require_once '../tocca_admin/get_logo.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Submission Completed | Tatak Ormoc</title>
  <link rel="icon" type="image/png" href="<?php echo $faviconPath; ?>">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <link rel="stylesheet" href="css/user-style.css" />
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@700&display=swap" rel="stylesheet">

  <style>
    body{background-color:#dceafd;font-family:Arial,sans-serif;text-align:center;display:flex;justify-content:center;align-items:center;min-height:100vh;margin:0}
    .container-box{max-width:950px;margin:0 auto;padding:30px 20px}
    .header img{width:100%;height:auto;border-radius:12px}
    .thankyou-panel{background-color:#0e1171;color:#fff;padding:40px 20px;border-radius:12px;margin-top:25px}
    .thankyou-panel h1{font-size:36px;font-weight:bold;margin-bottom:15px}
    .thankyou-panel p{font-size:18px;margin:0}
    .chart-wrapper{display:flex;flex-direction:column;justify-content:center;align-items:center;flex-wrap:wrap;gap:14px}
    .chart-container{position:relative;width:min(140px,40vw);height:min(140px,40vw)}
    #voteChart{width:100%;height:100%}
    .chart-center-text{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);color:#fff;font-size:20px;font-weight:bold}
    .chart-legend{text-align:left}
    .legend-item{display:flex;align-items:center;margin-bottom:10px;border-radius:6px;padding:8px 12px;color:#fff;font-size:14px;white-space:nowrap}
    .legend-color{width:18px;height:18px;border-radius:3px;margin-right:10px;flex-shrink:0}
    .footer{margin-top:50px;padding:.75rem 1rem;font-size:14px;color:#18233F}
    .footer-content{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:.5rem;font-size:.75rem;line-height:1.2}
    .footer-section{display:flex;align-items:center;gap:.35rem;flex:1 1 160px;color:inherit;min-width:0}
    .footer-left{justify-content:flex-start;text-align:left}
    .footer-center{justify-content:center;text-align:center}
    .footer-right{justify-content:flex-end;text-align:right;flex-wrap:wrap;column-gap:.35rem;row-gap:.15rem}
    .footer-link{color:inherit;text-decoration:none;white-space:nowrap}
    .footer-link:hover{text-decoration:underline}
    .footer-logo{height:16px}
    .modal-title{color:#0e1171;font-family:'Poppins',Arial,sans-serif;font-weight:700;font-size:1.5rem;letter-spacing:.5px}
    @media (max-width:576px){
      .modal-title{font-size:1.15rem}
      .thankyou-panel h1{font-size:28px}
      .thankyou-panel p{font-size:16px}
      .chart-wrapper{flex-direction:row;justify-content:center;flex-wrap:nowrap;gap:14px}
      .chart-container{width:min(140px,40vw);height:min(140px,40vw)}
      .chart-center-text{font-size:16px}
      .legend-item{font-size:13px;padding:6px 10px;white-space:normal;max-width:140px}
      .footer{font-size:13px}
      .footer img{height:18px}
    }
    /* neat radio group */
    .fieldset{border:1px solid #dee2e6;border-radius:.5rem;padding:.75rem .95rem}
    .fieldset legend{font-size:.95rem;font-weight:600;margin:0 0 .25rem 0;width:auto;padding:0 .25rem}
    .help-dim{color:#6c757d;font-size:.875rem}
  </style>
</head>
<body>
  <div class="container-box">
    <div class="header">
      <img src="img/tocca2023.jpg" alt="TOCCA Header Image" />
    </div>

    <div class="thankyou-panel">
      <h1>Thank you!</h1>
      <p>Your vote for Tatak Ormoc 2024 Consumer's Choice Award is casted.</p>

<!-- Feedback Modal -->
<div class="modal fade" id="feedbackModal" tabindex="-1" aria-labelledby="feedbackModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <form id="feedbackForm" autocomplete="off">
        <div class="modal-header">
          <h5 class="modal-title" id="feedbackModalLabel">We Value Your Feedback!</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <textarea class="form-control" name="feedback" rows="4" placeholder="Share your experience..." required></textarea>

          <!-- Sender visibility -->
          <fieldset class="fieldset mt-3">
            <legend>Sender visibility</legend>
            <div class="form-check mb-1">
              <input class="form-check-input" type="radio" name="fbVisibility" id="fbAnon" value="1" checked>
              <label class="form-check-label" for="fbAnon">Submit as <strong>Anonymous</strong></label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="fbVisibility" id="fbShow" value="0">
              <label class="form-check-label" for="fbShow">Show my <strong>mobile number</strong> with this feedback</label>
            </div>
            <div class="help-dim mt-2">
              We only use this to label your feedback in the admin list. The vote itself remains private.
            </div>
          </fieldset>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-primary">Submit Feedback</button>
        </div>
      </form>
    </div>
  </div>
</div>

      <!-- Progress Title + Chart & Labels -->
      <div class="text-center mt-4">
        <h4 class="mb-3" style="color:#ffffff;">Your Progress</h4>
        <div class="chart-wrapper">
          <div class="chart-container">
            <canvas id="voteChart"></canvas>
            <div class="chart-center-text" id="chartCenterText">0%</div>
          </div>
          <div class="chart-legend text-start">
            <div class="legend-item voted" style="background-color:#3399ff;">
              <div class="legend-color" style="background-color:#3399ff;"></div>
              Casted: <strong class="ms-2">24</strong>
            </div>
            <div class="legend-item unanswered" style="background-color:#fbc02d;">
              <div class="legend-color" style="background-color:#fbc02d;"></div>
              Not Casted: <strong class="ms-2">0</strong>
            </div>
          </div>
        </div>
      </div>

      <p class="mt-4" style="color:#cbd2ff;font-size:16px;font-weight:500;">Login to vote again using your mobile number and access code.</p>
      <a href="index.php" style="color:#cbd2ff;text-decoration:underline;">Log in again</a>
    </div>

    <div class="footer">
      <div class="footer-content">
        <div class="footer-section footer-left"><span>© Tatak Ormoc 2024</span></div>
        <div class="footer-section footer-center">
          <a class="footer-link" href="privacy_policy.php">Privacy Policy</a>
          <span class="footer-separator" aria-hidden="true">&bull;</span>
          <a class="footer-link" href="terms_and_conditions.php">Terms &amp; Conditions</a>
        </div>
        <div class="footer-section footer-right">
          <span>STI College Ormoc</span>
          <img class="footer-logo" src="img/sti.png" alt="STI College Ormoc logo" />
        </div>
      </div>
    </div>
  </div>

  <script>
    // Confetti & chart (unchanged; trimmed for brevity)
    function launchConfetti(){const d=2000,end=Date.now()+d;(function f(){confetti({particleCount:4,angle:60,spread:55,origin:{x:0}});confetti({particleCount:4,angle:120,spread:55,origin:{x:1}});if(Date.now()<end)requestAnimationFrame(f)})();}
    let confettiLaunched=false;function maybeLaunchConfetti(p){if(!confettiLaunched&&p===100){launchConfetti();confettiLaunched=true;}}
    window.addEventListener('DOMContentLoaded',()=>{const stored=sessionStorage.getItem('signoutProgress');let answered=0,questionCount=0;if(stored){const d=JSON.parse(stored);answered=d.done||0;questionCount=d.questionCount||d.total||0}const unanswered=Math.max(questionCount-answered,0);const percent=questionCount?Math.round((answered/questionCount)*100):0;document.getElementById('chartCenterText').textContent=`${percent}%`;document.querySelector('.legend-item.voted strong').textContent=answered;document.querySelector('.legend-item.unanswered strong').textContent=unanswered;maybeLaunchConfetti(percent);const ctx=document.getElementById('voteChart').getContext('2d');new Chart(ctx,{type:'doughnut',data:{labels:['Voted','Unanswered'],datasets:[{data:[answered,unanswered],backgroundColor:['#3399ff','#fbc02d'],borderWidth:0}]},options:{cutout:'70%',responsive:true,maintainAspectRatio:true,plugins:{legend:{display:false},tooltip:{callbacks:{label:(c)=>`${c.label}: ${c.raw}`}}}}});});
    function DisableBackButton(){window.history.forward()}DisableBackButton();window.onload=DisableBackButton;window.onpageshow=function(e){if(e.persisted)DisableBackButton()};window.onunload=function(){void(0)}

    // Load progress info (unchanged)
    const mobileNumber = localStorage.getItem("otp_mobile");
    const eventId = localStorage.getItem("current_event_id");
    if (mobileNumber && eventId) {
      fetch(`get_voter_progress.php?mobile=${encodeURIComponent(mobileNumber)}&event_id=${eventId}`)
        .then(res=>res.json())
        .then(({answered,unanswered,percent})=>{
          document.getElementById("chartCenterText").textContent = `${percent}%`;
          document.querySelector(".legend-item.voted strong").textContent = answered;
          document.querySelector(".legend-item.unanswered strong").textContent = unanswered;
        });
    }
  </script>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="apply_voter_style.js"></script>
  <script src="toast.js"></script>
  <script src="progress_helper.js"></script>

  <script>
  document.addEventListener('DOMContentLoaded', function() {
    // Show modal if this voter hasn’t left feedback yet
    setTimeout(() => {
      const voters_id = localStorage.getItem("voter_id") || sessionStorage.getItem("voter_id");
      const event_id = localStorage.getItem("current_event_id") || sessionStorage.getItem("current_event_id");
      if (voters_id && event_id) {
        fetch(`check_feedback.php?voters_id=${encodeURIComponent(voters_id)}&event_id=${encodeURIComponent(event_id)}`)
          .then(r=>r.json())
          .then(data => { if (!data.hasFeedback) new bootstrap.Modal('#feedbackModal').show(); })
          .catch(console.error);
      }
    }, 900);

    // Submit feedback (includes visibility radio)
    document.getElementById('feedbackForm').addEventListener('submit', function(e) {
      e.preventDefault();
      const ta = document.querySelector('[name="feedback"]');
      const feedback = ta.value.trim();
      if (!feedback) { alert('Please enter your feedback.'); return; }

      const voters_id = localStorage.getItem("voter_id") || sessionStorage.getItem("voter_id");
      const event_id  = localStorage.getItem("current_event_id") || sessionStorage.getItem("current_event_id");
      if (!voters_id || !event_id) { alert('Voter ID and Event ID are required.'); return; }

      const isAnon = document.querySelector('input[name="fbVisibility"]:checked')?.value ?? '1';

      const params = new URLSearchParams();
      params.set('feedback', feedback);
      params.set('voters_id', voters_id);
      params.set('event_id', event_id);
      params.set('is_anonymous', isAnon);        // NEW

      fetch('save_feedback.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params.toString(),
        credentials: 'same-origin'
      })
      .then(r=>r.text())
      .then(txt=>{
        if (txt.trim()==='success') {
          alert('Thank you for your feedback!');
          bootstrap.Modal.getInstance(document.getElementById('feedbackModal')).hide();
          // clear stored ids after submitting
          localStorage.removeItem("voter_id");
          localStorage.removeItem("current_event_id");
          sessionStorage.removeItem("voter_id");
          sessionStorage.removeItem("current_event_id");
          ta.value='';
        } else {
          alert('Failed to save feedback: ' + txt);
        }
      })
      .catch(err=>alert('Network error: ' + err.message));
    });

    // Clear ids if modal closed without submit
    document.getElementById('feedbackModal').addEventListener('hidden.bs.modal', function () {
      localStorage.removeItem("voter_id");
      localStorage.removeItem("current_event_id");
      sessionStorage.removeItem("voter_id");
      sessionStorage.removeItem("current_event_id");
    });
  });
  </script>
</body>
</html>
