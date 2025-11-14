document.addEventListener('DOMContentLoaded', () => {
  fetch('get_voter_style.php')
    .then(res => res.json())
    .then(data => {
      document.body.style.backgroundColor = data.bgColor;
      document.body.style.color = data.textColor;
      document.body.style.fontSize = data.fontSize;

      // Set CSS custom properties for theme colors
      document.documentElement.style.setProperty('--voter-primary-color', data.primaryColor);
      document.documentElement.style.setProperty('--voter-button-color', data.buttonColor);

      const headerLogo = document.getElementById('headerLogo');
      if (headerLogo && data.headerLogo) {
        headerLogo.src = data.headerLogo;
      }
    })
    .catch(err => console.error('Failed to apply voter style:', err));
});
