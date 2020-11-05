<template>
  <div class="userbar">
    <b-navbar toggleable="lg" type="dark" variant="info">
      <Slide id="slide-menu" v-if="isUserAuthenticated">
        <a id="home">
          <span><router-link to="/dashboard"><i class="fa fa-tachometer pr-3" aria-hidden="true"></i>Dashboard</router-link></span>
        </a>
      </Slide>
      <b-navbar-nav class="ml-auto">
        <b-nav-item-dropdown right>
          <!-- Using 'button-content' slot -->
          <template #button-content>
            <i class="fa fa-user fa-lg"></i>
          </template>
          <div v-if="isUserAuthenticated">
            <b-dropdown-item><router-link to="/my_account"><i class="fa fa-users pr-3" aria-hidden="true"></i>My account</router-link></b-dropdown-item>
            <b-dropdown-item @click="signOutButton"><i class="fa fa-sign-out pr-3" aria-hidden="true"></i>Sign out</b-dropdown-item
            >
          </div>
          <div v-else>
              <b-dropdown-item><router-link to="/sign_in"><i class="fa fa-sign-in pr-3" aria-hidden="true"></i>Sign in</router-link></b-dropdown-item>
              <b-dropdown-item><router-link to="/sign_up"><i class="fa fa-user-plus pr-3" aria-hidden="true"></i>Sign up</router-link></b-dropdown-item>
            </div>
        </b-nav-item-dropdown>
      </b-navbar-nav>
    </b-navbar>
  </div>
</template>


<script>
import Authentication from "./Authentication";
import User from './User';
import { Slide } from "vue-burger-menu";

export default {
  name: "UserBar",
  components: {
    Slide,
  },
  methods: {
    // Sign out by user action
    signOutButton: function () {
      if (Authentication.methods.signOut()) {

        // Redirect to the login route 
        this.$router.push("sign_in");
        this.isUserAuthenticated = User.methods.isUserAuthenticated();
        this.$forceUpdate();
        

        this.$notify({
          group: "result",
          type: "success",
          position: "top center",
          duration: 5000,
          title: "Succès",
          text: "A bientôt !",
        });
        this.isUserSignIn = false;
      }
    },
  },
  beforeMount: function() {
    this.isUserAuthenticated = User.methods.isUserAuthenticated();
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style>
.userbar .navbar-nav a {
  font-size: 1.2rem;
  color: black;
}

.userbar .navbar-nav a:hover {
  text-decoration: none;
  color: lightgray;
}

.userbar {
  font-size: 1rem;
  width: 100%;
  position: fixed;
  top: 0;
  left: 0;
  z-index: 2;
}

nav {
  height: 3.5rem;
}

.bm-burger-button {
  position: fixed;
  left: 2rem;
  top: 1rem;
}

#slide-menu a{
  color: white;
  text-decoration: none;
}

#slide-menu a:hover {
  text-decoration: none;
}
</style>