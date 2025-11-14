<?php
require_once '../tocca_admin/db_connection.php';
require_once '../tocca_admin/get_logo.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Summary of Your Votes | Tatak Ormoc</title>
  <link rel="icon" type="image/png" href="<?php echo $faviconPath; ?>">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <link rel="stylesheet" href="css/user-style.css" />

  <style>
    .footer {
      padding: clamp(1rem, 2vw, 1.5rem) 1rem;
      background-color: #f8f9fa;
      color: #212529;
      font-size: clamp(0.72rem, 1.5vw, 0.9rem);
      line-height: 1.4;
    }

    .footer-content {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
      gap: clamp(0.6rem, 1.6vw, 1rem);
    }

    .footer-section {
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      text-align: center;
      color: inherit;
      gap: clamp(0.35rem, 1.2vw, 0.5rem);
    }

    .footer-text,
    .footer-link {
      color: inherit;
      display: inline-flex;
      align-items: center;
      gap: clamp(0.3rem, 1vw, 0.45rem);
    }

    .footer-link {
      text-decoration: none;
      transition: color 0.2s ease-in-out;
      white-space: nowrap;
    }

    .footer-link:hover,
    .footer-link:focus-visible {
      text-decoration: underline;
      color: #0d6efd;
      outline: none;
    }

    .footer-logo {
      height: clamp(16px, 2vw, 20px);
      width: auto;
    }

    .footer-links {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      align-items: center;
      gap: clamp(0.35rem, 1.2vw, 0.6rem);
      list-style: none;
      padding: 0;
      margin: 0;
    }

    .footer-links li {
      display: inline-flex;
      align-items: center;
      gap: clamp(0.35rem, 1.2vw, 0.6rem);
    }

    .footer-links li + li::before {
      content: "\2022";
      color: inherit;
    }

    @media (min-width: 768px) {
      .footer {
        padding-left: 3rem;
        padding-right: 3rem;
      }

      .footer-section {
        flex-direction: row;
        text-align: initial;
      }

      .footer-left {
        justify-content: flex-start;
        align-items: flex-start;
        text-align: left;
      }

      .footer-center {
        justify-content: center;
        align-items: center;
        text-align: center;
      }

      .footer-right {
        justify-content: flex-end;
        align-items: flex-end;
        text-align: right;
      }

      .footer-links {
        justify-content: flex-end;
      }
    }

    @media (max-width: 480px) {
      .footer {
        text-align: center;
      }

      .footer-links {
        justify-content: center;
      }
    }
  </style>
</head>
<body>
  <div class="category-layout-container">
    <div class="header">
      <img id="headerLogo" src="img/tocca2023.jpg" alt="TOCCA Header Image" class="header-logo" />
    </div>

    <div class="category-box">
      <h2>SUMMARY</h2>
      <p class="category-subtext text-white text-left fs-6 fw-light">
        Please review your votes below before submitting:
      </p>
    </div>

    <div class="container my-3">
      <div class="d-flex justify-content-between align-items-center mb-3">
        <button id="backToCategoriesBtn" class="btn btn-outline-secondary">← Back to Categories</button>
        <button id="signOutBtn" class="btn btn-outline-danger" data-bs-toggle="modal">Sign Out</button> 
      </div>

      <div id="summaryContainer" class="accordion category-panel mb-4"></div>
    </div>

    <div class="d-flex mt-3 mb-4 flex-column flex-sm-row align-items-center gap-2 justify-content-center button-group-summary text-center">
      <button id="voteAllBtn" class="btn btn-success btn-custom mb-2">Vote All</button>
    </div>
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
          <ul class="footer-links">
            <li><a class="footer-link" href="#">Privacy Policy</a></li>
            <li><a class="footer-link" href="#">Terms &amp; Conditions</a></li>
          </ul>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="apply_voter_style.js"></script>
  <script src="toast.js"></script>
  <script src="progress_helper.js"></script>
  <script src="signout.js"></script>
  <script type="module" src="summary_data.js"></script>
  <script type="module" src="vote_finalization.js"></script>
  <script type="module" src="summary_renderer.js"></script>
  <script type="module" src="summarypoll.js"></script>

  <div class="modal fade" id="confirmSignOutModal" tabindex="-1" aria-labelledby="confirmSignOutLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="confirmSignOutLabel">Confirm Sign Out</h5>
        </div>
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
    function DisableBackButton() {
      window.history.forward();
    }
    DisableBackButton();
    window.onload = DisableBackButton;
    window.onpageshow = function(evt) {
      if (evt.persisted) DisableBackButton();
    };
    window.onunload = function() { void 0; };
  </script>
</body>
</html>
