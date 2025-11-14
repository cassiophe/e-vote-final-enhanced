<?php
require_once '../tocca_admin/db_connection.php';
require_once '../tocca_admin/get_logo.php';

$event_id = $_GET['event_id'] ?? 1;
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vote | Tatak Ormoc</title>
    <link rel="icon" type="image/png" href="<?php echo $faviconPath; ?>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/choices.js/public/assets/styles/choices.min.css"/>
    <link rel="stylesheet" href="css/user-style.css">
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
        
        .footer-logo {
            height: clamp(16px, 2vw, 22px);
            width: auto;
        }

        .footer-separator {
            display: none;
        }

        @media (min-width: 576px) {
            .footer-content {
                flex-direction: row;
                justify-content: space-between;
                width: 100%;
            }

            .footer-section {
                flex: 1 1 33%;
                flex-direction: row;
                align-items: center;
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
    <script>
        localStorage.setItem('current_event_id', '<?php echo $event_id; ?>');
    </script>
</head>

<body>

    <main class="container my-4">

        <header class="header text-center mb-4">
            <img id="headerLogo" alt="TOCCA Header Image" class="header-logo img-fluid">
        </header>

        <div class="category-header-panel mb-4">
            <h2 class="text-center mb-2 fw-bold text-uppercase" id="selectedCategoryTitle">CATEGORY NAME</h2>
            <p class="text-center mb-3 fst-italic">Currently voting in this category. Use the dropdown below to change category.</p>

            <div class="row justify-content-center mb-3">
                <div class="col-md-8 col-lg-6">
                    <label for="categorySwitcher" class="form-label visually-hidden">Change Category:</label>
                    <select id="categorySwitcher" class="form-select form-select-lg" aria-label="Switch Category">
                    </select>
                </div>
           </div>
        </div>

        <div class="mb-4">
            <label for="questionSearchInput" class="form-label small text-muted d-block mb-1">Search Award Names in this Category:</label>
            <input type="search" id="questionSearchInput" class="form-control form-control-sm" placeholder="Type to filter award names..." disabled>
        </div>

        <div class="category-panel p-3 p-md-4 rounded shadow-sm mb-4" id="questionsContainer">
            <p class="text-center text-muted" id="initialMessage">Select a category to view award names.</p>
        </div>

        <div id="controls" class="mt-4 d-none">
            <div class="d-flex align-items-center flex-wrap gap-2 mb-4 nav-control-group w-100">
                <button class="btn btn-info btn-custom nav-btn ms-auto" id="toggleViewBtn">List View</button>
                <button id="submitVoteBtn" class="btn btn-success btn-custom nav-btn mx-auto">Proceed to Summary</button>
            </div>
        </div>

        <div id="pageControls" class="nav-control-group d-flex justify-content-between gap-2 mt-4 d-none">
            <button class="btn btn-prev btn-custom nav-btn" id="prevBtn"><i class="fas fa-arrow-left"></i> Previous</button>
            <button class="btn btn-next btn-custom nav-btn" id="nextBtn">Next <i class="fas fa-arrow-right"></i></button>
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
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>
    <script type="module" src="selected-category.js"></script>
    <script src="apply_voter_style.js"></script>

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
