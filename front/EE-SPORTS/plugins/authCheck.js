import firebase from '@/plugins/firebase';
import axios from '@/plugins/axios';

export default (context) => {
    const {
        store
    } = context
    firebase.auth().onAuthStateChanged(async user => {
        if (user) {
            const { data } =
                await axios.get(`/end_users?email=${user.email}`)
            store.commit('setUser', data[0])
        }
    })
}