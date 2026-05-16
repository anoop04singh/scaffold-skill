const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.classList.add("in-view");
    }
  });
}, { threshold: 0.16 });

document.querySelectorAll('.reveal').forEach((el) => observer.observe(el));

const topbar = document.querySelector('.topbar');
window.addEventListener('scroll', () => {
  const y = window.scrollY;
  topbar.style.boxShadow = y > 4 ? '0 8px 16px rgba(0,0,0,0.05)' : 'none';
});
