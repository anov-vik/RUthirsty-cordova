document.addEventListener('deviceready', onDeviceReady, false);

const STORAGE_KEY = 'waterCheckInRecords';
const REMINDER_INTERVAL = 2 * 60 * 60 * 1000; // 2小时（毫秒）
const LAST_REMINDER_KEY = 'lastReminderTime';

let records = [];
let reminderTimer = null;
let countdownTimer = null;

function onDeviceReady() {
    console.log('Running cordova-' + cordova.platformId + '@' + cordova.version);

    loadRecords();
    updateUI();

    const checkInBtn = document.getElementById('checkInBtn');
    checkInBtn.addEventListener('click', handleCheckIn);

    const clearBtn = document.getElementById('clearBtn');
    clearBtn.addEventListener('click', handleClearAll);

    // 启动定时提醒
    startReminder();
    requestNotificationPermission();

    // 启动倒计时显示
    startCountdownDisplay();
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

    // 打卡后重置提醒时间
    resetReminder();
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
            <div class="record-actions">
                <span class="record-icon">💧</span>
                <button class="delete-btn" data-id="${record.id}">删除</button>
            </div>
        </div>
    `).join('');

    // Add event listeners for delete buttons
    document.querySelectorAll('.delete-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            const recordId = parseInt(e.target.getAttribute('data-id'));
            handleDeleteRecord(recordId);
        });
    });
}

function handleClearAll() {
    if (records.length === 0) {
        alert('暂无记录可清空');
        return;
    }

    if (confirm('确定要清空所有记录吗？此操作无法撤销。')) {
        records = [];
        saveRecords();
        updateUI();
    }
}

function handleDeleteRecord(recordId) {
    records = records.filter(record => record.id !== recordId);
    saveRecords();
    updateUI();
}

// 请求通知权限
function requestNotificationPermission() {
    if ('Notification' in window && Notification.permission === 'default') {
        Notification.requestPermission();
    }
}

// 显示通知提醒
function showNotification() {
    const title = '💧 喝水提醒';
    const options = {
        body: '该喝水啦！记得补充水分哦~',
        icon: 'img/logo.png',
        badge: 'img/logo.png',
        vibrate: [200, 100, 200],
        tag: 'water-reminder',
        requireInteraction: false
    };

    // 浏览器通知
    if ('Notification' in window && Notification.permission === 'granted') {
        new Notification(title, options);
    }

    // Cordova本地通知（如果有插件）
    if (window.cordova && window.cordova.plugins && window.cordova.plugins.notification) {
        window.cordova.plugins.notification.local.schedule({
            title: title,
            text: options.body,
            foreground: true
        });
    }

    // 浏览器alert作为后备方案
    if (!('Notification' in window) || Notification.permission !== 'granted') {
        alert('💧 该喝水啦！记得补充水分哦~');
    }
}

// 启动定时提醒
function startReminder() {
    // 清除现有定时器
    if (reminderTimer) {
        clearInterval(reminderTimer);
    }

    // 检查上次提醒时间
    checkAndRemind();

    // 设置定时器，每分钟检查一次
    reminderTimer = setInterval(checkAndRemind, 60 * 1000);
}

// 检查是否需要提醒
function checkAndRemind() {
    const now = Date.now();
    const lastReminder = localStorage.getItem(LAST_REMINDER_KEY);

    if (!lastReminder) {
        // 首次运行，设置初始时间
        localStorage.setItem(LAST_REMINDER_KEY, now.toString());
        return;
    }

    const timeSinceLastReminder = now - parseInt(lastReminder);

    // 如果距离上次提醒超过2小时，显示提醒
    if (timeSinceLastReminder >= REMINDER_INTERVAL) {
        showNotification();
        localStorage.setItem(LAST_REMINDER_KEY, now.toString());
    }
}

// 重置提醒时间（打卡后调用）
function resetReminder() {
    const now = Date.now();
    localStorage.setItem(LAST_REMINDER_KEY, now.toString());
    console.log('提醒时间已重置，2小时后将再次提醒');
}

// 更新倒计时显示
function updateCountdownDisplay() {
    const now = Date.now();
    const lastReminder = localStorage.getItem(LAST_REMINDER_KEY);

    if (!lastReminder) {
        document.getElementById('countdown').textContent = '--:--:--';
        return;
    }

    const timeSinceLastReminder = now - parseInt(lastReminder);
    const remainingTime = REMINDER_INTERVAL - timeSinceLastReminder;

    if (remainingTime <= 0) {
        document.getElementById('countdown').textContent = '00:00:00';
        return;
    }

    // 计算小时、分钟、秒
    const hours = Math.floor(remainingTime / (60 * 60 * 1000));
    const minutes = Math.floor((remainingTime % (60 * 60 * 1000)) / (60 * 1000));
    const seconds = Math.floor((remainingTime % (60 * 1000)) / 1000);

    // 格式化显示
    const formattedTime =
        String(hours).padStart(2, '0') + ':' +
        String(minutes).padStart(2, '0') + ':' +
        String(seconds).padStart(2, '0');

    document.getElementById('countdown').textContent = formattedTime;
}

// 启动倒计时显示
function startCountdownDisplay() {
    // 立即更新一次
    updateCountdownDisplay();

    // 每秒更新一次
    countdownTimer = setInterval(updateCountdownDisplay, 1000);
}
