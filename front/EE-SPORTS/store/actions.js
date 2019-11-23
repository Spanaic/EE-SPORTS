// firebaseにアクセスし、認証してオッケーだったらmutaions.jsのsetUserを(引数のpayloadにuserを代入しつつ)実行
import firebase from "@/plugins/firebase"
// import { executionAsyncId } from "async_hooks";
import axios from '@/plugins/axios'

const actions = {
    // init() {
    //     firebase.initializeApp(config);
    //     firebase.auth().setPersistence(firebase.auth.Auth.Persistence.SESSION);
    // },
    logInGoogle({ commit }, payload) {
        const provider = new firebase.auth.GoogleAuthProvider();
        firebase.auth().signInWithPopup(provider)
            .then(user => {
                commit("setUser", user)
                const end_user = {
                    email: payload[0],
                    name: payload[1],
                }
                axios.post("/end_users", { end_user })
                console.log(payload)
                console.log('sign up success')
                this.$router.push("/")
            })
    },
    // logIn({ commit }, payload) {
    //     firebase.auth()
    //         .signInWithEmailAndPassword(payload[0], payload[1])
    //     const { data } = axios.get(`/end_users?email=${payload[0]}`);
    //     debugger;
    //     commit('setUser', data[0])
    //     console.log(data[0])
    //     this.$router.push("/post_Images");
    // },


    logIn({ commit }, payload) {
        firebase.auth()
            .signInWithEmailAndPassword(payload[0], payload[1])
            // console.log(data)
            .then(user => {
                commit("setUser", user);
                console.log('login success!')
                // this.$router.go("/post_Images");
                this.$router.push("/post_Images");
            })
            .catch(function (error) {
                // Handle Errors here.
                var errorCode = error.code;
                var errorMessage = error.message;
                // ...
            });

        // firebase
        //     .auth()
        //     .createUserWithEmailAndPassword(payload[0], payload[1])
        //     .then(user => {
        //         commit("setUser", user);
        //         console.log(user.user.email);
        //         // axios.post("http://localhost:3001/users", {
        //         //     email: this.email
        //         // });
        //         this.email = "";
        //         this.password = "";
        //         console.log("Sign-in successful.");
        //         // this.$router.push("/");
        //     })
        //     .catch(err => {
        //         this.error = err.message;
        //         this.error_checker = true;
        //         console.log(this.error_checker);
    },
    logOut({ commit }) {
        firebase
            .auth()
            .signOut()
            .then(user => {
                console.log(user);
                commit("setUser", { id: 0 });
                console.log('logout success!')
                this.$router.push("/post_Images")
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
                console.log(user)
                commit('setUser', user)

                const end_user = {
                    email: user.user.email,
                    name: payload[2],
                    profile_name: payload[3]
                }
                axios.post("/end_users", { end_user })
                    .then(user => {
                        commit("setUser", user.data)
                        this.$router.push(`/end_users/${user.data.id}`)
                    })
                    // this.$router.go("/post_images", user)
                    // )
                    .catch((err) => {
                        alert(err)
                    })
                // console.log(payload)
                // console.log('sign up success')
            })
            .catch(err => {
                alert(err)
            });
    },
    async searchSubmit({ commit }, payload) {
        firebase
        try {
            const res = await axios.get(
                `/searches?search=${payload}`
            );
            const searchResult = res.data
            // &title=${payload}&profile_name=${payload}
            console.log(searchResult);
            commit('setSearchResult', searchResult);
            this.$router.push("/post_Images/")
            this.keyword = "";
        } catch (err) {
            alert(err);
        }
    },
    testLogIn({ commit }, payload) {
        firebase.auth()
            .signInWithEmailAndPassword(payload[0], payload[1])
            // console.log(data)
            .then(user => {
                commit("setUser", user);
                console.log('login success!')
                this.$router.push("/post_Images");
                // this.$router.go("/post_images");
            })
            .catch(function (error) {
                // Handle Errors here.
                alert(error);
                // var errorCode = error.code;
                // var errorMessage = error.message;
                // ...
            });
    },
    authCheck({ commit }) {
        firebase.auth().onAuthStateChanged(async user => {
            if (user) {
                // console.log(user)
                const { data } =
                    await axios.get(`/end_users?email=${user.email}`)
                commit('setUser', data[0])
                console.log(data);
            }
        })
    },
    async notificationsCheck({ commit }, payload) {
        try {
            console.log("notificationsCheck")
            const res = await axios.get(`/notifications/${payload.id}`);
            let notifications = res.data.filter(notification => {
                return notification.checked === false
            });
            console.log("setNotifications_check", notifications)
            // commit('setNotifications', notifications);
            console.log("res.data", res.data);
            commit('setNotifications', notifications);
        } catch (err) {
            console.log("setNotifications_err", err)
        }
    },
    async showNotifications({ commit }, payload) {
        try {
            console.log("showNotifications")
            console.log("payload", payload)
            const res = await axios.put(`/notifications/${payload[0]}`, { id: payload[0], end_user_id: payload[1] })
            let notifications = res.data.filter(notification => {
                return notification.checked === false
            });
            commit('setNotifications', notifications);
        } catch (err) {
            console.log("setNotifications_err", err)
        }
    }
    // onAuth() {
    //     firebase.auth().onAuthStateChanged(user => {
    //         user = user ? user : {};
    //         store.commit('onAuthStateChanged', user);
    //         store.commit('onUserStateChanged', user.uid ? true : false);
    //     });
    // }
}

export default actions;