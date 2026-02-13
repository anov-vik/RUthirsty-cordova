// 应用主逻辑
const app = {
    // 提醒时间点（小时:分钟）
    reminderTimes: ['06:30', '09:30', '11:30', '13:30', '17:30', '19:30', '21:30'],

    // 初始化
    initialize: function() {
        document.addEventListener('DOMContentLoaded', this.onDeviceReady.bind(this), false);
    },

    // 设备准备就绪
    onDeviceReady: function() {
        console.log('应用已准备就绪');
        this.bindEvents();
        this.loadData();
        this.loadSettings();
        this.updateDisplay();
        this.updateDate();
        this.initNotifications();
        this.startReminderTimer();
    },

    // 绑定事件监听器
    bindEvents: function() {
        document.getElementById('checkinBtn').addEventListener('click', this.handleCheckin.bind(this));
        document.getElementById('clearBtn').addEventListener('click', this.handleClear.bind(this));
        document.getElementById('reminderToggle').addEventListener('change', this.handleReminderToggle.bind(this));
    },

    // 获取今天的日期字符串 (YYYY-MM-DD)
    getTodayString: function() {
        const today = new Date();
        return today.toISOString().split('T')[0];
    },

    // 更新日期显示
    updateDate: function() {
        const today = new Date();
        const options = { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' };
        const dateStr = today.toLocaleDateString('zh-CN', options);
        document.getElementById('currentDate').textContent = dateStr;
    },

    // 从localStorage加载数据
    loadData: function() {
        const todayStr = this.getTodayString();
        const storedData = localStorage.getItem('waterRecords');

        if (storedData) {
            try {
                const allRecords = JSON.parse(storedData);
                // 只保留今天的记录
                this.records = allRecords.filter(record => record.date === todayStr);

                // 如果今天的记录和存储的不一致，说明是新的一天，清理旧数据
                if (this.records.length !== allRecords.length) {
                    this.saveData();
                }
            } catch (e) {
                console.error('数据加载失败:', e);
                this.records = [];
            }
        } else {
            this.records = [];
        }
    },

    // 保存数据到localStorage
    saveData: function() {
        try {
            localStorage.setItem('waterRecords', JSON.stringify(this.records));
        } catch (e) {
            console.error('数据保存失败:', e);
            alert('数据保存失败，请检查存储空间');
        }
    },

    // 处理打卡
    handleCheckin: function() {
        const waterAmount = parseInt(document.getElementById('waterAmount').value) || 200;

        if (waterAmount < 50 || waterAmount > 1000) {
            alert('请输入50-1000ml之间的饮水量');
            return;
        }

        const now = new Date();
        const record = {
            date: this.getTodayString(),
            time: now.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' }),
            timestamp: now.getTime(),
            amount: waterAmount
        };

        this.records.unshift(record); // 添加到数组开头，最新的在最上面
        this.saveData();
        this.updateDisplay();

        // 添加成功动画
        const btn = document.getElementById('checkinBtn');
        btn.classList.add('success-animation');
        setTimeout(() => {
            btn.classList.remove('success-animation');
        }, 500);

        // 可选：添加震动反馈（需要Cordova震动插件）
        if (navigator.vibrate) {
            navigator.vibrate(100);
        }
    },

    // 处理清空记录
    handleClear: function() {
        if (this.records.length === 0) {
            return;
        }

        if (confirm('确定要清空今天的所有记录吗？')) {
            this.records = [];
            this.saveData();
            this.updateDisplay();
        }
    },

    // 更新显示
    updateDisplay: function() {
        // 更新统计数据
        const todayCount = this.records.length;
        const totalWater = this.records.reduce((sum, record) => sum + record.amount, 0);

        document.getElementById('todayCount').textContent = todayCount;
        document.getElementById('totalWater').textContent = totalWater;

        // 检查是否达到1000ml目标，切换主题颜色
        const wasGoalReached = document.body.classList.contains('goal-reached');
        const isGoalReached = totalWater >= 1000;

        if (isGoalReached && !wasGoalReached) {
            // 刚刚达到目标，添加绿色主题并显示祝贺
            document.body.classList.add('goal-reached');
            this.showGoalCelebration();
        } else if (!isGoalReached && wasGoalReached) {
            // 低于目标（清空记录时），移除绿色主题
            document.body.classList.remove('goal-reached');
        } else if (isGoalReached) {
            // 已经达到目标，保持绿色主题
            document.body.classList.add('goal-reached');
        }

        // 更新记录列表
        const recordsList = document.getElementById('recordsList');

        if (this.records.length === 0) {
            recordsList.innerHTML = `
                <div class="empty-state">
                    <p>还没有打卡记录哦</p>
                    <p>点击上方按钮开始打卡吧！</p>
                </div>
            `;
        } else {
            recordsList.innerHTML = this.records.map(record => `
                <div class="record-item">
                    <div class="record-time">${record.time}</div>
                    <div class="record-amount">${record.amount} ml</div>
                </div>
            `).join('');
        }
    },

    // 显示达成目标的庆祝效果
    showGoalCelebration: function() {
        // 显示祝贺 Toast
        const toast = document.getElementById('celebrationToast');
        toast.classList.add('show');

        // 3秒后自动隐藏
        setTimeout(() => {
            toast.classList.remove('show');
        }, 3000);

        // 可选：添加震动反馈
        if (navigator.vibrate) {
            navigator.vibrate([100, 50, 100, 50, 100]);
        }
    },

    // ========== 通知提醒功能 ==========

    // 加载设置
    loadSettings: function() {
        const reminderEnabled = localStorage.getItem('reminderEnabled');
        this.reminderEnabled = reminderEnabled === null ? true : reminderEnabled === 'true';

        // 加载已发送的提醒记录
        const sentRemindersToday = localStorage.getItem('sentRemindersToday');
        const todayStr = this.getTodayString();

        if (sentRemindersToday) {
            try {
                const data = JSON.parse(sentRemindersToday);
                // 如果是今天的记录就使用，否则清空
                this.sentReminders = data.date === todayStr ? data.times : [];
            } catch (e) {
                this.sentReminders = [];
            }
        } else {
            this.sentReminders = [];
        }

        // 更新UI
        const toggle = document.getElementById('reminderToggle');
        if (toggle) {
            toggle.checked = this.reminderEnabled;
        }
    },

    // 保存设置
    saveSettings: function() {
        localStorage.setItem('reminderEnabled', this.reminderEnabled);
    },

    // 保存已发送的提醒
    saveSentReminders: function() {
        const data = {
            date: this.getTodayString(),
            times: this.sentReminders
        };
        localStorage.setItem('sentRemindersToday', JSON.stringify(data));
    },

    // 处理提醒开关切换
    handleReminderToggle: function(e) {
        this.reminderEnabled = e.target.checked;
        this.saveSettings();

        if (this.reminderEnabled) {
            this.showToast('提醒已开启', '每天会在固定时间提醒您喝水');
            // 请求通知权限
            this.requestNotificationPermission();
        } else {
            this.showToast('提醒已关闭', '不再发送喝水提醒');
        }
    },

    // 初始化通知
    initNotifications: function() {
        // 如果启用了提醒，请求通知权限
        if (this.reminderEnabled) {
            this.requestNotificationPermission();
        }
    },

    // 请求通知权限
    requestNotificationPermission: function() {
        if ('Notification' in window) {
            if (Notification.permission === 'default') {
                Notification.requestPermission().then(permission => {
                    if (permission === 'granted') {
                        console.log('通知权限已授予');
                    } else {
                        console.log('通知权限被拒绝');
                        this.reminderEnabled = false;
                        this.saveSettings();
                        document.getElementById('reminderToggle').checked = false;
                    }
                });
            }
        }
    },

    // 启动提醒定时器
    startReminderTimer: function() {
        // 每分钟检查一次是否需要发送提醒
        setInterval(() => {
            this.checkAndSendReminder();
        }, 60000); // 60秒

        // 立即检查一次
        this.checkAndSendReminder();
    },

    // 检查并发送提醒
    checkAndSendReminder: function() {
        if (!this.reminderEnabled) {
            return;
        }

        const now = new Date();
        const currentTime = now.getHours().toString().padStart(2, '0') + ':' +
                           now.getMinutes().toString().padStart(2, '0');

        // 检查当前时间是否匹配提醒时间点
        if (this.reminderTimes.includes(currentTime)) {
            // 检查今天这个时间点是否已经发送过提醒
            if (!this.sentReminders.includes(currentTime)) {
                this.sendWaterReminder(currentTime);
                this.sentReminders.push(currentTime);
                this.saveSentReminders();
            }
        }
    },

    // 发送喝水提醒
    sendWaterReminder: function(time) {
        console.log('发送提醒:', time);

        // 震动提醒
        if (navigator.vibrate) {
            navigator.vibrate([200, 100, 200]);
        }

        // 浏览器通知
        if ('Notification' in window && Notification.permission === 'granted') {
            const notification = new Notification('💧 该喝水啦！', {
                body: `现在是 ${time}，记得喝一杯水哦~`,
                icon: 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><text y="75" font-size="75">💧</text></svg>',
                badge: 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><text y="75" font-size="75">💧</text></svg>',
                tag: 'water-reminder',
                requireInteraction: false,
                silent: false
            });

            // 点击通知时聚焦窗口
            notification.onclick = function() {
                window.focus();
                notification.close();
            };

            // 3秒后自动关闭
            setTimeout(() => {
                notification.close();
            }, 5000);
        }

        // 显示应用内提醒
        this.showToast('💧 该喝水啦！', `现在是 ${time}，记得喝一杯水哦~`, 5000);
    },

    // 显示Toast提示（通用）
    showToast: function(title, message, duration = 3000) {
        const toast = document.getElementById('celebrationToast');
        const titleEl = toast.querySelector('.toast-title');
        const textEl = toast.querySelector('.toast-text');

        titleEl.textContent = title;
        textEl.textContent = message;

        toast.classList.add('show');

        setTimeout(() => {
            toast.classList.remove('show');
            // 恢复默认文本
            setTimeout(() => {
                titleEl.textContent = '太棒了！';
                textEl.textContent = '今天已经喝够1000ml水了！';
            }, 500);
        }, duration);
    },

    records: [],
    reminderEnabled: true,
    sentReminders: []
};

// 启动应用
app.initialize();
