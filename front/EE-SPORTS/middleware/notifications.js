import axios from '@/plugins/axios';


export default function (context) {
    if (process.server) {
        console.log(`---------middleware(SSR)_${Date.now()}----------`)
    } else {
        if (context.store.state.user.id !== 0) {
            axios.get(`/notifications/${context.store.state.user.id}`)
                .then(res => { context.store.commit('setNotifications', res); });
            console.log("middleware_notice", res)
        }
        //     const {
        //         store
        //     } = context;
        //     axios.get(`/notifications/${context.store.state.user.id}`)
        //         .then(res => { store.commit('setNotifications', res); });
        //     console.log("middleware_notice", res)
        //         // console.log("resssssssss", res);
        //         // return this.notificationsAsync(res);
        //         // this.notifications = res.data.filter(notification => {
        //         //     // console.log("notification.checked", notification.checked);
        //         //     return notification.checked === false;
        //         // });
        //         .catch(err => {
        //             // alert(err);
        //             console.log("Notifications err", err);
        //             return null;
        //         })
        // }
        console.log(`---------middleware(CSR)_${Date.now()}----------`)
        console.log("middleware_context", context.store.state.user)
    }
}