<template>
  <div class="user"></div>
</template>

<script>
import axios from "axios";
import config from "../config";

// Roles :
//  - employee
//  - admin
//  - manager

export default {
  name: "User",
  data() {
    return {
      user: null,
    };
  },
  props: {
    username: String,
    email: String,
  },
  methods: {
    /*********** API CALLS ***********/
    createUser: function (username, email) {
      axios
        .post(config.API_ROOT + "api/users", {
          email: email,
          username: username,
        })
        .then((response) => {
          console.log(response);
        })
        .catch((error) => {
          console.log(error);
        });
    },
    updateUser: function (id, username = "", email = "") {
      if (this.isUserAuthenticated()) {
        axios
          .put(config.API_ROOT + "api/users/" + id, {
            email: email,
            username: username,
          })
          .then((response) => {
            console.log(response);
          })
          .catch((error) => {
            console.log(error);
          });

        //console.log(id + username + email);
      }
    },
    getUser: async function (id) {
      if (this.isUserAuthenticated()) {
        return axios
          .get(config.API_ROOT + "api/users/" + id, {
            headers: {
              Authorization: JSON.parse(localStorage.user).token,
            },
          })
          .then((response) => {
            //console.log(response);
            return response.data.data;
          })
          .catch((error) => {
            console.error(error);
            return error;
          });

        /*const response = await axios({
          url: config.API_ROOT + "api/users/" + id,
          method: "GET",
          headers: {Authorization: JSON.parse(localStorage.user).token}
        });

        console.log(response);*/
      }
    },
    deleteUser: function (id) {
      if (this.isUserAuthenticated()) {
        axios
          .delete(config.API_ROOT + "api/users/" + id, {})
          .then((response) => {
            console.log(response);
          })
          .catch((error) => {
            console.log(error);
          });
      }
    },
    isUserAuthenticated: function () {
      return localStorage.user !== undefined;
    },
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1,
h2 {
  font-weight: normal;
}
.card {
  border-radius: 20px;
}

.user-card {
  background-color: #17a2b8;
}

.user-data .btn {
  margin-top: 0.2rem;
  margin-bottom: 0.2rem;
}

.user-action {
  text-align: -webkit-right;
}

.user-action button {
  display: block;
  width: 2.3rem;
  /*float: right;*/
}
</style>
