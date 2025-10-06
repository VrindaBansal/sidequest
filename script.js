// Load extended challenges (1000+)
// If challenges-extended.js is loaded, use it, otherwise use basic set
const challenges = typeof challengesExtended !== 'undefined' ? challengesExtended : {
    social: [
        "Text an old friend",
        "Call a family member",
        "Compliment a stranger",
        "Have a conversation without checking your phone",
        "Introduce yourself to someone new"
    ],
    creative: [
        "Draw something for 10 minutes",
        "Write a haiku",
        "Take an artistic photo",
        "Doodle in a notebook",
        "Create something with your hands"
    ],
    wellness: [
        "Meditate for 5 minutes",
        "Drink 8 glasses of water",
        "Take a walk outside",
        "Stretch for 10 minutes",
        "Go to bed 30 minutes early"
    ],
    adventure: [
        "Try a new food",
        "Take a different route home",
        "Visit somewhere new in your city",
        "Order something you've never tried",
        "Explore a new neighborhood"
    ],
    learning: [
        "Learn 3 words in a new language",
        "Read about something random on Wikipedia",
        "Watch a documentary",
        "Listen to a podcast on a new topic",
        "Research something you're curious about"
    ],
    kindness: [
        "Do something nice for someone",
        "Leave a positive review",
        "Pick up litter you see",
        "Thank someone who helped you",
        "Pay for someone's coffee"
    ]
};

const categoryIcons = {
    social: '👥',
    creative: '🎨',
    wellness: '❤️',
    adventure: '🚶',
    learning: '📚',
    kindness: '🤲'
};

const categoryNames = {
    social: 'SOCIAL',
    creative: 'CREATIVE',
    wellness: 'WELLNESS',
    adventure: 'ADVENTURE',
    learning: 'LEARNING',
    kindness: 'KINDNESS'
};

// State
let currentQuest = null;
let completedQuests = [];

// DOM Elements
const mainView = document.getElementById('mainView');
const historyView = document.getElementById('historyView');
const questIcon = document.getElementById('questIcon');
const questText = document.getElementById('questText');
const categoryBadge = document.getElementById('categoryBadge');
const newQuestBtn = document.getElementById('newQuestBtn');
const completeBtn = document.getElementById('completeBtn');
const historyBtn = document.getElementById('historyBtn');
const backBtn = document.getElementById('backBtn');
const historyList = document.getElementById('historyList');
const completedCount = document.getElementById('completedCount');
const successRate = document.getElementById('successRate');
const animationOverlay = document.getElementById('animationOverlay');

// Initialize
function init() {
    loadFromStorage();

    if (!currentQuest || !isToday(currentQuest.date)) {
        generateNewQuest();
    } else {
        displayQuest();
    }

    updateHistoryView();
}

// Generate new quest
function generateNewQuest() {
    const categories = Object.keys(challenges);
    const randomCategory = categories[Math.floor(Math.random() * categories.length)];
    const categoryQuests = challenges[randomCategory];
    const randomQuest = categoryQuests[Math.floor(Math.random() * categoryQuests.length)];

    currentQuest = {
        text: randomQuest,
        category: randomCategory,
        date: new Date().toISOString(),
        completed: false,
        id: Date.now()
    };

    saveToStorage();
    displayQuest();
}

// Display current quest
function displayQuest() {
    if (!currentQuest) return;

    questText.textContent = currentQuest.text;
    questIcon.textContent = categoryIcons[currentQuest.category];
    categoryBadge.textContent = categoryNames[currentQuest.category];

    // Update border color
    const questCard = document.querySelector('.quest-card');
    questCard.className = `quest-card category-${currentQuest.category}`;
    questIcon.className = `icon icon-${currentQuest.category}`;

    // Update complete button
    if (currentQuest.completed) {
        completeBtn.textContent = '✓ DONE!';
        completeBtn.classList.add('completed');
    } else {
        completeBtn.textContent = 'COMPLETE';
        completeBtn.classList.remove('completed');
    }
}

// Play category animation
function playAnimation(category) {
    const animations = {
        social: 'animate-bounce',
        creative: 'animate-spin',
        wellness: 'animate-pulse',
        adventure: 'animate-shake',
        learning: 'animate-pulse',
        kindness: 'animate-float'
    };

    const animationClass = animations[category];
    questIcon.classList.add(animationClass);

    setTimeout(() => {
        questIcon.classList.remove(animationClass);
    }, 600);
}

// Complete quest
function completeQuest() {
    if (!currentQuest || currentQuest.completed) return;

    currentQuest.completed = true;
    completedQuests.push({ ...currentQuest });

    // Show completion animation
    animationOverlay.classList.add('active');

    setTimeout(() => {
        animationOverlay.classList.remove('active');

        // Generate new quest after animation
        setTimeout(() => {
            playAnimation(currentQuest.category);
            setTimeout(() => {
                generateNewQuest();
            }, 600);
        }, 300);
    }, 500);

    saveToStorage();
    updateHistoryView();
}

// Show history view
function showHistory() {
    mainView.classList.remove('active');
    historyView.classList.add('active');
    updateHistoryView();
}

// Show main view
function showMain() {
    historyView.classList.remove('active');
    mainView.classList.add('active');
}

// Update history view
function updateHistoryView() {
    completedCount.textContent = completedQuests.length;
    successRate.textContent = completedQuests.length > 0 ? '100' : '0';

    if (completedQuests.length === 0) {
        historyList.innerHTML = `
            <div class="empty-state">
                <p class="empty-icon">❓</p>
                <p class="empty-text">NO QUESTS COMPLETED YET</p>
                <p class="empty-subtext">Complete your first quest to see it here!</p>
            </div>
        `;
        return;
    }

    historyList.innerHTML = completedQuests
        .slice()
        .reverse()
        .map(quest => `
            <div class="history-item category-${quest.category}">
                <div class="history-icon icon-${quest.category}">${categoryIcons[quest.category]}</div>
                <div class="history-content">
                    <div class="history-category">${categoryNames[quest.category]}</div>
                    <div class="history-text">${quest.text}</div>
                    <div class="history-date">${formatDate(quest.date)}</div>
                </div>
                <div class="history-check">✓</div>
            </div>
        `)
        .join('');
}

// Helper functions
function isToday(dateString) {
    const date = new Date(dateString);
    const today = new Date();
    return date.toDateString() === today.toDateString();
}

function formatDate(dateString) {
    const date = new Date(dateString);
    const options = { month: 'short', day: 'numeric', year: 'numeric' };
    return date.toLocaleDateString('en-US', options);
}

function saveToStorage() {
    localStorage.setItem('currentQuest', JSON.stringify(currentQuest));
    localStorage.setItem('completedQuests', JSON.stringify(completedQuests));
}

function loadFromStorage() {
    const savedQuest = localStorage.getItem('currentQuest');
    const savedCompleted = localStorage.getItem('completedQuests');

    if (savedQuest) {
        currentQuest = JSON.parse(savedQuest);
    }

    if (savedCompleted) {
        completedQuests = JSON.parse(savedCompleted);
    }
}

// Event listeners
newQuestBtn.addEventListener('click', () => {
    playAnimation(currentQuest.category);
    setTimeout(() => {
        generateNewQuest();
    }, 600);
});

completeBtn.addEventListener('click', completeQuest);
historyBtn.addEventListener('click', showHistory);
backBtn.addEventListener('click', showMain);

// Initialize app
init();
