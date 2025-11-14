<?php
include '../tocca_admin/db_connection.php';
require_once '../tocca_admin/get_logo.php';

function getConfig($key, $default = '') {
    global $conn;
    $stmt = $conn->prepare("SELECT config_value FROM tbl_config WHERE config_key = ?");
    $stmt->bind_param("s", $key);
    $stmt->execute();
    $stmt->bind_result($val);
    $out = $default;
    if ($stmt->fetch()) $out = $val;
    $stmt->close();
    return $out;
}

$banner = getConfig('voter_header_logo', 'img/tocca2023.jpg');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Voting Closed | Tatak Ormoc</title>
  <link rel="icon" type="image/png" href="<?php echo $faviconPath; ?>">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <style>
    :root {
      --accent: #dc3545;
      --muted:  #6c757d;
    }
    body {
      background-color: #f8f9fa;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    /* Banner at top */
    header {
      display: flex;
      justify-content: center;
      padding: 1rem 1rem 0.5rem;
    }
    /* Keep the banner centered and wide on desktop, fluid on mobile */
    .banner-wrap {
      width: min(95vw, 1200px); /* wide on web, never exceeds 1200px */
    }
    .tocca-banner {
      display: block;
      width: 100%;
      height: auto;              /* natural aspect ratio */
      object-fit: contain;
      /* Big on desktop, smaller on mobile:
         min = 120px, preferred = 22vw, max = 360px */
      max-height: clamp(120px, 22vw, 360px);
    }

    main {
      text-align: center;
      padding: 1.25rem 1rem 2rem;
    }
    /* Smaller than the banner */
    .message {
      font-weight: 700;
      color: var(--accent);
      line-height: 1.2;
      font-size: clamp(1.15rem, 2.6vw, 1.6rem);
      margin-top: 0.75rem;
      margin-bottom: 0.25rem;
    }
    .subtext {
      color: var(--muted);
      line-height: 1.5;
      font-size: clamp(0.95rem, 2.1vw, 1.1rem);
      margin: 0;
    }

    /* Extra polish on very small phones */
    @media (max-width: 360px) {
      header { padding-top: .75rem; }
      .message { margin-top: .5rem; }
    }
  </style>
</head>
<body>
  <header>
    <div class="banner-wrap">
      <img src="<?php echo htmlspecialchars($banner, ENT_QUOTES); ?>"
           alt="Tatak Ormoc Banner"
           class="tocca-banner" />
    </div>
  </header>

  <main>
    <h1 class="message">Voting is Currently Closed</h1>
    <p class="subtext">The voting period has ended or has not yet started. Please check back later.</p>
  </main>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
