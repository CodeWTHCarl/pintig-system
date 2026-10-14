// portal_web/src/config/firebase.ts
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";

const firebaseConfig = {
  apiKey: "AIzaSyD-8cINNdnwGzmunFDYvLvCNuqrCyqGmvA",
  authDomain: "pintig-219.firebaseapp.com",
  projectId: "pintig-219",
  storageBucket: "pintig-219.firebasestorage.app",
  messagingSenderId: "431677351996",
  appId: "1:431677351996:web:d03b4c732af930cac73b39"
};

// Initialize Firebase App
const app = initializeApp(firebaseConfig);

// Initialize Cloud Firestore and export for components to use
export const db = getFirestore(app);