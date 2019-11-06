import firebase from "firebase"
// import store from "~/store";


var firebaseConfig = {
    apiKey: process.env.API_KEY,
    authDomain: process.env.AUTH_DOMAIN,
    databaseURL: process.env.DATABASE_URL,
    projectId: process.env.PROJECT_ID,
    storageBucket: process.env.STORAGE_BUCKET,
    messagingSenderId: process.env.MESSAGING_SENDER_ID,
    appId: process.env.APP_ID
};

// Initialize Firebase
// firebase.initializeApp(firebaseConfig);

if (!firebase.apps.length) {
    firebase.initializeApp(firebaseConfig)
}

export default firebase

// export default {
//     init() {
//         firebase.initializeApp(config);
//         firebase.auth().setPersistence(firebase.auth.Auth.Persistence.SESSION);
//     },
//     login() {
//         const provider = new firebase.auth.GoogleAuthProvider();
//         firebase.auth().signInWithPopup(provider)
//     },
//     logout() {
//         firebase.auth().signOut()
//     },
//     onAuth() {
//         firebase.auth().onAuthStateChanged(user => {
//             user = user ? user : {};
//             store.commit('onAuthStateChanged', user);
//             store.commit('onUserStateChanged', user.uid ? true : false);
//         });
//     }
// };