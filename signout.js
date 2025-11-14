// Handles sign-out confirmation and logic

function escapeHtml(str = '') {
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

document.addEventListener('DOMContentLoaded', async () => {
  if (typeof window.fetchFinalizedAnswersFromDB === 'function') {
    await window.fetchFinalizedAnswersFromDB();
  }
  const signOutBtn = document.getElementById('signOutBtn');
  const confirmSignOutModalEl = document.getElementById('confirmSignOutModal');
  const confirmSignOutMessage = document.getElementById('confirmSignOutMessage');
  const confirmSignOutBtn = document.getElementById('confirmSignOutBtn');
  const confirmSignOutModal = confirmSignOutModalEl
    ? new bootstrap.Modal(confirmSignOutModalEl)
    : null;

 signOutBtn?.addEventListener('click', async (e) => {
    e.preventDefault();
    const progress = await getVotingProgress();
    const drafted = progress.drafted ?? 0;
    const remaining = progress.unanswered ?? Math.max((progress.questionCount ?? 0) - progress.done - drafted, 0);
    if (remaining === 0 && drafted === 0) {
      if (confirmSignOutMessage) {
        confirmSignOutMessage.innerHTML =
          '<strong>All your answers are voted.</strong> Are you sure you want to sign out?';
      }
      await handleSignOut();
      return;
    }
    const draftVoteText =
      drafted === 1
        ? '1 draft vote is waiting to be casted'
        : `${escapeHtml(drafted)} draft votes are waiting to be casted`;
    const message =
      `<strong>You still have ${escapeHtml(remaining)} remained unanswered</strong> ` +
      `<strong>and ${draftVoteText}.</strong> Are you sure you want to sign out?`;
    if (confirmSignOutMessage) confirmSignOutMessage.innerHTML = message;
    confirmSignOutModal?.show();
  });

  confirmSignOutBtn?.addEventListener('click', async () => {
    confirmSignOutModal?.hide();
    await handleSignOut();
  });
});

async function handleSignOut() {
  try {
    const progress = await getVotingProgress();
    sessionStorage.setItem('signoutProgress', JSON.stringify(progress));

    // Preserve voter_id and event_id in sessionStorage before clearing localStorage
    const voterId = localStorage.getItem('voter_id');
    const eventId = localStorage.getItem('current_event_id');
    if (voterId) sessionStorage.setItem('voter_id', voterId);
    if (eventId) sessionStorage.setItem('current_event_id', eventId);

    if (window.firebase?.auth) {
      await firebase.auth().signOut();
    }
    localStorage.clear();
    window.location.href = 'thankyou.php';
  } catch (err) {
    console.error('Sign out failed', err);
    if (typeof showToast === 'function') {
      showToast('Failed to sign out. Please try again.', 'danger');
    }
  }
}
