
<?php
require_once '../tocca_admin/db_connection.php';
require_once '../tocca_admin/get_logo.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Tatak Ormoc Consumers’ Choice Awards 2024</title>
  <link rel="icon" type="image/png" href="<?php echo $faviconPath; ?>">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <link rel="stylesheet" href="css/user-style.css" />
  <style>
    .footer {
      padding: clamp(1rem, 2vw, 1.5rem) 1rem;
      font-size: clamp(0.72rem, 1.5vw, 0.9rem);
      line-height: 1.4;
    }

    .footer-content {
      display: flex;
      flex-wrap: wrap;
      gap: clamp(0.5rem, 1.5vw, 1rem);
      justify-content: center;
      align-items: center;
      text-align: center;
    }

    .footer-section {
      flex: 1 1 100%;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: clamp(0.3rem, 1vw, 0.5rem);
      color: inherit;
    }

    .footer-text,
    .footer-link {
      color: inherit;
      display: inline-flex;
      align-items: center;
      gap: clamp(0.3rem, 1vw, 0.5rem);
    }

    .footer-link {
      text-decoration: none;
    }

    .footer-link:hover {
      text-decoration: underline;
    }

    .footer-separator {
      color: inherit;
      display: none;
    }

    .footer-links {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      align-items: center;
      gap: clamp(0.35rem, 1.2vw, 0.6rem);
    }

    .footer img {
      height: clamp(16px, 2vw, 22px);
      width: auto;
    }

    @media (min-width: 576px) {
      .footer-section {
        flex: 1 1 33%;
      }

      .footer-left,
      .footer-center,
      .footer-right {
        align-items: center;
        flex-direction: row;
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

      .footer-links {
        justify-content: flex-end;
      }

      .footer-separator {
        display: inline;
      }
    }

    @media (min-width: 768px) {
      .footer-content {
        justify-content: space-between;
      }

      .footer-section {
        flex: 1 1 auto;
      }
    }

    @media (max-width: 480px) {
      .footer-section {
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
      <img id="headerLogo" alt="TOCCA Header Image" class="header-logo" />
    </div>

    <div class="category-box">
      <h2>CATEGORY</h2>
      <p class="category-subtext text-white text-start fs-6 fw-light">Please select a category to begin voting:</p>
      <div class="category-list" id="categoryList"></div>
    </div>

    <div class="footer">
      <div class="footer-content">
        <div class="footer-section footer-left">
          <span class="footer-text">&copy; <?php echo date('Y'); ?> Tatak Ormoc Consumers&rsquo; Choice Awards</span>
        </div>
        <div class="footer-section footer-center">
          <span class="footer-text">STI College Ormoc <img class="footer-logo" src="img/sti.png" alt="STI Logo" /></span>
        </div>
        <div class="footer-section footer-right">
          <div class="footer-links">
            <a class="footer-link" href="privacy_policy.php">Privacy Policy</a>
            <span class="footer-separator" aria-hidden="true">&bull;</span>
            <a class="footer-link" href="terms_and_conditions.php">Terms &amp; Conditions</a>
          </div>
        </div>
      </div>
    </div>
  </div>

    <script src="category.js"></script>
    <script src="apply_voter_style.js"></script>
    <script src="toast.js"></script>

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
