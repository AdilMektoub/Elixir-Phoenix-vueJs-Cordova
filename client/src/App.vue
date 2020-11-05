<template>
    <div id="app">
      <notifications class="custom-notif" group="result" position="top left" width="100%"></notifications>
      <UserBar/>
      <router-view></router-view>
    </div>
</template>

<script>
import UserBar from './components/UserBar.vue'

export default {
  name: 'App',
  components: {
      UserBar
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  /*color: #2c3e50;*/
  color: white !important;
  /*margin-top: 60px;*/
  height: 100%;
}

body, html {
  background-color: #34495E;
  height: 100%;
}

.userbar + div {
  position: relative;
  top: 3.5rem;
  height: calc(100% - 3.5rem);
}

table {
    color: black !important;
}

.vue-notification {
  font-size: 1rem !important;
}

.row {
  width: 100%;
  margin-right: 0;
  margin-left: 0;
}

.panel {
  width: 100%;
}
</style>
