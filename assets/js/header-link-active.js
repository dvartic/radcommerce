export const HeaderLinkActive = {
  mounted() {
    const productLink = this.el
    
    if (productLink) {
      const updateLinkClass = () => {
        const currentPath = window.location.pathname;
        const linkPath = productLink.getAttribute('href');

        if (currentPath === linkPath) {
          productLink.classList.remove('link-hover');
        } else {
          productLink.classList.add('link-hover');
        }
      };

      // Initial check
      updateLinkClass();

      // Add event listener for navigation changes
      window.addEventListener('phx:page-loading-stop', updateLinkClass);
    }
  }
};
