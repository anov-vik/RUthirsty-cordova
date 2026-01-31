document.addEventListener('deviceready', onDeviceReady, false);

const STORAGE_KEY = 'waterCheckInRecords';

let records = [];

function onDeviceReady() {
    console.log('Running cordova-' + cordova.platformId + '@' + cordova.version);

    loadRecords();
    updateUI();

    const checkInBtn = document.getElementById('checkInBtn');
    checkInBtn.addEventListener('click', handleCheckIn);
}

function loadRecords() {
    const storedRecords = localStorage.getItem(STORAGE_KEY);
    if (storedRecords) {
        records = JSON.parse(storedRecords);
    }
}

function saveRecords() {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(records));
}

function handleCheckIn() {
    const now = new Date();
    const record = {
        id: Date.now(),
        timestamp: now.toISOString(),
        date: now.toLocaleDateString('zh-CN'),
        time: now.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
    };

    records.unshift(record);
    saveRecords();

    const btn = document.getElementById('checkInBtn');
    btn.classList.add('success-animation');
    setTimeout(() => {
        btn.classList.remove('success-animation');
    }, 500);

    updateUI();
}

function getTodayCount() {
    const today = new Date().toLocaleDateString('zh-CN');
    return records.filter(record => record.date === today).length;
}

function updateUI() {
    const todayCount = getTodayCount();
    document.getElementById('todayCount').textContent = todayCount;

    const recordsList = document.getElementById('recordsList');

    if (records.length === 0) {
        recordsList.innerHTML = '<p class="empty-message">暂无记录，点击上方按钮开始打卡吧！</p>';
        return;
    }

    recordsList.innerHTML = records.map(record => `
        <div class="record-item">
            <div class="record-time">
                ${record.date} ${record.time}
            </div>
            <div class="record-icon">💧</div>
        </div>
    `).join('');
}
