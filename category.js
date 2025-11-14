
// Load category list
document.addEventListener('DOMContentLoaded', () => {
  const categoryList = document.getElementById('categoryList');

  fetch('get_all_categories.php')
    .then(response => {
      if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
      return response.json();
    })
    .then(data => {
      if (data.status === 'success' && Array.isArray(data.categories)) {
        // Set the active event_id
        if (data.event_id) {
          localStorage.setItem('current_event_id', data.event_id);
        }
        if (data.categories.length === 0) {
          categoryList.innerHTML = '<p class="text-muted">No categories found.</p>';
          return;
        }
        const voterType = localStorage.getItem('voter_type') || 'new';
        const allowedCategoryIds = JSON.parse(localStorage.getItem('unanswered_categories') || '[]');

        data.categories.forEach(category => {

        if (voterType === 'existing' && !allowedCategoryIds.includes(String(category.id))) return;

        const categoryButton = document.createElement('button');
        categoryButton.setAttribute('type', 'button');
        categoryButton.classList.add('btn', 'btn-tocca-blue', 'w-100', 'mb-2', 'category-item');
        categoryButton.textContent = category.name;

        categoryButton.addEventListener('click', () => {
          localStorage.setItem('selected_category_id', category.id);
          localStorage.setItem('selected_category_name', category.name);
          const eventId = localStorage.getItem('current_event_id') || '1';
          window.location.href = `selected-category.php?category_id=${category.id}&event_id=${eventId}`;
        });
        categoryList.appendChild(categoryButton);
        });
      } else {
        throw new Error(data.message || 'Failed to load categories.');
      }
    })
    .catch(error => {
      console.error('Error loading categories:', error);
      categoryList.innerHTML = '<p class="text-danger">Error loading categories. Please try again later.</p>';
    });
});
