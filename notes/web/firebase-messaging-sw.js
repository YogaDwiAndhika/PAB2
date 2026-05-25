importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js");

// Gunakan konfigurasi web dari firebase_options.dart Anda
firebase.initializeApp({
  apiKey: "AIzaSyC57tfVm35uZjktwu21vrwPYCKsa25BezE",
  authDomain: "notes-48840.firebaseapp.com",
  projectId: "notes-48840",
  storageBucket: "notes-48840.firebasestorage.app",
  messagingSenderId: "1009657520905",
  appId: "1:1009657520905:web:2285cd09fcb8b5e43ae9d8",
  measurementId: "G-LVVSN3T08N"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const notificationTitle = payload.notification.title || "Notifikasi Baru";
  const notificationOptions = {
    body: payload.notification.body || "Anda memiliki pesan baru.",
    icon: "/favicon.png",
  };
  return self.registration.showNotification(notificationTitle, notificationOptions);
});
