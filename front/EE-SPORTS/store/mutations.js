const mutations = {
    setUser(state, payload) {
        state.user = payload;
    },
    onUserStatusChanged(state, payload) {
        state.status = payload;
    },
    setSearchResult(state, payload) {
        state.search = payload;
    }
};

export default mutations;