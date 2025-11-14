<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Terms and Conditions | Tatak Ormoc Consumers' Choice Awards</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>

<body class="bg-light">
  <main class="container py-5">
    <div class="row justify-content-center">
      <div class="col-lg-10 col-xl-8">
        <div class="card shadow-sm border-0">
          <div class="card-body p-4 p-md-5">
            <h1 class="h3 mb-4">Terms and Conditions</h1>
            <p class="text-muted mb-4">Effective Date: October 20, 2024</p>

            <p class="mb-4">These Terms and Conditions ("Terms") govern your participation in the Tatak Ormoc Consumers' Choice
              Awards ("TOCCA") online voting platform. By accessing and using this portal, you agree to comply with these
              Terms and all applicable laws and regulations.</p>

            <h2 class="h5 mt-5">1. Eligibility</h2>
            <ul>
              <li>You must be at least 18 years old and a resident, worker, or student of Ormoc City to cast a vote.</li>
              <li>Each voter must provide accurate identification details and successfully complete the verification
                process.</li>
              <li>TOCCA organizers reserve the right to verify voter eligibility and to disqualify votes that do not meet
                the official guidelines.</li>
            </ul>

            <h2 class="h5 mt-5">2. Voting Rules</h2>
            <ul>
              <li>Each verified voter is allowed to submit only one finalized ballot for the 2024 TOCCA.</li>
              <li>Votes must be submitted within the official voting period announced by the City Government of Ormoc.</li>
              <li>Automated tools, scripts, or any attempts to manipulate or tamper with the voting process are strictly
                prohibited.</li>
              <li>TOCCA organizers may invalidate any ballots suspected of fraud, duplication, or malicious intent.</li>
            </ul>

            <h2 class="h5 mt-5">3. Use of the Platform</h2>
            <ul>
              <li>You agree to use the online voting portal only for its intended purpose and in accordance with these
                Terms.</li>
              <li>You must not attempt to interfere with the proper functioning or security of the platform.</li>
              <li>Access credentials, draft codes, or OTPs provided to you must remain confidential and must not be shared
                with others.</li>
            </ul>

            <h2 class="h5 mt-5">4. Intellectual Property</h2>
            <p>All content, branding, and materials associated with TOCCA are owned by the City Government of Ormoc or its
              authorized partners. You may not copy, modify, reproduce, or distribute any portion of the platform without
              prior written consent.</p>

            <h2 class="h5 mt-5">5. Limitation of Liability</h2>
            <p>TOCCA organizers strive to keep the voting platform available and secure. However, we do not warrant that the
              service will be uninterrupted or error-free. To the fullest extent permitted by law, TOCCA and its partners
              are not liable for any damages arising from your use or inability to use the platform.</p>

            <h2 class="h5 mt-5">6. Suspension or Termination</h2>
            <p>We may suspend or terminate access to the voting portal for users who violate these Terms, attempt to
              compromise system security, or otherwise engage in conduct that undermines the integrity of the awards.</p>

            <h2 class="h5 mt-5">7. Changes to the Terms</h2>
            <p>TOCCA organizers may update these Terms as necessary. Any changes will be posted on this page with a new
              effective date. Continued use of the platform after updates constitutes acceptance of the revised Terms.</p>

            <h2 class="h5 mt-5">8. Governing Law</h2>
            <p>These Terms are governed by the laws of the Republic of the Philippines. Any disputes related to the voting
              platform shall be resolved in the appropriate courts of Ormoc City.</p>

            <h2 class="h5 mt-5">9. Contact Information</h2>
            <p>For inquiries about these Terms or the voting process, please reach out to the Tatak Ormoc Consumers' Choice
              Awards Organizing Committee through the City Government of Ormoc, Public Information Office.</p>

            <div class="mt-5">
              <button type="button" class="btn btn-primary" onclick="handleReturn()">Return to Previous Page</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>
    <script>
    function handleReturn() {
      if (document.referrer) {
        window.location.href = document.referrer;
        return;
      }

      if (window.history.length > 1) {
        window.history.back();
        return;
      }

      window.location.href = 'index.php';
    }
  </script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>