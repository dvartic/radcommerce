export const ChangeLanguageSelector = {
  mounted() {
    const form = this.el;
    const select = form.querySelector('select');

    if (select) {
      select.addEventListener('change', async function () {
        const selectedLocale = this.value;
        try {
          const response = await fetch('/change_language', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute("content")
            },
            body: JSON.stringify({ locale: selectedLocale })
          });
          if (response.ok) {
            window.location.reload();
          } else {
            console.error('Failed to change language');
          }
        } catch (error) {
          console.error('Error:', error);
        }
      });
    }
  }
};
