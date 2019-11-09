
import firebase from "@/plugins/firebase"
// import { executionAsyncId } from "async_hooks";
import axios from '~/plugins/axios'

const actions = {
    // init() {
    //     firebase.initializeApp(config);
    //     firebase.auth().setPersistence(firebase.auth.Auth.Persistence.SESSION);
    // },
    logInGoogle({ commit }) {
        const provider = new firebase.auth.GoogleAuthProvider();
        firebase.auth().signInWithPopup(provider)
            .then(user => {
                commit("setUser", user)
            })
    },
    logIn({ commit }, payload) {
        firebase
            .auth()
            .createUserWithEmailAndPassword(payload[0], payload[1])
            .then(user => {
                commit("setUser", user);
                console.log(user.user.email);
                // axios.post("http://localhost:3001/users", {
                //     email: this.email
                // });
                this.email = "";
                this.password = "";
                console.log("Sign-in successful.");
                // this.$router.push("/");
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
                commit("setUser", user)
                console.log('logout success!')
            })
            .catch(function (error) {
                console.log("An error happened.");
            });
    },
    signUp({ commit }, payload) {
        firebase
            .auth()
            .createUserWithEmailAndPassword(
                payload[0],
                payload[1],
            )
            .then(user => {
                commit('setUser', user)
                const end_user = {
                    email: user.user.email,
                    name: payload[2],
                    profile_name: payload[3]
                }
                axios.post("/end_users", { end_user })
                console.log(payload)
                console.log('sign up success')
                // this.$router.push({name: postImages, params: index })
            });
    }
    // onAuth() {
    //     firebase.auth().onAuthStateChanged(user => {
    //         user = user ? user : {};
    //         store.commit('onAuthStateChanged', user);
    //         store.commit('onUserStateChanged', user.uid ? true : false);
    //     });
    // }
}

export default actions