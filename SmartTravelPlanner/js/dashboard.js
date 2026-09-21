document.addEventListener('DOMContentLoaded', () => {
	if (!TravelMate.requireUser()) return;
	TravelMate.setupShell();
	const trips = TravelMate.read(TravelMate.keys.trips);
	const expenses = TravelMate.read(TravelMate.keys.expenses);
	const checklist = TravelMate.read(TravelMate.keys.checklist);
	const today = new Date();
	const currentMonthStart = new Date(today.getFullYear(), today.getMonth(), 1);
	const currentMonthEnd = new Date(today.getFullYear(), today.getMonth() + 1, 0, 23, 59, 59, 999);
	const tripsThisMonth = trips.filter((trip) => {
		const startDate = new Date(`${trip.startDate}T00:00:00`);
		return startDate >= currentMonthStart && startDate <= currentMonthEnd;
	}).length;
	const completedTrips = trips.filter((trip) => TravelMate.statusFor(trip) === 'Completed').length;
	const upcomingTrips = trips.filter((trip) => TravelMate.statusFor(trip) === 'Upcoming').length;
	const plannedBudget = trips.reduce((sum, trip) => sum + Number(trip.budget), 0);
	const spent = expenses.reduce((sum, expense) => sum + Number(expense.amount), 0);
	document.querySelector('#dashboard-stats').innerHTML = `
		<article class="card stat-card">
			<span class="stat-label">Trips this month</span>
			<strong class="stat-value">${tripsThisMonth}</strong>
			<span class="stat-note">Planned for this month</span>
		</article>
		<article class="card stat-card">
			<span class="stat-label">Trips completed</span>
			<strong class="stat-value">${completedTrips}</strong>
			<span class="stat-note">Trips already wrapped up</span>
		</article>
		<article class="card stat-card">
			<span class="stat-label">Upcoming trips</span>
			<strong class="stat-value">${upcomingTrips}</strong>
			<span class="stat-note">Scheduled ahead</span>
		</article>
		<article class="card stat-card">
			<span class="stat-label">Planned budget</span>
			<strong class="stat-value">${TravelMate.formatCurrency(plannedBudget)}</strong>
			<span class="stat-note">${TravelMate.formatCurrency(spent)} spent so far</span>
		</article>
	`;
	const upcoming = trips.filter((trip) => TravelMate.statusFor(trip) !== 'Completed').sort((a, b) => a.startDate.localeCompare(b.startDate)).slice(0, 3);
	document.querySelector('#upcoming-trips').innerHTML = upcoming.length ? upcoming.map((trip) => `<div class="list-item"><div><strong>${trip.destination}</strong><small class="muted" style="display:block">${TravelMate.formatDate(trip.startDate)} - ${TravelMate.formatDate(trip.endDate)}</small></div><span class="status status-${TravelMate.statusFor(trip).toLowerCase()}">${TravelMate.statusFor(trip)}</span></div>`).join('') : '<div class="empty-state">No upcoming trips yet.</div>';
	const completedChecklistItems = checklist.filter((item) => item.completed).length;
	const checklistPercent = checklist.length ? Math.round(completedChecklistItems / checklist.length * 100) : 0;
	document.querySelector('#checklist-progress').innerHTML = `<strong>${checklistPercent}% ready</strong><div class="progress" style="margin:.7rem 0"><div class="progress-bar" style="width:${checklistPercent}%"></div></div><p class="muted">${completedChecklistItems} of ${checklist.length} items complete.</p>`;
});
