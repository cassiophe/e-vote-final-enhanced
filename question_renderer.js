import { state } from './state.js';

// local debounce utility
function debounce(fn, delay = 300) {
  let timeout;
  return (...args) => {
    clearTimeout(timeout);
    timeout = setTimeout(() => fn(...args), delay);
  };
}

// Escape potentially unsafe HTML characters. Question and category
// names come from the server and may contain characters that would be
// interpreted as HTML, breaking the display. Encoding them ensures they
// render exactly as provided.
function escapeHtml(str = '') {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

export function destroyQuestionChoiceInstances() {
  state.questionChoiceInstances.forEach(inst => {
    try { inst.destroy(); } catch (e) {}
  });
  state.questionChoiceInstances = [];
}

export function initializeQuestionDropdown(selectEl) {
  if (!selectEl) return;
  try {
    const instance = new Choices(selectEl, {
      searchEnabled: true,
      itemSelectText: '',
      shouldSort: false,
      allowHTML: false,
      searchPlaceholderValue: 'Search...'
    });
    state.questionChoiceInstances.push(instance);
    selectEl.choicesInstance = instance;
  } catch (err) {
    console.error('Failed to init dropdown:', err);
  }
}

export function updateFieldStates(selectEl, answerEl, estEl = null) {
  if (!answerEl) return;

  const isTextFocused =
    document.activeElement === answerEl ||
    (estEl && document.activeElement === estEl);

  if (selectEl && selectEl.value && !isTextFocused) {
    answerEl.value = '';
    if (estEl) {
      estEl.value = '';
      estEl.disabled = true;
    }
  } else {
    answerEl.disabled = false;
    if (estEl) estEl.disabled = false;
  }

  if (answerEl.value.trim() !== '' || (estEl && estEl.value.trim() !== '')) {
    if (selectEl) {
      selectEl.value = '';
      selectEl.disabled = true;
            if (selectEl.choicesInstance) {
        try {
          selectEl.choicesInstance.removeActiveItems();
        } catch (e) {}
      }
    }
  } else {
    if (selectEl) selectEl.disabled = false;
  }

  if (estEl) {
    validateFreetextPair(answerEl, estEl);
  }
}

export function validateFreetextPair(ansEl, estEl) {
  if (!ansEl || !estEl) return true;
  const ansVal = ansEl.value.trim();
  const estVal = estEl.value.trim();
  const bothEmpty = ansVal === '' && estVal === '';
  const bothFilled = ansVal !== '' && estVal !== '';
  const partial = !bothEmpty && !bothFilled;
  ansEl.classList.toggle('is-invalid', partial);
  estEl.classList.toggle('is-invalid', partial);
  return !partial;
}

export function allFreetextPairsValid(scope = document) {
  let valid = true;
  scope.querySelectorAll('.question-block').forEach(block => {
    const ans = block.querySelector('.manual-answer');
    const est = block.querySelector('.manual-establishment');
    if (ans && est) {
      if (!validateFreetextPair(ans, est)) {
        valid = false;
      }
    }
  });
  return valid;
}

export function renderPaginatedQuestions(questionsToRender = state.questionsData, helpers = {}) {
  const { saveCurrentSelections, saveCurrentCategoryToGlobal, saveVotesAndRedirect, checkIfAllQuestionsAnsweredGlobally, restoreTempSelections } = helpers;
  if (!state.questionsContainer) return;
  state.showingAll = true;
  destroyQuestionChoiceInstances();
  state.questionsContainer.innerHTML = '';
  if (questionsToRender.length === 0) {
    const searchTerm = state.questionSearchInput?.value.trim();
    if (searchTerm) {
      state.questionsContainer.innerHTML = `<p class="text-muted text-center mt-3">No questions found matching "${searchTerm}".</p>`;
    } else {
      state.questionsContainer.innerHTML = '<p class="text-info text-center mt-4">No questions available for this category.</p>';
    }
    const existingPagination = state.questionsContainer.querySelector('.pagination-controls');
    if (existingPagination) existingPagination.remove();
    if (state.toggleViewBtn) state.toggleViewBtn.textContent = 'Single View';
    if (state.prevBtn) state.prevBtn.classList.add('d-none');
    if (state.nextBtn) state.nextBtn.classList.add('d-none');
        if (state.prevBtn && state.prevBtn.parentElement) {
      state.prevBtn.parentElement.classList.add('d-none');
    }
    if (state.submitVoteBtn) state.submitVoteBtn.classList.add('d-none');
    return;
  }
    if (state.prevBtn && state.prevBtn.parentElement) {
    state.prevBtn.parentElement.classList.remove('d-none');
  }

  const visibleQuestions = questionsToRender.slice(state.showOffset, state.showOffset + 5);
  visibleQuestions.forEach(question => {
    const originalIndex = state.questionsData.findIndex(q => q.question_id === question.question_id);
    const selection = state.userSelections[originalIndex] || {};
    const formGroup = document.createElement('div');
    formGroup.className = 'mb-4 question-block border p-3 rounded';
    formGroup.dataset.originalIndex = originalIndex;
    formGroup.dataset.questionId = question.question_id;
    let inputFields = `<label class="form-label fw-bold">${escapeHtml(question.question_name)}</label>`;
    if (question.choice_type === 1) {
      inputFields += `<label class="form-label mt-2 fw-normal text-primary d-block">Choose from the list. If your answer isn't listed, type it in the box below.</label><select class="form-select mb-2" aria-label="Answer for question ${escapeHtml(question.question_name)}"><option value="" ${!selection.selectedOption ? 'selected' : ''}>-- Select --</option>${question.choices.map(choice => `<option value="${choice.choice_id}" ${selection.selectedOption == choice.choice_id ? 'selected' : ''}>${escapeHtml(choice.choice_name)}</option>`).join('')}</select>`;
    }
    if (question.choice_type === 0) {
      inputFields += `<label class="form-label mt-2 fw-normal text-primary d-block">Type your answer in the first box and the establishment, person, or place in the second.</label>
      <div class="row g-2 mt-1"><div class="col-12 col-md-6"><label class="form-label small text-muted d-block">Your answer:</label>
      <input type="text" class="form-control manual-answer w-100" placeholder="Type your answer" value="${selection.manualAnswer || ''}" aria-label="Answer for question ${escapeHtml(question.question_name)}" required></div>
      <div class="col-12 col-md-6"><label class="form-label small text-muted">Establishment/Person/Place:</label>
      <input type="text" class="form-control manual-establishment w-100" placeholder="Establishment/Person/Place" value="${selection.manualEstablishment || ''}" aria-label="Establishment/Person/Place for question ${escapeHtml(question.question_name)}" required></div></div>`;
    } else {
      inputFields += `<label class="form-label small text-muted d-block">Or type your answer here:</label><input type="text" class="form-control manual-answer" placeholder="Your answer" value="${selection.manualAnswer || ''}" aria-label="Other answer for question ${escapeHtml(question.question_name)}">`;
    }
    formGroup.innerHTML = inputFields;
    const selectDropdown = formGroup.querySelector('select');
    initializeQuestionDropdown(selectDropdown);
    const finalizedAnswers = JSON.parse(localStorage.getItem('finalizedAnswers') || '{}');
    const isFinalized = finalizedAnswers[String(question.question_id)] === true;
    if (isFinalized) {
      formGroup.classList.add('bg-light', 'border-success', 'position-relative');
      const badge = document.createElement('span');
      badge.textContent = 'Voted';
      badge.className = 'badge bg-success position-absolute top-0 end-0 m-2';
      formGroup.appendChild(badge);
      const select = formGroup.querySelector('select');
      const answerInput = formGroup.querySelector('.manual-answer');
      const estInput = formGroup.querySelector('.manual-establishment');
      if (select) select.disabled = true;
      if (answerInput) answerInput.disabled = true;
      if (estInput) estInput.disabled = true;
      state.questionsContainer.appendChild(formGroup);
      if (state.prevBtn) {
        state.prevBtn.disabled = originalIndex === 0;
        state.prevBtn.classList.remove('d-none');
      }
      if (state.nextBtn) {
        state.nextBtn.disabled = originalIndex === state.questionsData.length - 1;
        state.nextBtn.classList.remove('d-none');
      }
      if (state.toggleViewBtn) state.toggleViewBtn.textContent = 'List View';
      restoreTempSelections && restoreTempSelections();
      return;
    }
    const select = formGroup.querySelector('select');
    const answerInput = formGroup.querySelector('.manual-answer');
    const estInput = formGroup.querySelector('.manual-establishment');
    if (question.choice_type == 1) {
      if (select) {
        select.addEventListener('change', () => {
          updateFieldStates(select, answerInput || estInput);
          saveCurrentSelections();
          saveCurrentCategoryToGlobal();
          saveVotesAndRedirect && saveVotesAndRedirect(false);
          checkIfAllQuestionsAnsweredGlobally && checkIfAllQuestionsAnsweredGlobally();
        });
      }
      if (answerInput) {
        answerInput.addEventListener('input', () => {
          updateFieldStates(select, answerInput);
          saveCurrentSelections();
          saveCurrentCategoryToGlobal();
          saveVotesAndRedirect && saveVotesAndRedirect(false);
          checkIfAllQuestionsAnsweredGlobally && checkIfAllQuestionsAnsweredGlobally();
        });
      }
      updateFieldStates(select, answerInput);
    } else if (question.choice_type === 0) {
      if (answerInput) answerInput.removeAttribute('required');
      if (estInput) estInput.removeAttribute('required');
      const pairedAutoSave = debounce(() => {
        saveCurrentSelections();
        saveCurrentCategoryToGlobal();
        saveVotesAndRedirect && saveVotesAndRedirect(false);
      }, 500);
      const handleInput = () => {
        updateFieldStates(null, answerInput, estInput);
        saveCurrentSelections();
        saveCurrentCategoryToGlobal();
        checkIfAllQuestionsAnsweredGlobally && checkIfAllQuestionsAnsweredGlobally();
      };
      const handleBlur = () => {
        if (answerInput.value.trim() !== '' && estInput.value.trim() !== '') {
          pairedAutoSave();
        }
      };
      if (answerInput) {
        answerInput.addEventListener('input', handleInput);
        answerInput.addEventListener('blur', handleBlur);
      }
      if (estInput) {
        estInput.addEventListener('input', handleInput);
        estInput.addEventListener('blur', handleBlur);
      }
      updateFieldStates(null, answerInput, estInput);
    } else {
      if (select) {
        select.addEventListener('change', () => {
          saveCurrentSelections();
          saveCurrentCategoryToGlobal();
          saveVotesAndRedirect && saveVotesAndRedirect(false);
          checkIfAllQuestionsAnsweredGlobally && checkIfAllQuestionsAnsweredGlobally();
        });
      }
      if (answerInput) {
        answerInput.addEventListener('input', () => {
          saveCurrentSelections();
          saveCurrentCategoryToGlobal();
          saveVotesAndRedirect && saveVotesAndRedirect(false);
          checkIfAllQuestionsAnsweredGlobally && checkIfAllQuestionsAnsweredGlobally();
        });
      }
    }
    state.questionsContainer.appendChild(formGroup);
  });
  const existingPagination = state.questionsContainer.querySelector('.pagination-controls');
  if (existingPagination) existingPagination.remove();
  const existingIndicator = state.questionsContainer.querySelector('.page-indicator');
  if (existingIndicator) existingIndicator.remove();
  const totalFilteredQuestions = questionsToRender.length;
  const totalPages = Math.ceil(totalFilteredQuestions / 5) || 1;
  const currentPage = Math.floor(state.showOffset / 5) + 1;
  if (state.prevBtn) {
    state.prevBtn.classList.remove('d-none');
    state.prevBtn.disabled = state.showOffset === 0;
  }
  if (state.nextBtn) {
    state.nextBtn.classList.remove('d-none');
    state.nextBtn.disabled = state.showOffset + 5 >= totalFilteredQuestions;
  }

  const pageIndicator = document.createElement('div');
  pageIndicator.className = 'text-muted small text-center mt-2 page-indicator';
  pageIndicator.textContent = `Page ${currentPage} of ${totalPages}`;
  state.questionsContainer.appendChild(pageIndicator);

  if (state.toggleViewBtn) state.toggleViewBtn.textContent = 'Change to Single Item View';
  if (state.submitVoteBtn) state.submitVoteBtn.classList.remove('d-none');
}

export function renderSingleQuestion(helpers = {}) {
  const { saveCurrentSelections, saveCurrentCategoryToGlobal, saveVotesAndRedirect, checkIfAllQuestionsAnsweredGlobally } = helpers;
  if (!state.questionsContainer) return;
  state.showingAll = false;
  destroyQuestionChoiceInstances();
  state.questionsContainer.innerHTML = '';
  if (state.questionsData.length === 0) {
    state.questionsContainer.innerHTML = '<p class="text-info text-center">No awards loaded.</p>';
    if (state.prevBtn) state.prevBtn.disabled = true;
    if (state.nextBtn) state.nextBtn.disabled = true;
    if (state.prevBtn) state.prevBtn.classList.add('d-none');
    if (state.nextBtn) state.nextBtn.classList.add('d-none');
    if (state.prevBtn && state.prevBtn.parentElement) {
      state.prevBtn.parentElement.classList.add('d-none');
    }
    if (state.toggleViewBtn) state.toggleViewBtn.disabled = true;
    if (state.submitVoteBtn) state.submitVoteBtn.classList.add('d-none');
    if (state.questionSearchInput) state.questionSearchInput.disabled = true;
    return;
  } else {
    if (state.toggleViewBtn) state.toggleViewBtn.disabled = false;
    if (state.questionSearchInput) state.questionSearchInput.disabled = false;
  }
  if (state.prevBtn && state.prevBtn.parentElement) {
    state.prevBtn.parentElement.classList.remove('d-none');
  }
  const question = state.questionsData[state.showOffset];
  const originalIndex = state.showOffset;
  const finalizedAnswers = JSON.parse(localStorage.getItem('finalizedAnswers') || '{}');
  const isFinalized = finalizedAnswers[String(question.question_id)] === true;
  let selection = state.userSelections[originalIndex] || {};
  if (isFinalized && (!selection || (!selection.manualAnswer && !selection.selectedOption))) {
    const tempAnswers = JSON.parse(localStorage.getItem('temp_vote_answers') || '{}');
    const categoryId = question.category_id;
    const finalizedSel = tempAnswers[categoryId]?.selections?.find(sel => sel.question_id == question.question_id);
    if (finalizedSel) {
      selection = {
        selectedOption: finalizedSel.choice_id || '',
        manualInput: finalizedSel.freetext || '',
        manualAnswer: '',
        manualEstablishment: ''
      };
      if (finalizedSel.freetext && finalizedSel.freetext.includes(' - ')) {
        const [answer, source] = finalizedSel.freetext.split(' - ');
        selection.manualAnswer = answer || '';
        selection.manualEstablishment = source || '';
      } else {
        selection.manualAnswer = finalizedSel.freetext || '';
      }
      state.userSelections[originalIndex] = selection;
    }
  }
  const formGroup = document.createElement('div');
  formGroup.className = 'mb-4 question-block';
  formGroup.dataset.originalIndex = originalIndex;
  formGroup.dataset.questionId = question.question_id;
  let inputFields = `<p class="text-muted small text-center mb-2">Award ${originalIndex + 1} of ${state.questionsData.length}</p><label class="form-label fw-bold d-block mb-3">${escapeHtml(question.question_name)}</label>`;
  if (question.choice_type === 1) {
    inputFields += `<label class="form-label mt-2 small text-muted d-block">Choose from the list. If your answer isn't listed, type it in the box below.</label><select class="form-select mb-2" aria-label="Answer for award ${escapeHtml(question.question_name)}"><option value="" ${!selection.selectedOption ? 'selected' : ''}>-- Select --</option>${question.choices.map(choice => `<option value="${choice.choice_id}" ${selection.selectedOption == choice.choice_id ? 'selected' : ''}>${escapeHtml(choice.choice_name)}</option>`).join('')}</select>`;
  }
  if (question.choice_type === 0) {
    inputFields += `<label class="form-label mt-2 fw-normal text-primary d-block">Type your answer in the first box and the establishment, person, or place in the second.</label><div class="row g-2 mt-1"><div class="col-12 col-md-6"><label class="form-label small text-muted">Your answer:</label><input type="text" class="form-control manual-answer w-100" placeholder="Type your answer" value="${selection.manualAnswer || ''}" aria-label="Answer for question ${question.question_name}" required></div><div class="col-12 col-md-6"><label class="form-label small text-muted">Establishment/Person/Place:</label><input type="text" class="form-control manual-establishment w-100" placeholder="Establishment/Person/Place" value="${selection.manualEstablishment || ''}" aria-label="Establishment/Person/Place for question ${question.question_name}" required></div></div>`;
  } else {
    inputFields += `<label class="form-label small text-muted d-block">Or type your answer here:</label><input type="text" class="form-control manual-answer" placeholder="Type your answer" value="${selection.manualAnswer || ''}" aria-label="Other answer for question ${escapeHtml(question.question_name)}">`;
  }
  formGroup.innerHTML = inputFields;
  const selectDropdown = formGroup.querySelector('select');
  initializeQuestionDropdown(selectDropdown);
  const select = formGroup.querySelector('select');
  const answerInput = formGroup.querySelector('.manual-answer');
  const estInput = formGroup.querySelector('.manual-establishment');
  if (isFinalized) {
    formGroup.classList.add('bg-light', 'border-success', 'position-relative');
    const badge = document.createElement('span');
    badge.textContent = 'Voted';
    badge.className = 'badge bg-success position-absolute top-0 end-0 m-2';
    formGroup.appendChild(badge);
    if (select) select.disabled = true;
    if (answerInput) answerInput.disabled = true;
    if (estInput) estInput.disabled = true;
    state.questionsContainer.appendChild(formGroup);
    if (state.prevBtn) {
      state.prevBtn.disabled = originalIndex === 0;
      state.prevBtn.classList.remove('d-none');
    }
    if (state.nextBtn) {
      state.nextBtn.disabled = originalIndex === state.questionsData.length - 1;
      state.nextBtn.classList.remove('d-none');
    }
    if (state.toggleViewBtn) state.toggleViewBtn.textContent = 'Change to List View';
    return;
  }
  if (question.choice_type === 1) {
    if (select) {
      select.addEventListener('change', () => {
        updateFieldStates(select, answerInput);
        saveCurrentSelections();
        saveCurrentCategoryToGlobal();
        saveVotesAndRedirect && saveVotesAndRedirect(false);
        checkIfAllQuestionsAnsweredGlobally && checkIfAllQuestionsAnsweredGlobally();
      });
    }
    if (answerInput) {
      answerInput.addEventListener('input', () => {
        updateFieldStates(select, answerInput);
        saveCurrentSelections();
        saveCurrentCategoryToGlobal();
        saveVotesAndRedirect && saveVotesAndRedirect(false);
        checkIfAllQuestionsAnsweredGlobally && checkIfAllQuestionsAnsweredGlobally();
      });
    }
    updateFieldStates(select, answerInput);
  } else if (question.choice_type === 0) {
    if (answerInput) answerInput.removeAttribute('required');
    if (estInput) estInput.removeAttribute('required');
    const pairSave = debounce(() => {
      saveCurrentSelections();
      saveCurrentCategoryToGlobal();
      saveVotesAndRedirect && saveVotesAndRedirect(false);
    }, 500);
    const handlePairInput = () => {
      updateFieldStates(null, answerInput, estInput);
      saveCurrentSelections();
      saveCurrentCategoryToGlobal();
      checkIfAllQuestionsAnsweredGlobally && checkIfAllQuestionsAnsweredGlobally();
    };
    const maybeSave = () => {
      if (answerInput.value.trim() !== '' && estInput.value.trim() !== '') {
        pairSave();
      }
    };
    if (answerInput) {
      answerInput.addEventListener('input', handlePairInput);
      answerInput.addEventListener('blur', maybeSave);
    }
    if (estInput) {
      estInput.addEventListener('input', handlePairInput);
      estInput.addEventListener('blur', maybeSave);
    }
    updateFieldStates(null, answerInput, estInput);
  } else {
    if (select) {
      select.addEventListener('change', () => {
        saveCurrentSelections();
        saveCurrentCategoryToGlobal();
        saveVotesAndRedirect && saveVotesAndRedirect(false);
        checkIfAllQuestionsAnsweredGlobally && checkIfAllQuestionsAnsweredGlobally();
      });
    }
    if (answerInput) {
      answerInput.addEventListener('input', () => {
        saveCurrentSelections();
        saveCurrentCategoryToGlobal();
        saveVotesAndRedirect && saveVotesAndRedirect(false);
        checkIfAllQuestionsAnsweredGlobally && checkIfAllQuestionsAnsweredGlobally();
      });
    }
  }
  state.questionsContainer.appendChild(formGroup);
  if (state.prevBtn) {
    state.prevBtn.disabled = originalIndex === 0;
    state.prevBtn.classList.remove('d-none');
  }
  if (state.nextBtn) {
    state.nextBtn.disabled = originalIndex === state.questionsData.length - 1;
    state.nextBtn.classList.remove('d-none');
  }
  if (state.toggleViewBtn) state.toggleViewBtn.textContent = 'Change to List View';
}