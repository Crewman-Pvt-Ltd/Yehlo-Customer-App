importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyBO4dKvmV3GetE6T21yGz5jtdbVQO76IEM",
    authDomain: "yehlo-4921f.firebaseapp.com",
    databaseURL: "https://yehlo-4921f-default-rtdb.asia-southeast1.firebasedatabase.app",
    projectId: "yehlo-4921f",
    storageBucket: "yehlo-4921f.appspot.com",
    messagingSenderId: "440975246236",
    appId: "1:440975246236:web:5886cd04ac28cc34793e59",
    measurementId: "G-QS68YTLL4B"
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
            };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});