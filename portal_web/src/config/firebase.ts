import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';

// Configuration placeholder for local dev / Spark testing
const firebaseConfig = {
  apiKey: "AIzaSyDummyKeyForLocalDevOrSparkDemo",
  authDomain: "pintig-spark-dev.firebaseapp.com",
  projectId: "pintig-spark-dev",
  storageBucket: "pintig-spark-dev.appspot.com",
  messagingSenderId: "1234567890",
  appId: "1:1234567890:web:abcdef123456"
};

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);