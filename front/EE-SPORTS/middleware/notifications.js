import firebase from '@/plugins/firebase';
import axios from '@/plugins/axios';
// import { functions } from 'firebase';

export default async (context) => {
    const {
        store
    } = context

    await new Promise(async (resolve, reject) => {
        firebase.auth().onAuthStateChanged(async user => {
            // console.log("test")
            if (user) {
                // console.log(user)
                // const { data } =
                const res = await axios.get(`/end_users?email=${user.email}`)
                store.commit('setUser', res.data[0])
                console.log("setUser", res.data[0]);

                const notification_res = await axios.get(`/notifications/${res.data[0].id}`)
                store.commit('setNotifications', notification_res.data)
                console.log("serNotifications", notification_res.data)
            }

            resolve();
        });
    });
}
