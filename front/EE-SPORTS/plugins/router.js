import firebase from '@/plugins/firebase';
import axios from '@/plugins/axios';
// import { functions } from 'firebase';


function befreEach(context, to, from, next) {
    if (process.server) {
        console.log(`---------beforeEach(SSR)_${Date.now()}----------`)
    } else {
        const {
            store
        } = context

        // firebase.auth().onAuthStateChanged(user => {
        //     // console.log("test")
        //     if (user) {
        //         // console.log(user)
        //         // const { data } =
        //         axios.get(`/end_users?email=${user.email}`)
        //             .then(res => {
        //                 store.commit('setUser', res.data[0])
        //                 console.log("setUser", data);
        //             },
        //                 // const { res } =
        //                 axios.get(`/notifications/${user.id}`)
        //                     .thenn(res => {
        //                         store.commit('setNotifications', res)
        //                         console.log("serNotifications", res)
        //                     })
        //             )
        //     }
        // firebase.auth().onAuthStateChanged(async user => {
        //     // console.log("test")
        //     if (user) {
        //         // console.log(user)
        //         const { data } =
        //             await axios.get(`/end_users?email=${user.email}`)
        //         store.commit('setUser', data[0])
        //         console.log("setUser", data);
        //         const { res } = await axios.get(`/notifications/${user.id}`)
        //         store.commit('setNotifications', res)
        //         console.log("serNotifications", res)
        //     }
        // }),
        // if (context.store.state.user.id) {
        //     try {
        //         const res = axios.get(`/notifications/${context.store.state.user.id}`)
        //             .then(res => {
        //                 store.commit('setNotifications', res)
        //             })
        //         console.log("resssssssss", res);
        //     } catch (err) {
        //         // alert(err);
        //         console.log("Notifications err", err);
        //         return null;
        //     }

        // const currentUser = context.store.state.user;
        firebase.auth().onAuthStateChanged(async user => {
            // console.log("test")
            if (user) {
                // console.log(user)
                const { data } =
                    await axios.get(`/end_users?email=${user.email}`)
                store.commit('setUser', data[0])
                // -----------------------値の確認OK-------------
                console.log("beforeEach_data", data);
                console.log("beforeEach_context", context);
                console.log("beforeEach_state", context.store.state.user);
                // ------------------------ここまで--------------
            }
            console.log(`---------beforeEach(CSR)_${Date.now()}----------`)
            // ),
            next()
        }
        )
    }
}

export default (context) => {
    context.app.router.beforeEach(befreEach.bind(null, context))
}
