// firebaseでauthcheckしたユーザのじょうほうがpayloadで返ってくるので、それをstateに格納するメソッド
const mutations = {
    setUser(state, payload) {
        state.user = payload;
    },
    onUserStatusChanged(state, payload) {
        state.status = payload;
    },
    setSearchResult(state, payload) {
        state.search = payload;
    },
    setNotifications(state, payload) {
        state.notifications = payload;
    }
};

export default mutations;