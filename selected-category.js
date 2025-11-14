import { state } from './state.js';
import {
  loadAllDrafts,
  saveDraft,
  loadQuestions,
  loadQuestionsWithChoices,
  loadUserSelectionsFromDB,
} from './data_service.js';
import {
  destroyQuestionChoiceInstances,
  initializeQuestionDropdown,
  updateFieldStates,
  validateFreetextPair,
  allFreetextPairsValid,
  renderPaginatedQuestions,
  renderSingleQuestion,
} from './question_renderer.js';

const voterId = localStorage.getItem('voter_id') || null;
const eventId = localStorage.getItem('current_event_id') || '1';

const urlParams = new URLSearchParams(window.location.search);
const editQuestionId = urlParams.get("edit_question");
const categoryIdFromURL = urlParams.get("category_id");

let allCategoryAnswers = JSON.parse(localStorage.getItem("allCategoryAnswers") || "{}");
let finalizedVotes = JSON.parse(localStorage.getItem("finalizedVotes") || "{}");
let categoryChoicesInstance = null;
let questionChoiceInstances = [];
let userSelections = {};
let questionsData = []; // Holds ALL questions for the loaded category
let filteredQuestionsData = []; // Holds questions matching the current search term
let allCategories = [];
let showOffset = 0; // Tracks the index for pagination or single question view

const showLimit = 5; // Questions per page in list view

let questionSearchInput;
let categorySwitcherElement;
let categoryTitle, questionsContainer, loadingIndicator, controlsDiv;
let prevBtn, nextBtn, toggleViewBtn, submitVoteBtn, saveDraftBtn;

Object.assign(state, {
  allCategoryAnswers,
  finalizedVotes,
  categoryChoicesInstance,
  questionChoiceInstances,
  userSelections,
  questionsData,
  allCategories,
  showOffset,
  questionSearchInput,
  categorySwitcherElement,
  categoryTitle,
  questionsContainer,
  loadingIndicator,
  controlsDiv,
  prevBtn,
  nextBtn,
  toggleViewBtn,
  submitVoteBtn,
  saveDraftBtn
});

// Track whether the interface is showing all questions (list view) or a
// single question. Default to single question view until the renderer sets
// it appropriately.
state.showingAll = false;

// Debounce utility to throttle frequent auto-save calls
function debounce(fn, delay = 300) {
  let timeout;
  return (...args) => {
    clearTimeout(timeout);
    timeout = setTimeout(() => fn(...args), delay);
  };
}

const debouncedAutoSave = debounce(() => saveVotesAndRedirect(false), 300);

function hidePrevNextButtons() {
  if (state.prevBtn) state.prevBtn.classList.add('d-none');
  if (state.nextBtn) state.nextBtn.classList.add('d-none');
  if (state.prevBtn && state.prevBtn.parentElement) {
    state.prevBtn.parentElement.classList.add('d-none');
  }
}


// Add a global event listener to handle changes
window.addEventListener("input", (e) => {
const target = e.target;
const container = target.closest(".question-container");
if (!container) return;

const selectEl = container.querySelector("select");
const answerEl = container.querySelector(".manual-answer");
const estEl = container.querySelector(".manual-establishment");

updateFieldStates(
  selectEl,
  answerEl || container.querySelector("input[type='text']"),
  estEl
);
saveCurrentSelections();
debouncedAutoSave();
});

// Persist selections before the page unloads
window.addEventListener('beforeunload', () => {
  saveCurrentSelections();
  saveCurrentCategoryToGlobal();
});

function removeEditParamFromURL() {
    const url = new URL(window.location.href);
    url.searchParams.delete("edit_question");
    window.history.replaceState({}, document.title, url.toString());
}

function updateCategoryParamInURL(categoryId) {
    const url = new URL(window.location.href);
    url.searchParams.set("category_id", categoryId);
    window.history.replaceState({}, document.title, url.toString());
}

async function fetchAndApplyUserSelections(categoryId) {
    const data = await loadUserSelectionsFromDB(categoryId, voterId, eventId);
    if (data.status === 'success' && Array.isArray(data.selections)) {
        data.selections.forEach(sel => {
            const originalIndex = questionsData.findIndex(q => q.question_id == sel.question_id);
            if (originalIndex !== -1) {
                let ans = '';
                let est = '';
                if (sel.manual_input && sel.manual_input.includes(' - ')) {
                    const parts = sel.manual_input.split(' - ');
                    ans = parts[0] || '';
                    est = parts[1] || '';
                } else if (sel.manual_input) {
                    ans = sel.manual_input;
                }
                userSelections[originalIndex] = {
                    selectedOption: sel.choice_id ? sel.choice_id.toString() : "",
                    choiceText: sel.choice_text || "",
                    manualAnswer: ans || null,
                    manualEstablishment: est || null,
                    manualInput: sel.manual_input || ""
                };
            }
        });

        // Persist the restored selections so global answer tracking stays up to date.
        saveCurrentCategoryToGlobal();
        checkIfAllQuestionsAnsweredGlobally();
    }
}

window.addEventListener("DOMContentLoaded", () => {
  if (categoryIdFromURL) {
    localStorage.setItem("selected_category_id", categoryIdFromURL);
  }

const saved = allCategoryAnswers[categoryIdFromURL];
  if (saved && saved.selections) {
    saved.selections.forEach((sel, i) => {
      const block = document.querySelector(`.question-block[data-original-index='${i}']`);
      if (block) {
        const select = block.querySelector("select");
        const input = block.querySelector("input[type='text']");
        if (select && sel.choice_id) select.value = sel.choice_id;
        if (input && sel.manual_input) input.value = sel.manual_input;
      }
    });
  }

    categorySwitcherElement = document.getElementById('categorySwitcher');
    categoryTitle = document.getElementById("selectedCategoryTitle");
    questionsContainer = document.getElementById("questionsContainer");
    loadingIndicator = document.getElementById("loadingIndicator");
    controlsDiv = document.getElementById("controls");
    prevBtn = document.getElementById("prevBtn");
    nextBtn = document.getElementById("nextBtn");
    toggleViewBtn = document.getElementById("toggleViewBtn");
    saveDraftBtn = document.getElementById("saveDraftBtn");
    submitVoteBtn = document.getElementById("submitVoteBtn");
    // Get reference to the question search input
    questionSearchInput = document.getElementById('questionSearchInput');

    Object.assign(state, {
      categorySwitcherElement,
      categoryTitle,
      questionsContainer,
      loadingIndicator,
      controlsDiv,
      prevBtn,
      nextBtn,
      toggleViewBtn,
      saveDraftBtn,
      submitVoteBtn,
      questionSearchInput
    });

    if (categorySwitcherElement) {
        try {
            categoryChoicesInstance = new Choices(categorySwitcherElement, {
                // MODIFIED: Disable search in category dropdown
                searchEnabled: false, // CHANGE: Disable category search
                itemSelectText: '',
                allowHTML: false,
                placeholder: false,
                removeItemButton: false,
                shouldSort: true,
                // searchPlaceholderValue: "Type to search categories..."
            });
            state.categoryChoicesInstance = categoryChoicesInstance;
            categoryChoicesInstance.disable();
            console.log("Choices.js initialized for categories (search disabled).");
        } catch (error) {
            console.error("Failed to initialize Choices.js:", error);
            if (categorySwitcherElement) {
                categorySwitcherElement.innerHTML = '<option value="">Error initializing dropdown</option>';
                categorySwitcherElement.disabled = true;
            }
        }
    } else {
        console.error("Category switcher element (#categorySwitcher) not found!");
    }

    // Load drafts first, then fetch categories and load category
    loadAllDrafts(voterId, eventId).then(data => {
    if (Array.isArray(data)) {
        const existing = JSON.parse(localStorage.getItem("allCategoryAnswers") || "{}");
        data.forEach(category => {
            const catId = category.category_id;
            const prev = existing[catId] || { category_name: category.category_name, selections: [] };
            const prevSelections = Array.isArray(prev.selections) ? [...prev.selections] : [];

            category.questions.forEach(q => {
                const updated = {
                    question_id: q.question_id,
                    question_name: q.question_name,
                    choice_id: q.choice_id || null,
                    manual_input: q.manual_input || null,
                    choice_text: q.selected_answer_text || q.choice_text || ""
                };
                const idx = prevSelections.findIndex(sel => sel.question_id == q.question_id);
                const hasDbAnswer = q.choice_id !== null || (q.manual_input && q.manual_input.trim() !== "");
                if (idx !== -1) {
                    if (hasDbAnswer) {
                        prevSelections[idx] = updated;
                    }
                } else {
                    prevSelections.push(updated);
                }
            });

            existing[catId] = {
                category_name: category.category_name,
                selections: prevSelections
            };
        });
        localStorage.setItem("allCategoryAnswers", JSON.stringify(existing));
        allCategoryAnswers = existing;
        state.allCategoryAnswers = allCategoryAnswers;
        console.log("Preloaded all draft answers into localStorage (merged)");
    }

    // Fetch All Categories for the Dropdown after drafts are loaded
    fetch('get_all_categories.php')
  .then(response => {
    if (!response.ok) throw new Error(`HTTP error fetching categories! status: ${response.status}`);
    return response.json();
  })
  .then(data => {
    if (data.status === 'success' && Array.isArray(data.categories)) {
      allCategories = data.categories;

      const voterType = localStorage.getItem("voter_type");
      if (voterType === "existing") {
        const unanswered = JSON.parse(localStorage.getItem("unanswered") || "[]");
        const unansweredCatIds = [...new Set(unanswered.map(q => q.category_id.toString()))];
        allCategories = allCategories.filter(cat => unansweredCatIds.includes(cat.id.toString()));
      }

      if (allCategories.length === 0) {
        if (categoryTitle) categoryTitle.textContent = "NO CATEGORY TO VOTE";
        if (questionsContainer) {
          questionsContainer.innerHTML = '<p class="text-info text-center mt-4">All awards have been responded.</p>';
        }
        if (controlsDiv) controlsDiv.classList.remove('d-none');
        checkIfAllQuestionsAnsweredGlobally();
        return;
      }

      let initialCategoryId = categoryIdFromURL || localStorage.getItem("selected_category_id");

      if (!initialCategoryId && allCategories.length > 0) {
        initialCategoryId = allCategories[0].id.toString();
      }

      populateCategorySwitcher(initialCategoryId);

      const matchedInitial = allCategories.find(cat => cat.id == initialCategoryId);
      if (matchedInitial) {
        const initialCategoryName = matchedInitial.name;
        loadCategory(initialCategoryId, initialCategoryName);
        updateCategoryParamInURL(initialCategoryId);
        console.log(`Loaded category: ${initialCategoryName} (ID: ${initialCategoryId})`);
      } else if (categoryTitle) {
        categoryTitle.textContent = "NO CATEGORY SELECTED";
      }
    } else {
      throw new Error(data.message || 'Failed to load category list from server.');
    }
  })
  .catch(error => {
    console.error("Error fetching category list:", error);
    if (categoryChoicesInstance) {
      categoryChoicesInstance.setChoices(
        [{ value: '', label: 'Error loading categories', selected: true, disabled: true }],
        'value', 'label', true
      );
      categoryChoicesInstance.enable();
    }
  });
    });

    saveCurrentCategoryToGlobal(); 
    checkIfAllQuestionsAnsweredGlobally();

    categorySwitcherElement?.addEventListener('change', (event) => {
        if (!allFreetextPairsValid()) {
            alert('Please enter your answers in both fields before changing categories.');
            categoryChoicesInstance.setChoiceByValue(localStorage.getItem("selected_category_id") || '');
            return;
        }

        const newCategoryId = categoryChoicesInstance.getValue(true);
        if (!newCategoryId) return;

        saveCurrentSelections();
        saveCurrentCategoryToGlobal();

        if (newCategoryId == localStorage.getItem("selected_category_id")) {
            console.log("Same category re-selected — forcing reload to apply any unsaved changes.");
        }

        const selectedCategory = allCategories.find(cat => cat.id == newCategoryId);
        const newCategoryName = selectedCategory ? selectedCategory.name : 'Unknown Category';

        console.log(`Category switch requested to: ${newCategoryName} (ID: ${newCategoryId})`);

        const dataToSave = getCurrentCategoryAnswersForDB();
        if (dataToSave && dataToSave.selections && dataToSave.selections.length > 0) {
                saveDraft(dataToSave).then(result => console.log("Draft auto-saved on category switch:", result.message));
            }

        if (questionSearchInput) {
            questionSearchInput.value = '';
        }

        loadCategory(newCategoryId, newCategoryName);

        localStorage.setItem("selected_category_id", newCategoryId);
        localStorage.setItem("selected_category_name", newCategoryName);
        updateCategoryParamInURL(newCategoryId);
        console.log(`Context switched to new category: ${newCategoryName}`);

        checkIfAllQuestionsAnsweredGlobally();
    });

    questionSearchInput?.addEventListener('input', () => {
        // Search should only function effectively in list view
        if (!state.showingAll) {

            console.log("Search works best in 'List View'.");
        }
        filterAndRenderQuestions(); // Call the filtering and rendering function
    });

    nextBtn?.addEventListener("click", () => {
        if (!allFreetextPairsValid()) {
            alert('Please enter your answers in both fields to proceed.');
            return;
        }
        saveCurrentSelections(); // Save before moving
        if (state.showingAll) {
            const total = state.filteredQuestionsData.length;
            if (showOffset + showLimit < total) {
                showOffset += showLimit;
                state.showOffset = showOffset;
                renderPaginatedQuestions(state.filteredQuestionsData, { saveCurrentSelections, saveCurrentCategoryToGlobal, saveVotesAndRedirect, checkIfAllQuestionsAnsweredGlobally, restoreTempSelections });
            }
        } else if (showOffset < questionsData.length - 1) { // Still based on original data length for single view
            showOffset++;
            state.showOffset = showOffset;
            renderSingleQuestion({ saveCurrentSelections, saveCurrentCategoryToGlobal, saveVotesAndRedirect, checkIfAllQuestionsAnsweredGlobally });
        }
    });

    prevBtn?.addEventListener("click", () => {
        if (!allFreetextPairsValid()) {
            alert('Please enter your answers in both fields to proceed.');
            return;
        }
        saveCurrentSelections(); // Save before moving
        if (state.showingAll) {
            if (showOffset > 0) {
                showOffset = Math.max(0, showOffset - showLimit);
                state.showOffset = showOffset;
                renderPaginatedQuestions(state.filteredQuestionsData, { saveCurrentSelections, saveCurrentCategoryToGlobal, saveVotesAndRedirect, checkIfAllQuestionsAnsweredGlobally, restoreTempSelections });
            }
        } else if (showOffset > 0) {
            showOffset--;
            state.showOffset = showOffset;
            renderSingleQuestion({ saveCurrentSelections, saveCurrentCategoryToGlobal, saveVotesAndRedirect, checkIfAllQuestionsAnsweredGlobally });
        }
    });

    toggleViewBtn?.addEventListener("click", () => {
        if (!allFreetextPairsValid()) {
            alert('Please enter your answers in both fields to proceed.');
            return;
        }
        saveCurrentSelections(); // Save before toggling

        if (questionSearchInput) {
            questionSearchInput.value = '';
        }

        if (state.showingAll) { // Switching from List to Single
            showOffset = 0; // Reset to first question of original data
            state.showOffset = showOffset;
            renderSingleQuestion({ saveCurrentSelections, saveCurrentCategoryToGlobal, saveVotesAndRedirect, checkIfAllQuestionsAnsweredGlobally });
        } else { // Switching from Single to List
            showOffset = 0; // Reset to first page
            state.showOffset = showOffset;
            filterAndRenderQuestions(); // Render list view (will use full data as search is cleared)
        }
        checkIfAllQuestionsAnsweredGlobally();
    });

    saveDraftBtn?.addEventListener("click", saveVotesAndRedirect);
    submitVoteBtn?.addEventListener("click", saveVotesAndRedirect);

    console.log("Event listeners attached.");

    restoreTempSelections();
});

function filterAndRenderQuestions() {
    if (!questionsContainer || !questionSearchInput) return;

    const searchTerm = questionSearchInput.value.trim().toLowerCase();

    filteredQuestionsData = searchTerm
        ? questionsData.filter(q =>
            q.question_name.toLowerCase().includes(searchTerm))
        : [...questionsData];
    state.filteredQuestionsData = filteredQuestionsData;

    if (editQuestionId) {
        const jumpToIndex = questionsData.findIndex(q => q.question_id == editQuestionId);
        if (jumpToIndex !== -1) {
            showOffset = jumpToIndex;
            state.showOffset = showOffset;
        }
    }

    const currentEditId = new URLSearchParams(window.location.search).get("edit_question");
    if (currentEditId) {
        const jumpToIndex = questionsData.findIndex(q => q.question_id == currentEditId);
        if (jumpToIndex !== -1) {
            showOffset = jumpToIndex;
            state.showOffset = showOffset;
            console.log("Restored edit jump to:", currentEditId);
        }
    } else {
        showOffset = 0;
        state.showOffset = showOffset;
    }

    renderPaginatedQuestions(filteredQuestionsData, { saveCurrentSelections, saveCurrentCategoryToGlobal, saveVotesAndRedirect, checkIfAllQuestionsAnsweredGlobally, restoreTempSelections });
}

function saveCurrentCategoryToGlobal() {
  const existing = JSON.parse(localStorage.getItem("allCategoryAnswers") || "{}");
  // Go through all selections that were captured
  questionsData.forEach((question, index) => {
    if (!(index in userSelections)) return;
    const sel = userSelections[index] || {};
    const categoryId = question.category_id;
    const categoryName = allCategories.find(cat => parseInt(cat.id) === parseInt(categoryId))?.name || "Unknown";

    const answer = {
      question_id: question.question_id,
      question_name: question.question_name,
      choice_id: sel.selectedOption || null,
      manual_input: sel.manualInput || null,
      choice_text:
        sel.choiceText ||
        question.choices?.find(c => c.choice_id == sel.selectedOption)?.choice_name ||
        ""
    };
    // Ensure the category bucket exists
    if (!existing[categoryId]) {
      existing[categoryId] = {
        category_name: categoryName,
        selections: []
      };
    }
    // Remove any previous entry of this question
    existing[categoryId].selections = existing[categoryId].selections.filter(
      q => q.question_id !== answer.question_id
    );
    if (answer.choice_id !== null || answer.manual_input !== null) {
      existing[categoryId].selections.push(answer);
    }
  });

  localStorage.setItem("allCategoryAnswers", JSON.stringify(existing));
  allCategoryAnswers = existing;
  state.allCategoryAnswers = allCategoryAnswers;
  console.log("[GLOBAL] Saved all current answers to correct categories");
}

let tempSelections = JSON.parse(localStorage.getItem("temp_vote_answers") || "[]");

function restoreTempSelections() {
  const tempAnswers = JSON.parse(
    localStorage.getItem("temp_vote_answers") || "{}"
  );
  const globalAnswers = JSON.parse(
    localStorage.getItem("allCategoryAnswers") || "{}"
  );
  const currentCategoryId =
    localStorage.getItem("selected_category_id") || categoryIdFromURL;

  let selections = [];
  if (
    tempAnswers[currentCategoryId] &&
    Array.isArray(tempAnswers[currentCategoryId].selections)
  ) {
    selections = tempAnswers[currentCategoryId].selections;
  } else if (
    globalAnswers[currentCategoryId] &&
    Array.isArray(globalAnswers[currentCategoryId].selections)
  ) {
    selections = globalAnswers[currentCategoryId].selections;
  } else {
    return;
  }

  // First populate userSelections for all questions in memory
  selections.forEach((sel) => {
    const index = questionsData.findIndex(
      (q) => q.question_id == sel.question_id
    );
    if (index === -1) return;

    let ans = "";
    let est = "";
    if (sel.manual_input && sel.manual_input.includes(" - ")) {
      const parts = sel.manual_input.split(" - ");
      ans = parts[0] || "";
      est = parts[1] || "";
    } else if (sel.manual_input) {
      ans = sel.manual_input;
    }

    userSelections[index] = {
      selectedOption: sel.choice_id ? sel.choice_id.toString() : "",
      choiceText: sel.choice_text || "",
      manualAnswer: ans || null,
      manualEstablishment: est || null,
      manualInput: sel.manual_input || "",
    };
  });

  // Then update the currently rendered question blocks
  const blocks = document.querySelectorAll(".question-block");
  blocks.forEach((block) => {
    const questionId = parseInt(block.dataset.questionId);
    const selection = selections.find(
      (item) => parseInt(item.question_id) === questionId
    );
    if (!selection) return;

    const select = block.querySelector("select");
    const ansEl = block.querySelector(".manual-answer");
    const estEl = block.querySelector(".manual-establishment");

    if (select) {
      select.value = selection.choice_id || "";
      // Ensure Choices.js UI reflects the stored value
      if (select.choicesInstance && selection.choice_id) {
        try {
          select.choicesInstance.setChoiceByValue(String(selection.choice_id));
        } catch (err) {
          console.warn("Failed to sync Choices dropdown", err);
        }
      }
      select.dispatchEvent(new Event("change"));
    }

    if (ansEl && estEl && selection.manual_input) {
      const parts = selection.manual_input.split(" - ");
      ansEl.value = parts[0] || "";
      estEl.value = parts[1] || "";
      updateFieldStates(null, ansEl, estEl);
    } else if (
      ansEl &&
      selection.manual_input !== null &&
      selection.manual_input !== undefined
    ) {
      ansEl.value = selection.manual_input;
      updateFieldStates(null, ansEl, estEl);
    }
  });
  checkIfAllQuestionsAnsweredGlobally();
}

function saveCurrentSelections() {
  const questionBlocks = document.querySelectorAll(".question-block");
  questionBlocks.forEach(block => {
    const index = parseInt(block.dataset.originalIndex);
    const select = block.querySelector("select");
    const ansEl = block.querySelector(".manual-answer");
    const estEl = block.querySelector(".manual-establishment");

    const selectedOption = select ? select.value.trim() : "";
    const selectedText =
      select && select.selectedIndex > 0
        ? select.options[select.selectedIndex].text.trim()
        : "";
    const ansVal = ansEl ? ansEl.value.trim() : "";
    const estVal = estEl ? estEl.value.trim() : "";

    let manualInput = "";
    if (ansEl && estEl) {
      if (ansVal && estVal) manualInput = `${ansVal} - ${estVal}`;
    } else if (ansEl) {
      manualInput = ansVal;
    }

    userSelections[index] = {
      selectedOption,
      choiceText: selectedText,
      manualAnswer: ansEl ? ansVal || null : null,
      manualEstablishment: estEl ? estVal || null : null,
      manualInput
    };
  });
}

function getCurrentCategoryAnswersForDB() {
  saveCurrentSelections();

  const currentCategoryId = localStorage.getItem("selected_category_id") || categoryIdFromURL;
  const category_id = parseInt(currentCategoryId);

  if (isNaN(category_id)) {
    console.error("[SAVE] Invalid category_id detected:", currentCategoryId);
    return null;
  }

    const matchedCategory = allCategories.find(cat => cat.id == category_id);
    const currentCategoryName = matchedCategory ? matchedCategory.name : "Uncategorized";
    const selections = questionsData.map((question, index) => {
        const sel = userSelections[index] || {};
        const answerPart = sel.manualAnswer && sel.manualAnswer.trim() !== '' ? sel.manualAnswer.trim() : '';
        const estPart = sel.manualEstablishment && sel.manualEstablishment.trim() !== '' ? sel.manualEstablishment.trim() : '';
        let freetextCombined = '';
        if (question.choice_type === 0) {
            if (answerPart && estPart) freetextCombined = `${answerPart} - ${estPart}`;
        } else {
            freetextCombined = answerPart || '';
        }
        return {
        question_id: question.question_id,
        question_name: question.question_name,
        choice_id: sel.selectedOption || null,
        freetext: freetextCombined || null,
        choice_text:
          sel.choiceText ||
          question.choices?.find(c => c.choice_id == sel.selectedOption)?.choice_name ||
          ""
        };
    });
  return { category_id, category_name: currentCategoryName, voter_id: voterId, selections };
}

async function saveVotesAndRedirect(eOrShouldRedirect = true) {
  const shouldRedirect =
    typeof eOrShouldRedirect === 'boolean'
      ? eOrShouldRedirect
      : eOrShouldRedirect?.target?.id === 'submitVoteBtn';

  if (typeof eOrShouldRedirect === 'object') {
    eOrShouldRedirect.preventDefault?.();
  }

  if (!allFreetextPairsValid()) {
    alert('Please enter your answers in both fields to proceed.');
    return;
  }

  saveCurrentSelections();
  saveCurrentCategoryToGlobal();

  const payload = getCurrentCategoryAnswersForDB();
  if (payload && payload.selections.length > 0) {
    // Include voter identifier so drafts can be restored across devices
    payload.voter_id = voterId;
    try {
      const result = await saveDraft(payload);
      console.log('Draft saved:', result.message || result.status);
    } catch (err) {
      console.error('Failed to save draft', err);
    }
  }

  localStorage.setItem('temp_vote_answers', JSON.stringify(allCategoryAnswers));
  window.dispatchEvent(new Event('answersUpdated'));

  if (shouldRedirect) {
    // Clear the flag used to allow returning from the summary page so the
    // button state is recalculated next time this screen loads.
    localStorage.removeItem('from_summary');
    window.location.href = 'summarypoll.php';
  }
}

function checkIfAllQuestionsAnsweredGlobally() {
  // Always allow proceeding to the summary, even if no questions have been answered.
  if (submitVoteBtn) {
    submitVoteBtn.disabled = false;
  }
}

function populateCategorySwitcher(currentCategoryId = '') {
    if (!categoryChoicesInstance || !allCategories) {
        console.warn("Choices.js instance or category list not available for population.");
        return;
    }

    const voterType = localStorage.getItem("voter_type");
    let choicesToShow = allCategories;

    if (voterType === "existing") {
        const unanswered = JSON.parse(localStorage.getItem("unanswered") || "[]");
        const unansweredCatIds = [...new Set(unanswered.map(q => q.category_id.toString()))];
        choicesToShow = allCategories.filter(cat => unansweredCatIds.includes(cat.id.toString()));
    }

    const choices = choicesToShow.map(category => ({
        value: category.id.toString(),
        label: category.name,
        selected: currentCategoryId && category.id == currentCategoryId,
        disabled: false,
    }));

    console.log("Filtered dropdown categories for existing voter:", choices);
    categoryChoicesInstance.setChoices(choices, 'value', 'label', true);
    if (currentCategoryId) {
        categoryChoicesInstance.setChoiceByValue(currentCategoryId.toString());
    }
    categoryChoicesInstance.enable();
}

async function loadCategory(categoryId, categoryName) {
    console.log(`Loading category: ${categoryName} (ID: ${categoryId})`);

    localStorage.setItem("selected_category_id", categoryId);

    saveCurrentCategoryToGlobal();

    // Reset local caches for the newly selected category and keep the
    // shared state in sync so the renderer pulls the fresh data. Earlier the
    // state properties were left pointing at the old arrays which caused the
    // question list to remain empty.
    questionsData = [];
    filteredQuestionsData = [];
    userSelections = {};
    showOffset = 0;
    state.questionsData = questionsData;
    state.filteredQuestionsData = filteredQuestionsData;
    state.userSelections = userSelections;
    state.showOffset = showOffset;
    state.showingAll = false;

    if (questionSearchInput) {
        questionSearchInput.value = '';
        questionSearchInput.disabled = true;
    }

    const matchedCategory = allCategories.find(cat => cat.id == categoryId);
    const safeCategoryName = matchedCategory?.name || categoryName || "Uncategorized";

    // Track the currently loaded category in state for reuse by other
    // modules and avoid transforming the text so names appear as entered.
    state.currentCategoryId = categoryId;
    state.currentCategoryName = safeCategoryName;

    if (categoryTitle) {
        categoryTitle.textContent = safeCategoryName;
        localStorage.setItem("selected_category_name", safeCategoryName);
    }

    if (questionsContainer) questionsContainer.innerHTML = '';
    if (loadingIndicator) loadingIndicator.classList.remove('d-none');
    if (controlsDiv) controlsDiv.classList.add('d-none');
        hidePrevNextButtons();
    if (categoryChoicesInstance) categoryChoicesInstance.disable();

    try {
        const data = await loadQuestionsWithChoices(categoryId);
        if (data.status !== "success" || !Array.isArray(data.questions)) {
            throw new Error(data.message || "Failed to load award titles from server.");
        }

        if (data.questions.length === 0) {
            console.log(`No award titles found for category ${categoryId}.`);
            questionsContainer.innerHTML = '<p class="text-info text-center mt-4">No award titles available for this category.</p>';
            return;
        }

        const voterType = localStorage.getItem("voter_type");
        const allUnanswered = JSON.parse(localStorage.getItem("unanswered") || "[]");

        if (voterType === "existing" && allUnanswered.length > 0) {
            const unansweredForThisCategory = allUnanswered.filter(q => q.category_id == categoryId);

            if (unansweredForThisCategory.length === 0) {
                questionsContainer.innerHTML = '<p class="text-info text-center mt-4">Responded award titles in this category are all casted.</p>';
                if (loadingIndicator) loadingIndicator.classList.add('d-none');
                return;
            }

            // Filter questions to only unanswered ones
            const unvoted = data.questions.filter(q => unansweredForThisCategory.some(uq => uq.question_id == q.question_id));

            questionsData = unvoted.sort((a, b) => a.question_id - b.question_id);
            filteredQuestionsData = [...questionsData];
            state.questionsData = questionsData;
            state.filteredQuestionsData = filteredQuestionsData;

            if (questionsData.length === 0) {
                questionsContainer.innerHTML = '<p class="text-info text-center mt-4">All award titles in this category have been casted.</p>';
                if (loadingIndicator) loadingIndicator.classList.add('d-none');
                if (controlsDiv) controlsDiv.classList.add('d-none');
                hidePrevNextButtons();
                if (categoryChoicesInstance) {
                    categoryChoicesInstance.enable();
                    categoryChoicesInstance.setChoiceByValue(categoryId.toString());
                }
                checkIfAllQuestionsAnsweredGlobally();
                return;
            }

            const currentEditId = new URLSearchParams(window.location.search).get("edit_question");
            if (currentEditId) {
                const jumpToIndex = questionsData.findIndex(q => q.question_id == currentEditId);
                if (jumpToIndex !== -1) {
                    showOffset = jumpToIndex;
                    state.showOffset = showOffset;
                    console.log("Will scroll to question ID:", currentEditId, "at index", jumpToIndex);
                } else {
                    console.warn("Edit question ID not found in questionsData:", currentEditId);
                }
            }

            await fetchAndApplyUserSelections(categoryId);

            if (questionsData.length > 0) {
                renderSingleQuestion({ saveCurrentSelections, saveCurrentCategoryToGlobal, saveVotesAndRedirect, checkIfAllQuestionsAnsweredGlobally });
                restoreTempSelections();
                if (controlsDiv) controlsDiv.classList.remove('d-none');
                if (questionSearchInput) questionSearchInput.disabled = false;
            } else {
                questionsContainer.innerHTML = '<p class="text-info text-center mt-4">Award titles for this category are unavailable.</p>';
                if (controlsDiv) controlsDiv.classList.add('d-none');
                hidePrevNextButtons();
            }

            if (loadingIndicator) loadingIndicator.classList.add('d-none');
            if (categoryChoicesInstance) {
                categoryChoicesInstance.enable();
                categoryChoicesInstance.setChoiceByValue(categoryId.toString());
            }
            checkIfAllQuestionsAnsweredGlobally();
            return;
        }

        // For new voters, use all questions
        const finalizedLocal = JSON.parse(localStorage.getItem("finalizedAnswers") || "{}");
        const finalizedDB = JSON.parse(localStorage.getItem("finalizedFromDB") || "{}");
        const unvoted = data.questions.filter(q => !(finalizedLocal[q.question_id] || finalizedDB[q.question_id]));

        questionsData = unvoted.sort((a, b) => a.question_id - b.question_id);
        filteredQuestionsData = [...questionsData];
        state.questionsData = questionsData;
        state.filteredQuestionsData = filteredQuestionsData;

        if (questionsData.length === 0) {
            questionsContainer.innerHTML = '<p class="text-info text-center mt-4">All award titles in this category have been casted.</p>';
            if (loadingIndicator) loadingIndicator.classList.add('d-none');
            if (controlsDiv) controlsDiv.classList.add('d-none');
            hidePrevNextButtons();
            if (categoryChoicesInstance) {
                categoryChoicesInstance.enable();
                categoryChoicesInstance.setChoiceByValue(categoryId.toString());
            }
            checkIfAllQuestionsAnsweredGlobally();
            return;
        }

        const currentEditId = new URLSearchParams(window.location.search).get("edit_question");
        if (currentEditId) {
            const jumpToIndex = questionsData.findIndex(q => q.question_id == currentEditId);
            if (jumpToIndex !== -1) {
                showOffset = jumpToIndex;
                state.showOffset = showOffset;
                console.log("Jumping to edited question ID:", currentEditId, "at index", jumpToIndex);
            }
        }

        await fetchAndApplyUserSelections(categoryId);

        if (allCategoryAnswers[categoryId]) {
            console.log(`[RESTORE] Rehydrating selections from memory for category ${categoryId}`);
            const selections = allCategoryAnswers[categoryId].selections;
            selections.forEach(sel => {
                const index = questionsData.findIndex(q => q.question_id == sel.question_id);
                if (index !== -1) {
                    let ans = "";
                    let est = "";
                    if (sel.manual_input && sel.manual_input.includes(' - ')) {
                        const parts = sel.manual_input.split(' - ');
                        ans = parts[0] || '';
                        est = parts[1] || '';
                    } else if (sel.manual_input) {
                        ans = sel.manual_input;
                    }
                    userSelections[index] = {
                        selectedOption: sel.choice_id ? sel.choice_id.toString() : "",
                        choiceText: sel.choice_text || "",
                        manualAnswer: ans || null,
                        manualEstablishment: est || null,
                        manualInput: sel.manual_input || ""
                    };
                }
            });
        }
        if (questionsData.length > 0) {
            renderSingleQuestion({ saveCurrentSelections, saveCurrentCategoryToGlobal, saveVotesAndRedirect, checkIfAllQuestionsAnsweredGlobally });
            restoreTempSelections();
            if (controlsDiv) controlsDiv.classList.remove('d-none');
            if (questionSearchInput) questionSearchInput.disabled = false;
        } else {
            questionsContainer.innerHTML = '<p class="text-info text-center mt-4">Award titles for this category are unavailable.</p>';
            controlsDiv.classList.add('d-none');
            hidePrevNextButtons();
        }
    } catch (error) {
        console.error(`Error loading category ${categoryId}:`, error);
        questionsContainer.innerHTML = `<p class="alert alert-danger text-center mt-4">Error loading award titles: ${error.message}</p>`;
        controlsDiv.classList.add('d-none');
        hidePrevNextButtons();
        if (questionSearchInput) questionSearchInput.disabled = true;
    } finally {
        if (loadingIndicator) loadingIndicator.classList.add('d-none');
        if (categoryChoicesInstance) {
            categoryChoicesInstance.enable();
            categoryChoicesInstance.setChoiceByValue(categoryId.toString());
        }
        checkIfAllQuestionsAnsweredGlobally();
        console.log(`Finished loading attempt for category ${categoryId}`);
    }
}
