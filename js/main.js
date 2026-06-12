/* ============================================================
   Ember & Plate — Shared Validation & Utilities
   js/main.js
   ============================================================ */

/* ---- Navbar hamburger ---- */
function initNavbar() {
  const ham = document.querySelector('.hamburger');
  const nav = document.querySelector('.nav-links');
  if (!ham) return;
  ham.addEventListener('click', () => nav.classList.toggle('open'));
  // Highlight active link
  const links = document.querySelectorAll('.nav-links a');
  links.forEach(l => {
    if (l.href === window.location.href) l.classList.add('active');
  });
}

/* ---- Validation helpers ---- */
function showError(fieldEl, msg) {
  fieldEl.classList.add('error');
  fieldEl.classList.remove('valid');
  let err = fieldEl.parentElement.querySelector('.error-msg');
  if (!err) { err = document.createElement('span'); err.className = 'error-msg'; fieldEl.parentElement.appendChild(err); }
  err.textContent = msg;
  err.classList.add('show');
  return false;
}

function showValid(fieldEl) {
  fieldEl.classList.remove('error');
  fieldEl.classList.add('valid');
  const err = fieldEl.parentElement.querySelector('.error-msg');
  if (err) err.classList.remove('show');
  return true;
}

function validateField(fieldEl, rules) {
  const val = fieldEl.value.trim();
  if (rules.required && !val) return showError(fieldEl, rules.requiredMsg || 'This field is required.');
  if (rules.minLen && val.length < rules.minLen) return showError(fieldEl, `Minimum ${rules.minLen} characters.`);
  if (rules.maxLen && val.length > rules.maxLen) return showError(fieldEl, `Maximum ${rules.maxLen} characters.`);
  if (rules.email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val)) return showError(fieldEl, 'Enter a valid email address.');
  if (rules.phone && !/^[0-9+\-\s]{8,15}$/.test(val)) return showError(fieldEl, 'Enter a valid phone number.');
  if (rules.pattern && !rules.pattern.test(val)) return showError(fieldEl, rules.patternMsg || 'Invalid format.');
  if (rules.match) {
    const target = document.querySelector(rules.match);
    if (target && val !== target.value.trim()) return showError(fieldEl, rules.matchMsg || 'Fields do not match.');
  }
  return showValid(fieldEl);
}

/* ---- Alert helpers ---- */
function showAlert(id, type, msg) {
  const el = document.getElementById(id);
  if (!el) return;
  el.className = `alert alert-${type} show`;
  el.textContent = msg;
  setTimeout(() => el.classList.remove('show'), 5000);
}

/* ---- Cart (localStorage) ---- */
const Cart = {
  key: 'ep_cart',
  get() { return JSON.parse(localStorage.getItem(this.key) || '[]'); },
  save(items) { localStorage.setItem(this.key, JSON.stringify(items)); },
  add(item) {
    const items = this.get();
    const ex = items.find(i => i.id === item.id);
    if (ex) ex.qty += 1;
    else items.push({ ...item, qty: 1 });
    this.save(items);
    this.updateBadge();
  },
  remove(id) {
    const items = this.get().filter(i => i.id !== id);
    this.save(items); this.updateBadge();
  },
  clear() { localStorage.removeItem(this.key); this.updateBadge(); },
  total() { return this.get().reduce((s, i) => s + i.price * i.qty, 0).toFixed(2); },
  count() { return this.get().reduce((s, i) => s + i.qty, 0); },
  updateBadge() {
    const badge = document.getElementById('cart-badge');
    if (badge) badge.textContent = this.count();
  }
};

/* ---- Tabs ---- */
function initTabs() {
  document.querySelectorAll('.tab-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      const group = btn.closest('[data-tabs]') || btn.closest('.tabs').parentElement;
      group.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
      group.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
      btn.classList.add('active');
      document.getElementById(btn.dataset.tab)?.classList.add('active');
    });
  });
}

/* ---- Filter buttons ---- */
function initFilters() {
  document.querySelectorAll('.filter-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      const cat = btn.dataset.filter;
      document.querySelectorAll('.menu-card').forEach(card => {
        card.style.display = (cat === 'all' || card.dataset.category === cat) ? '' : 'none';
      });
    });
  });
}

/* ---- Init on DOM ready ---- */
document.addEventListener('DOMContentLoaded', () => {
  initNavbar();
  initTabs();
  initFilters();
  Cart.updateBadge();
});
