import firebase from '@/plugins/firebase';
import axios from '@/plugins/axios';

export default async (context, inject) => {
    const {
        store
    } = context

    // await new Promise(async (resolve, reject) => {
    //     firebase.auth().onAuthStateChanged(async user => {
    //         if (user) {
    //             const res = await axios.get(`/end_users?email=${user.email}`)
    //             console.log('res', res)
    //             store.commit('setUser', res.data[0])

    //             const notification_res = await axios.get(`/notifications/${res.data[0].id}`)
    //             let notifications = notification_res.data.filter(notification => {
    //                 return notification.checked === false
    //             });
    //             store.commit('setNotifications', notifications)
    //         }

    //         resolve();
    //     });
    // });
}