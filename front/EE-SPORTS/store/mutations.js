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
    },
    changeLoading(state, payload) {
        state.loading = payload
    }
};

export default mutations;