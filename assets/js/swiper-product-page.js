// SWIPER core version + navigation, pagination modules:
import Swiper from "swiper";
import { Navigation, Pagination } from "swiper/modules";

export const SwiperProductPage = {
  mounted() {
    const swiper = new Swiper(this.el, {
      // configure Swiper to use modules
      modules: [Navigation, Pagination],

      // Optional parameters
      direction: "horizontal",

      // If we need pagination
      pagination: {
        el: ".swiper-pagination",
        clickable: true,
      },

      // Navigation arrows
      navigation: {
        nextEl: ".swiper-button-next",
        prevEl: ".swiper-button-prev",
      },
    });
    // Add click event listeners to thumbnails
    const thumbnails = document.querySelectorAll('[id^="swiper-thumbnail-"]');

    const updateActiveThumbnail = (index, previousIndex) => {
      if (previousIndex !== undefined) {
        thumbnails[previousIndex].classList.remove('ring-accent');
        thumbnails[previousIndex].classList.add('ring-neutral-content');
      }
      thumbnails[index].classList.remove('ring-neutral-content');
      thumbnails[index].classList.add('ring-accent');
    };

    // Update src of maximized image
    const updateMaxImageModal = (index) => {
      const maxImageModal = document.getElementById('max-image-modal-image');
      if (maxImageModal) {
        const imgSrcList = JSON.parse(maxImageModal.dataset.imgSrcList);
        if (imgSrcList && imgSrcList[index]) {
          maxImageModal.src = imgSrcList[index];
        }
      }
    };

    thumbnails.forEach((thumbnail) => {
      thumbnail.addEventListener("click", (event) => {
        const index = parseInt(event.currentTarget.dataset.index, 10);
        swiper.slideTo(index);
      });
    });

    // Update active thumbnail on slide change
    swiper.on('slideChange', () => {
      updateActiveThumbnail(swiper.realIndex, swiper.previousIndex);
      updateMaxImageModal(swiper.realIndex);
    });

    // Set initial active thumbnail
    updateActiveThumbnail(swiper.realIndex);
    updateMaxImageModal(swiper.realIndex);
  },
};
