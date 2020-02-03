import firebase from "@/plugins/firebase"
import axios from '@/plugins/axios'

const actions = {
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
                this.$router.push("/")
            })
    },
    logIn({ commit }, payload) {
        firebase.auth()
            .signInWithEmailAndPassword(payload[0], payload[1])
            .then(user => {
                commit("setUser", user);
                commit("changeLoading", false)
                this.$router.push("/post_Images");
            })
            .catch(function (error) {
                var errorCode = error.code;
                var errorMessage = error.message;
            });
    },
    logOut({ commit }) {
        firebase
            .auth()
            .signOut()
            .then(user => {
                commit("setUser", { id: 0 });
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
                console.log("user", user)
                commit('setUser', user)

                const end_user = {
                    email: user.user.email,
                    name: payload[2],
                    profile_name: payload[3]
                }
                console.log("end_user", end_user)
                console.log("axios", axios)
                // console.log("process.env.BASE_URL", process.env.BASE_URL)
                axios.post("/end_users", { end_user })
                    .then(user => {
                        commit("setUser", user.data)
                        this.$router.push(`/post_Images/`)
                        this.email = "";
                        this.password = "";
                        this.name = "";
                        this.profile_name = "";
                    })
                    .catch((err) => {
                        alert(err)
                    })
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
            const searchResult = res.data.map(post_image => {
                post_image.favorites.forEach(fav => {
                    if (fav.end_user_id === this.state.user.id) {
                        return (post_image.isFav = true);
                    } else {
                        return (post_image.isFav = false);
                    }
                });
                post_image.caption = post_image.caption.replace(
                    /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm,
                    ""
                );
                post_image.hashtags.map(hashtag => {
                    hashtag.hashname.replace(/[#＃]/gm, "");
                });
                post_image.isActive = true;
                post_image.showBtn = false;
                return post_image;
            });
            commit('setSearchResult', searchResult);
            this.$router.push("/post_Images/")
            this.keyword = "";
        } catch (err) {
            alert(err);
        }
    },
    cancelSearch({ commit }) {
        commit('setSearchResult', [])
        this.$router.push("/post_Images/")
    },
    testLogIn({ commit }, payload) {
        firebase.auth()
            .signInWithEmailAndPassword(payload[0], payload[1])
            .then(user => {
                commit("setUser", user);
                this.$router.push("/post_Images");
            })
            .catch(function (error) {
                alert(error);
            });
    },
    authCheck({ commit }) {
        firebase.auth().onAuthStateChanged(async user => {
            if (user) {
                const { data } =
                    await axios.get(`/end_users?email=${user.email}`)
                commit('setUser', data[0])
            }
        })
    },
    async notificationsCheck({ commit }, payload) {
        try {
            const res = await axios.get(`/notifications/${payload.id}`);
            let notifications = res.data.filter(notification => {
                return notification.checked === false
            });
            commit('setNotifications', notifications);
        } catch (err) {
            console.log("setNotifications_err", err)
        }
    },
    async showNotifications({ commit }, payload) {
        try {
            const res = await axios.put(`/notifications/${payload[0]}`, { id: payload[0], end_user_id: payload[1] })
            let notifications = res.data.filter(notification => {
                return notification.checked === false
            });
            commit('setNotifications', notifications);
        } catch (err) {
            console.log("setNotifications_err", err)
        }
    }
}

export default actions;