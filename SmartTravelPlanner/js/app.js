const TravelMate = (() => {
	const keys = { user: 'travelmate_user', trips: 'travelmate_trips', expenses: 'travelmate_expenses', checklist: 'travelmate_checklist', theme: 'travelmate_theme' };
	const seedTrips = [
		{ id: 'trip-1', destination: 'Lisbon, Portugal', startDate: '2026-10-04', endDate: '2026-10-11', budget: 2400, hotel: 'Casa do Sol', transportation: 'Flight + Metro', notes: 'Explore Alfama and Sintra.' },
		{ id: 'trip-2', destination: 'Kyoto, Japan', startDate: '2026-11-16', endDate: '2026-11-25', budget: 3600, hotel: 'Hana Ryokan', transportation: 'Flight + Rail Pass', notes: 'Autumn temples and food tour.' }
	];
	const seedExpenses = [
		{ id: 'expense-1', tripId: 'trip-1', title: 'Accommodation deposit', amount: 420, category: 'Accommodation', date: '2026-09-03' },
		{ id: 'expense-2', tripId: 'trip-1', title: 'Museum passes', amount: 78, category: 'Activities', date: '2026-09-05' }
	];
	const seedChecklist = [
		{ id: 'check-1', text: 'Confirm passport validity', completed: true },
		{ id: 'check-2', text: 'Book travel insurance', completed: false },
		{ id: 'check-3', text: 'Download offline maps', completed: false }
	];
	const read = (key, fallback = []) => { const value = localStorage.getItem(key); return value ? JSON.parse(value) : fallback; };
	const write = (key, value) => localStorage.setItem(key, JSON.stringify(value));
	const uid = (prefix) => `${prefix}-${Date.now()}-${Math.random().toString(36).slice(2, 7)}`;
	const currentUser = () => read(keys.user, null);
	const formatCurrency = (amount) => new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', maximumFractionDigits: 0 }).format(Number(amount) || 0);
	const formatDate = (date) => date ? new Intl.DateTimeFormat('en-US', { month: 'short', day: 'numeric', year: 'numeric' }).format(new Date(`${date}T00:00:00`)) : '-';
	const statusFor = (trip) => { const today = new Date().toISOString().slice(0, 10); if (trip.endDate < today) return 'Completed'; if (trip.startDate <= today) return 'Active'; return 'Upcoming'; };
	const initData = () => { if (!localStorage.getItem(keys.trips)) write(keys.trips, seedTrips); if (!localStorage.getItem(keys.expenses)) write(keys.expenses, seedExpenses); if (!localStorage.getItem(keys.checklist)) write(keys.checklist, seedChecklist); };
	const showToast = (message) => { let toast = document.querySelector('.toast'); if (!toast) { toast = document.createElement('div'); toast.className = 'toast'; document.body.append(toast); } toast.textContent = message; toast.classList.add('show'); setTimeout(() => toast.classList.remove('show'), 2600); };
	const setupTheme = () => { const saved = localStorage.getItem(keys.theme) || 'light'; document.documentElement.dataset.theme = saved; document.querySelectorAll('[data-theme-toggle]').forEach((button) => button.addEventListener('click', () => { const next = document.documentElement.dataset.theme === 'dark' ? 'light' : 'dark'; document.documentElement.dataset.theme = next; localStorage.setItem(keys.theme, next); })); };
	const setupNavigation = () => { const menu = document.querySelector('[data-menu-toggle]'); const sidebar = document.querySelector('.sidebar'); menu?.addEventListener('click', () => sidebar?.classList.toggle('open')); document.querySelector('[data-logout]')?.addEventListener('click', () => { localStorage.removeItem(keys.user); window.location.href = '../index.html'; }); const path = window.location.pathname.split('/').pop() || 'index.html'; document.querySelectorAll('.nav-link').forEach((link) => { if (link.getAttribute('href')?.endsWith(path)) link.classList.add('active'); }); };
	const requireUser = () => { if (!currentUser()) { window.location.href = window.location.pathname.includes('/pages/') ? 'login.html' : 'pages/login.html'; return false; } return true; };
	const setupShell = () => { initData(); setupTheme(); setupNavigation(); const user = currentUser(); document.querySelectorAll('[data-user-name]').forEach((element) => element.textContent = user?.name || 'Traveler'); document.querySelectorAll('[data-user-email]').forEach((element) => element.textContent = user?.email || ''); document.querySelectorAll('[data-user-initials]').forEach((element) => element.textContent = (user?.name || 'T').split(' ').map((part) => part[0]).join('').slice(0, 2).toUpperCase()); return user; };
	return { keys, read, write, uid, currentUser, formatCurrency, formatDate, statusFor, showToast, setupShell, requireUser };
})();
