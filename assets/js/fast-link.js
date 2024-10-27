export const FastLink = {
  mounted() {
    const linkEl = this.el;

    linkEl.addEventListener("mousedown", (e) => {
      if (e.button !== 0) return;
      e.preventDefault();
      e.stopImmediatePropagation();
      linkEl.click();
    });
  },
};
