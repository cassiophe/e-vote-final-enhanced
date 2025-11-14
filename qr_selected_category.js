import {
  finalizeQuestion,
  finalizeAllCategories,
  hasFinalizedVotes
} from './vote_finalization.js';

// Avoid fetching the entire catalog when finalizing from QR page
window.fetchAllCategoriesAndQuestions = async () => {};

// Apply voter UI styles
fetch('get_voter_style.php')
  .then(res => res.json())
  .then(data => {
    document.body.style.backgroundColor = data.bgColor;
    document.body.style.color = data.textColor;
    document.body.style.fontSize = data.fontSize;
    const headerLogo = document.getElementById('headerLogo');
    if (headerLogo && data.headerLogo) headerLogo.src = data.headerLogo;
  });

const voteAllBtn = document.getElementById('voteAllBtn');
const finishBtn = document.getElementById('finishBtn');
const openLegacyBtn = document.getElementById('openLegacyBtn');
const summaryContainer = document.getElementById('summaryContainer');
const voteCountText = document.getElementById('voteCountText');

let voterId = localStorage.getItem('voter_id') || null;
const name = localStorage.getItem('qr_business') || 'Unknown Business';
const currentChoiceId = localStorage.getItem('qr_choice_id');
const lastChoiceId = localStorage.getItem('qr_last_choice_id');
const otpMobileInput = document.getElementById('otpMobileInput');
localStorage.setItem('qr_last_choice_id', currentChoiceId);

let finalizedFromDB = JSON.parse(localStorage.getItem('finalizedFromDB') || '{}');

async function loadFinalizedAnswersFromDB() {
  const storedId = localStorage.getItem('voter_id');
  let eventId = localStorage.getItem('current_event_id');
  if (!storedId) return;
  if (!eventId) {
    eventId = '1';
    localStorage.setItem('current_event_id', eventId);
  }

  voterId = storedId;

  try {
    const resAns = await fetch('get_finalized_answers.php', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ voter_id: storedId, event_id: eventId })
    });
    const dataAns = await resAns.json();
    if (dataAns.status === 'success' && Array.isArray(dataAns.answers)) {
      dataAns.answers.forEach(q => {
        finalizedFromDB[parseInt(q)] = true;
      });
      localStorage.setItem('finalizedFromDB', JSON.stringify(finalizedFromDB));
    }
  } catch (err) {
    console.error('Failed to load finalized questions from DB', err);
  }
}

let total = 0;
let answered = 0;
let currentCategories = [];

// Set business display
const businessName = document.getElementById('businessName');
if (businessName) {
  businessName.textContent = name;
  businessName.style.color = '#010066';
}

// Load business questions and render them grouped
function loadBusinessQuestions() {
  const choiceId = localStorage.getItem('qr_choice_id');
  if (!choiceId) {
    summaryContainer.innerHTML = "<p class='text-danger'>Invalid business ID.</p>";
    return;
  }

  fetch(`get_business_questions.php?choice_id=${choiceId}`)
    .then(res => res.json())
    .then(data => {
      if (data.status === 'success' && Array.isArray(data.categories)) {
        currentCategories = data.categories;
        renderSummaryGrouped(data.categories);
      } else {
        summaryContainer.innerHTML = "<p class='text-danger'>No questions found for this business.</p>";
      }
    })
    .catch(err => {
      console.error('Error loading business questions:', err);
      summaryContainer.innerHTML = "<p class='text-danger'>Failed to load questions.</p>";
    });
}

// Render questions grouped by category
function renderSummaryGrouped(categories) {
  summaryContainer.innerHTML = '';
  const allAnswers = JSON.parse(localStorage.getItem('allCategoryAnswers') || '{}');
  const finalized = JSON.parse(localStorage.getItem('finalizedAnswers') || '{}');

  total = 0;
  answered = 0;

  categories.forEach(cat => {
    const questions = cat.questions;
    if (questions.length === 0) return;

    const section = document.createElement('div');
    section.className = 'category-box';

    const header = document.createElement('div');
    header.className = 'category-title mb-2 fs-5';
    header.textContent = cat.category_name;
    header.style.color = '#f7f7f7ff';
    section.appendChild(header);

    questions.forEach(q => {
      total++;
      const isAnswered = finalized[q.question_id] || finalizedFromDB[q.question_id];
      if (isAnswered) answered++;

      const questionDiv = document.createElement('div');
      questionDiv.className =
        'question-entry d-flex flex-column flex-sm-row align-items-center text-center text-sm-start gap-2 p-2 border rounded mb-2 bg-white';

      const questionLabel = document.createElement('div');
      questionLabel.className = 'text-dark flex-grow-1';
      questionLabel.textContent = q.question_name;

      const voteBtn = document.createElement('button');
      voteBtn.className =
        'btn btn-sm btn-outline-success w-100 w-sm-auto';
      voteBtn.textContent = isAnswered ? 'Voted' : 'Vote';
      voteBtn.disabled = !!isAnswered;

      voteBtn.addEventListener('click', async () => {
        const confirmed = confirm(`You are voting "${name}" for this award: "${q.question_name}". Confirm?`);
        if (!confirmed) return;

        storeAnswer(cat, q);
        await finalizeQuestion(q.question_id);
        loadBusinessQuestions();
      });

      const buttonGroup = document.createElement('div');
      buttonGroup.className = 'd-flex mt-2 mt-sm-0 ms-sm-auto';
      buttonGroup.appendChild(voteBtn);

      questionDiv.appendChild(questionLabel);
      questionDiv.appendChild(buttonGroup);
      section.appendChild(questionDiv);
    });

    summaryContainer.appendChild(section);
  });

  if (voteCountText) {
    voteCountText.textContent = `${answered} of ${total} awards answered`;
  }
  const percent = total ? Math.round((answered / total) * 100) : 0;
  const progressBar = document.getElementById('progressBarText');
  if (progressBar) {
    progressBar.style.width = `${percent}%`;
    progressBar.textContent = `${percent}% Complete`;
  }

  if (total > 0 && answered === total) {
    const msg = document.createElement('p');
    msg.className = 'text-center text-muted';
    msg.textContent = 'All awards for this establishment have already been voted.';
    summaryContainer.prepend(msg);
  }
}

function storeAnswer(cat, q) {
  const choiceId = parseInt(localStorage.getItem('qr_choice_id') || '0');
  const business = localStorage.getItem('qr_business') || '';
  const allAnswers = JSON.parse(localStorage.getItem('allCategoryAnswers') || '{}');

  if (!allAnswers[cat.category_id]) {
    allAnswers[cat.category_id] = { category_name: cat.category_name, selections: [] };
  }

  const sel = allAnswers[cat.category_id].selections;
  const entry = {
    question_id: q.question_id,
    question_name: q.question_name,
    choice_id: choiceId,
    manual_input: '',
    choice_text: business
  };
  const idx = sel.findIndex(s => s.question_id == q.question_id);
  if (idx !== -1) sel[idx] = { ...sel[idx], ...entry };
  else sel.push(entry);

  localStorage.setItem('allCategoryAnswers', JSON.stringify(allAnswers));
}

async function finalizeAllVotes() {
  if (!voteAllBtn) return;

  currentCategories.forEach(cat => {
    (cat.questions || []).forEach(q => storeAnswer(cat, q));
  });

  window.voteAllBtn = voteAllBtn;
  window.finishBtn = finishBtn;

  await finalizeAllCategories();
  loadBusinessQuestions();
}

window.addEventListener('DOMContentLoaded', async () => {
  if (!localStorage.getItem('voter_id')) {
    window.location.href = 'qr_vote.php';
    return;
  }
  await loadFinalizedAnswersFromDB();
  loadBusinessQuestions();
  voteAllBtn?.addEventListener('click', finalizeAllVotes);
  if (openLegacyBtn) {
    openLegacyBtn.addEventListener('click', () => {
      window.location.href = 'summarypoll.php';
    });
  }
});