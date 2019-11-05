
import firebase from "firebase"




// var firebaseConfig = {
//     apiKey: process.env.API_KEY,
//     authDomain: process.env.AUTH_DOMAIN,
//     databaseURL: process.env.DATABASE_URL,
//     projectId: process.env.PROJECT_ID,
//     storageBucket: process.env.STORAGE_BUCKET,
//     messagingSenderId: process.env.MESSAGING_SENDER_ID,
//     appId: process.env.APP_ID
// };
var firebaseConfig = {
    apiKey: "AIzaSyAkveW6kT9EbZVBB8kyZObPvgbkX0Nj14g",
    authDomain: "ee-sports.firebaseapp.com",
    databaseURL: "https://ee-sports.firebaseio.com",
    projectId: "ee-sports",
    storageBucket: "ee-sports.appspot.com",
    messagingSenderId: "636627745511",
    appId: "1:636627745511:web:86d8560ba4d67b4f890042"
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);

export default firebase