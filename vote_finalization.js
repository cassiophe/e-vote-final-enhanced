export function buildFinalizedAnswerArray() {
  const allCategoryAnswers = JSON.parse(localStorage.getItem("allCategoryAnswers") || "{}");
  const finalizedAnswers = JSON.parse(localStorage.getItem("finalizedAnswers") || "{}");
  const result = [];

  for (const catId in allCategoryAnswers) {
    const selections = allCategoryAnswers[catId]?.selections || [];
    selections.forEach(sel => {
      if (finalizedAnswers[sel.question_id]) {
        const ft = sel.manual_input && sel.manual_input.trim() !== ''
          ? sel.manual_input.trim()
          : "";
        result.push({
          question_id: sel.question_id,
          choice_id: sel.choice_id || null,
          freetext: ft
        });
      }
    });
  }
  return result;
}

export function buildFinalizedVotesObject() {
  const allCategoryAnswers = JSON.parse(localStorage.getItem("allCategoryAnswers") || "{}");
  const finalizedAnswers = JSON.parse(localStorage.getItem("finalizedAnswers") || "{}");
  const result = {};

  for (const catId in allCategoryAnswers) {
    const selections = allCategoryAnswers[catId]?.selections || [];
    selections.forEach(sel => {
      if (finalizedAnswers[sel.question_id]) {
        const ft = sel.manual_input && sel.manual_input.trim() !== ''
          ? sel.manual_input.trim()
          : "";
        result[sel.question_id] = {
          choice_id: sel.choice_id || null,
          freetext: ft
        };
      }
    });
  }
  return result;
}

export function hasFinalizedVotes() {
  const votes = buildFinalizedVotesObject();
  return Object.keys(votes).length > 0;
}

export async function finalizeQuestion(qid) {
  const allAnswers = JSON.parse(localStorage.getItem("allCategoryAnswers") || "{}");
  const finalized = JSON.parse(localStorage.getItem("finalizedAnswers") || "{}");
  const finalizedFromDB = JSON.parse(localStorage.getItem("finalizedFromDB") || "{}");

  // Skip if this question is already finalized either locally or in the DB
  if (finalized[qid] || finalizedFromDB[qid]) {
    console.log(`Question ${qid} already finalized, skipping`);
    return;
  }

  let answer = null;
  for (const catId in allAnswers) {
    const found = (allAnswers[catId].selections || []).find(sel => sel.question_id == qid);
    if (found) {
      answer = found;
      break;
    }
  }

  if (!answer) {
    console.warn(`No answer found for question ${qid}`);
    return;
  }

  finalized[qid] = true;
  localStorage.setItem("finalizedAnswers", JSON.stringify(finalized));

  const voterId =
    localStorage.getItem("voter_id") ||
    localStorage.getItem("otp_mobile") ||
    localStorage.getItem("voter_mobile");

  if (voterId) {
    const payload = {
      voters_id: voterId,
      finalized_votes: {
        [qid]: {
          choice_id: answer.choice_id || null,
          freetext:
            answer.manual_input && answer.manual_input.trim() !== ''
              ? answer.manual_input.trim()
              : ''
        }
      },
      answers: [
        {
          question_id: qid,
          choice_id: answer.choice_id || null,
          freetext:
            answer.manual_input && answer.manual_input.trim() !== ''
              ? answer.manual_input.trim()
              : ''
        }
      ]
    };
    try {
      const res = await fetch("submit_vote.php", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload)
      });
      const data = await res.json();
      console.log("Single vote submitted:", data);
      if (data.status === "success") {
        window.showToast?.("Answer casted successfully.", "success");
      } else {
        window.showToast?.(data.message || "Failed to submit vote", "danger");
      }
    } catch (err) {
      console.error("Failed to submit vote", err);
      window.showToast?.("Failed to submit vote", "danger");
    }
  }

  window.renderSummary?.();
}

export function finalizeAllInCategory(categoryId) {
  const allAnswers = JSON.parse(localStorage.getItem("allCategoryAnswers") || "{}");
  const finalized = JSON.parse(localStorage.getItem("finalizedAnswers") || "{}");
  const finalizedFromDB = JSON.parse(localStorage.getItem("finalizedFromDB") || "{}");
  const selections = allAnswers[categoryId]?.selections || [];

  let updated = false;
  selections.forEach(sel => {
    const hasAnswer = Boolean(
      sel.choice_id ||
      (sel.choice_text && sel.choice_text.trim() !== "") ||
      (sel.manual_input && sel.manual_input.trim() !== "")
    );
    if (hasAnswer && !finalized[sel.question_id] && !finalizedFromDB[sel.question_id]) {
      finalized[sel.question_id] = true;
      updated = true;
    }
  });
  if (updated) {
    localStorage.setItem("finalizedAnswers", JSON.stringify(finalized));
    window.renderSummary?.();
  }
}

export async function finalizeAllCategories() {
  const voteAllBtn = window.voteAllBtn;
  const finishBtn = window.finishBtn;
  const originalText = voteAllBtn ? voteAllBtn.textContent : "";

  if (voteAllBtn) {
    voteAllBtn.disabled = true;
    voteAllBtn.textContent = "Voting...";
  }

  await window.fetchAllCategoriesAndQuestions?.();

  const allAnswers = JSON.parse(localStorage.getItem("allCategoryAnswers") || "{}");
  const finalized = JSON.parse(localStorage.getItem("finalizedAnswers") || "{}");
  const finalizedFromDB = JSON.parse(localStorage.getItem("finalizedFromDB") || "{}");

  const finalized_votes = {};
  const answers = [];

  for (const catId in allAnswers) {
    const selections = allAnswers[catId]?.selections || [];

    for (const sel of selections) {
      const isAlreadyFinal = finalized[sel.question_id] || finalizedFromDB[sel.question_id];
      const hasAnswer = sel.choice_id || (sel.manual_input && sel.manual_input.trim());

      if (hasAnswer && !isAlreadyFinal) {
        const cleanText = sel.manual_input?.trim() || "";
        finalized[sel.question_id] = true;

        finalized_votes[sel.question_id] = {
          choice_id: sel.choice_id || null,
          freetext: cleanText
        };

        answers.push({
          question_id: sel.question_id,
          choice_id: sel.choice_id || null,
          freetext: cleanText
        });
      }
    }
  }

  if (answers.length === 0) {
    alert("There are no answered award titles to vote.");
    if (voteAllBtn) {
      voteAllBtn.disabled = false;
      voteAllBtn.textContent = originalText;
    }
    return;
  }

  if (!confirm(`Cast all ${answers.length} answered award titles now? This cannot be undone.`)) {
    if (voteAllBtn) {
      voteAllBtn.disabled = false;
      voteAllBtn.textContent = originalText;
    }
    return;
  }

  localStorage.setItem("finalizedAnswers", JSON.stringify(finalized));

  const voterId =
    localStorage.getItem("voter_id") ||
    localStorage.getItem("otp_mobile") ||
    localStorage.getItem("voter_mobile");

  if (!voterId) {
    alert("Voter not recognized. Please verify your mobile number.");
    if (voteAllBtn) {
      voteAllBtn.disabled = false;
      voteAllBtn.textContent = originalText;
    }
    return;
  }

  try {
    const res = await fetch("submit_vote.php", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        voters_id: voterId,
        finalized_votes,
        answers
      })
    });

    const result = await res.json();
    console.log("VoteAll Submit Result:", result);

    if (result.status === "success") {
      localStorage.setItem("finalizedAnswers", JSON.stringify(finalized));

      const questionRes = await fetch("load_all_questions.php");
      const questionData = await questionRes.json();
      const activeQ = questionData.questions || [];
      const activeQids = activeQ.map(q => parseInt(q.question_id));
      const finalizedSet = new Set([
        ...Object.keys(finalized).map(Number),
        ...Object.keys(finalizedFromDB).map(Number)
      ]);
      const allFinal = activeQids.every(qid => finalizedSet.has(qid));

      if (allFinal) {
        localStorage.setItem("vote_finalized", "true");
        window.isFinalized = true;
        if (finishBtn) finishBtn.style.display = "none";
      }

      window.renderSummary?.();

      if (typeof window.showToast === "function") {
        window.showToast("All votes submitted successfully.", "success");
      } else {
        alert("All votes submitted successfully.");
      }

    } else {
      alert(result.message || "Failed to submit votes.");
    }

  } catch (error) {
    console.error("VoteAll error:", error);
    alert("An error occurred while submitting your votes.");
  }

  if (voteAllBtn) {
    voteAllBtn.disabled = false;
    voteAllBtn.textContent = originalText;
  }
}