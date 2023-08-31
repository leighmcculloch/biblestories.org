// Language selector.
(function () {
  document.querySelectorAll('.language-selector select').forEach(e => {
    e.addEventListener("change", () => {
      window.location.href = e.value
    })
  });
})();

// Search.
(function () {
  document.querySelectorAll('.search .query').forEach(e => {
    e.addEventListener("keyup", (event) => {
      /* ESC Key */
      if (event.keyCode == 27) {
        e.value = '';
      }

      const query = e.value.trim().toLowerCase();

      let count = 0;
      document.querySelectorAll('.stories .story').forEach(e => {
        if (query.length > 0 && !e.textContent.toLowerCase().includes(query)) {
          e.style.display = "none";
        } else {
          e.style.display = "block";
          count++;
        }
      });
      document.querySelectorAll('.search-no-results').forEach(e =>
        e.style.display = count > 0 ? "none" : "block");
    });
  })
})();

// Verses.
(function () {
  document.querySelectorAll('.toggle-verses').forEach(e => {
    e.addEventListener("click", () => {
      document.querySelectorAll('.text').forEach(t => {
        t.classList.toggle('show-verses');
      })
    });
  })
})();
