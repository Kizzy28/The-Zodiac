importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging-compat.js");

const firebaseConfig = {
  apiKey: "AIzaSyA0GZBvhKYlGnGa68XUrBzFxmGaeH1E3po",
  authDomain: "elective-project-1.firebaseapp.com",
  projectId: "elective-project-1",
  storageBucket: "elective-project-1.firebasestorage.app",
  messagingSenderId: "734054227626",
  appId: "1:734054227626:web:aaba16073c60b2765afad3",
};

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});
