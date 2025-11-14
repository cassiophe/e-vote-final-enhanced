import { allCategories, allQuestions } from './summary_data.js';
import { finalizeQuestion } from './vote_finalization.js';

const summaryContainer = document.getElementById('summaryContainer');
const finishBtn = document.getElementById('finishBtn');

export function updateCategoryProgress(barEl, voted, notVoted, total, textEl) {
  if (!barEl) return;
  const percent = total > 0 ? Math.round((voted / total) * 100) : 0;
  barEl.style.width = `${percent}%`;
  barEl.setAttribute('aria-valuenow', percent);
  barEl.setAttribute('aria-valuemin', '0');
  barEl.setAttribute('aria-valuemax', '100');
  const text = `${voted} voted / ${notVoted} not voted / ${total} total`;
  if (textEl) textEl.textContent = text;
}

export function renderSummary() {
  const allAnswers = JSON.parse(localStorage.getItem('allCategoryAnswers') || '{}');
  const finalized = JSON.parse(localStorage.getItem('finalizedAnswers') || '{}');
  const finalizedFromDB = JSON.parse(localStorage.getItem('finalizedFromDB') || '{}');
  const voterType = localStorage.getItem('voter_type') || 'new';
  const allUnanswered = JSON.parse(localStorage.getItem('unanswered') || '[]');

  summaryContainer.innerHTML = '';

  for (const cat of allCategories) {
    const questionsInCat = allQuestions.filter(q => q.category_id == cat.id);

    let questionsToRender = questionsInCat;
    if (voterType === 'existing') {
      const savedSelections = allAnswers[cat.id]?.selections || [];
      const hasContent =
        savedSelections.length > 0 ||
        questionsInCat.some(q => finalized[q.question_id] || finalizedFromDB[q.question_id]);

      const unansweredIds = new Set(allUnanswered.map(uq => uq.question_id));
      const hasUnanswered = questionsInCat.some(q => unansweredIds.has(q.question_id));

      if (!hasContent && !hasUnanswered) {
        continue;
      }
    }

    const section = document.createElement('div');
    section.className = 'accordion-item';

    const votedInCat = questionsInCat.filter(q =>
      finalized[q.question_id] === true || finalizedFromDB[q.question_id] === true
    ).length;
    const selections = allAnswers[cat.id]?.selections || [];

    let answeredNotFinal = 0;
    let unansweredCount = 0;

    questionsInCat.forEach(q => {
      const isFinal =
        finalized[q.question_id] === true ||
        finalizedFromDB[q.question_id] === true;
      if (isFinal) return;

      const saved = selections.find(sel => sel.question_id == q.question_id) || {};
      const hasAnswer =
        saved.choice_id ||
        saved.choice_text ||
        (saved.manual_input && saved.manual_input.trim() !== '');

      if (hasAnswer) answeredNotFinal++;
      else unansweredCount++;
    });

    const totalInCat = questionsInCat.length;
    const notVotedInCat = answeredNotFinal + unansweredCount;
    const headingId = `heading-${cat.id}`;
    const collapseId = `collapse-${cat.id}`;

    section.innerHTML = `
    <h2 class="accordion-header" id="${headingId}">
      <button class="accordion-button collapsed" type="button"
        data-bs-toggle="collapse" data-bs-target="#${collapseId}"
        aria-expanded="false" aria-controls="${collapseId}">

        <div class="summary-button-content d-flex flex-column flex-md-row justify-content-md-between align-items-md-center gap-2 w-100">
          <div class="category-title text-center text-md-start mb-2 mb-md-0">${cat.name}</div>

          <div class="progress-container w-100 flex-md-grow-1 d-flex justify-content-center">
            <div class="progress w-100" style="height: 26px;">
              <div class="progress-bar bg-success" role="progressbar" id="progressBar-${cat.id}" style="width: 0%;"></div>
              <span class="progress-text" id="progressText-${cat.id}">0 voted / 0 not voted / 0 total</span>
            </div>
          </div>
        </div>

      </button>
    </h2>

      <div id="${collapseId}" class="accordion-collapse collapse" aria-labelledby="${headingId}">
        <div class="accordion-body p-0">
          <ul class="list-group list-group-flush" id="questionList-${cat.id}"></ul>
        </div>
      </div>
    `;

    const ul = section.querySelector(`#questionList-${cat.id}`);

    const sortedQuestions = [...questionsToRender].sort((a, b) => {
      const status = q => {
        const isFinal =
          finalized[q.question_id] === true ||
          finalizedFromDB[q.question_id] === true;
        const saved =
          allAnswers[cat.id]?.selections?.find(
            sel => sel.question_id == q.question_id
          ) || {};
        const hasAnswer =
          saved.choice_id ||
          saved.choice_text ||
          (saved.manual_input && saved.manual_input.trim() !== '');
        if (!isFinal && hasAnswer) return 0;
        if (!isFinal && !hasAnswer) return 1;
        return 2;
      };
      return status(a) - status(b);
    });

    sortedQuestions.forEach(q => {
      const isFinalFromDB = finalizedFromDB[q.question_id] === true;
      const isFinalNow = finalized[q.question_id] === true;
      const isFinal = isFinalNow || isFinalFromDB;

      const saved = allAnswers[cat.id]?.selections?.find(sel => sel.question_id == q.question_id) || {};
      const hasAnswer =
        saved &&
        (saved.choice_id ||
         saved.choice_text ||
         (saved.manual_input && saved.manual_input.trim() !== ''));

      const li = document.createElement('li');
      li.className = 'list-group-item d-flex flex-column flex-sm-row align-items-center text-center text-sm-start';
      li.style.backgroundColor = '#ffffff';
      if (isFinal) {
        li.classList.add('border-success');
        li.classList.add('finalized-item');
      }

      const text = document.createElement('div');
      text.className = 'flex-grow-1';

      const questionRow = document.createElement('div');
      questionRow.className = 'd-flex justify-content-between align-items-center';

      const questionName = document.createElement('strong');
      questionName.textContent = q.question_name;
      questionRow.appendChild(questionName);

      if (isFinal) {
        const finalizedBadge = document.createElement('span');
        finalizedBadge.className = 'badge bg-success ms-2';
        finalizedBadge.textContent = 'Voted';
        questionRow.appendChild(finalizedBadge);
      } else if (hasAnswer) {
        const pendingBadge = document.createElement('span');
        pendingBadge.className = 'badge bg-warning text-dark ms-2';
        pendingBadge.textContent = 'Not Voted';
        questionRow.appendChild(pendingBadge);
      }

      const answerText = document.createElement('div');
      answerText.className = 'mt-1';

      if (!hasAnswer) {
        const answerSpan = document.createElement('span');
        answerSpan.className = 'text-danger';
        answerSpan.textContent = 'No Response';
        answerText.appendChild(answerSpan);
      } else if (!isFinal) {
        const answerSpan = document.createElement('span');
        answerSpan.className = 'text-dark';
        answerSpan.textContent =
          saved.manual_input || saved.choice_text || `Choice #${saved.choice_id}`;
        answerText.appendChild(answerSpan);
      } else {
        const answerSpan = document.createElement('span');
        answerSpan.className = 'text-dark';
        answerSpan.textContent =
          saved.manual_input || saved.choice_text || `Choice #${saved.choice_id}`;
        answerText.appendChild(answerSpan);
      }

      text.appendChild(questionRow);
      text.appendChild(answerText);
      li.appendChild(text);

      if (!isFinal && !window.isFinalized) {
        const buttonGroup = document.createElement('div');
        buttonGroup.className = 'd-flex gap-2 mt-2 mt-sm-0';

        const editBtn = document.createElement('button');
        editBtn.className = 'btn btn-sm btn-outline-primary';
        editBtn.textContent = 'Edit';
        editBtn.onclick = () => {
          localStorage.setItem('edit_return', 'summarypoll.php');
          window.location.href = `selected-category.php?category_id=${cat.id}&edit_question=${q.question_id}`;
        };

        const voteBtn = document.createElement('button');
        voteBtn.className = 'btn btn-sm btn-outline-success';
        voteBtn.textContent = 'Vote';
        voteBtn.onclick = async () => {
          if (!hasAnswer) {
            alert('Please provide a response before finishing.');
            return;
          }
          if (confirm("Cast this vote? This cannot be undone.")) {
            await finalizeQuestion(q.question_id);
            const collapseEl = document.getElementById(collapseId);
            if (collapseEl) {
              const bsCollapse = bootstrap.Collapse.getOrCreateInstance(collapseEl);
              bsCollapse.hide();
            }
          }
        };
        buttonGroup.appendChild(editBtn);
        buttonGroup.appendChild(voteBtn);
        li.appendChild(buttonGroup);
      }
      ul.appendChild(li);
    });

    summaryContainer.appendChild(section);
    const bar = section.querySelector(`#progressBar-${cat.id}`);
    const textEl = section.querySelector(`#progressText-${cat.id}`);
    updateCategoryProgress(bar, votedInCat, notVotedInCat, totalInCat, textEl);
  }
  if (window.isFinalized && finishBtn) finishBtn.style.display = 'none';
}

window.renderSummary = renderSummary;