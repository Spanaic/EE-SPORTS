
import firebase from "@/plugins/firebase"
const actions = {
    // init() {
    //     firebase.initializeApp(config);
    //     firebase.auth().setPersistence(firebase.auth.Auth.Persistence.SESSION);
    // },
    logInGoogle({ commit }) {
        const provider = new firebase.auth.GoogleAuthProvider();
        firebase.auth().signInWithPopup(provider)
            .then(user => {
                commit("onAuthStateChanged", user)
            })
    },
    logIn({ commit }, payload) {
        firebase
            .auth()
            .createUserWithEmailAndPassword(payload[0], payload[1])
            .then(user => {
                commit("onAuthStateChanged", user);
                console.log(payload);
                // axios.post("http://localhost:3001/users", {
                //     email: this.email
                // });
                this.email = "";
                this.password = "";
                console.log("Sign-in successful.");
                this.$router.push("/");
            })
            .catch(err => {
                this.error = err.message;
                this.error_checker = true;
                console.log(this.error_checker);
            });
    },
    logOut({ commit }) {
        firebase
            .auth()
            .signOut()
            .then(user => {
                console.log(user);
                commit("onAuthStateChanged", user)
            })
            .catch(function (error) {
                console.log("An error happened.");
            });
    },
    // onAuth() {
    //     firebase.auth().onAuthStateChanged(user => {
    //         user = user ? user : {};
    //         store.commit('onAuthStateChanged', user);
    //         store.commit('onUserStateChanged', user.uid ? true : false);
    //     });
    // }
}

export default actions