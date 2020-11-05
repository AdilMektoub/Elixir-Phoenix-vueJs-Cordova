<template>
  <div id="dashboard" class="dashboard div-content content d-flex flex-column">
    <!-- Title -->
    <div class="row">
      <div class="col-md-12 mt-3">
        <h1><i class="fa fa-tachometer pr-3" aria-hidden="true"></i>Dashboard</h1>
      </div>
    </div>

    <!-- Clock in/out Image -->
    <div class="row mb-4">
      <div class="col-md-4 offset-md-4">
        <a href="#" @click="insertClock">
          <img src="../assets/Clock.png" width="256" height="256" />
          <div v-if="clockIn" class="centered">Clock in</div>
          <div v-else class="centered">Clock out</div>
        </a>
      </div>
    </div>

    <!-- Charts part -->
    <div class="row mt-5">
      <div class="col-md-10 offset-md-1">
        <ChartManager />
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import config from "../config";

import User from "./User";
import ChartManager from "./ChartManager";

export default {
  name: "Dashboard",
  components: {
    ChartManager,
  },
  data() {
    return {
      clockIn: false,
      user: null,
    };
  },
  methods: {
    // Save the clock in or clock out of the user into the DB
    insertClock: function () {
      console.log("insertClock()");
      //{{base_url}}/api/clocks/{{user_id}}
      axios
        .post(
          config.API_ROOT + "api/clocks/" + this.user.id,
          {},
          {
            headers: {
              Authorization: this.user.token,
            },
          }
        )
        .then((response) => {
          console.log(response);
          if (response.status === 200) {
            // Success notification
            this.$notify({
              group: "result",
              type: "success",
              position: "top center",
              duration: 3000,
              title: "Success",
              text:
                "You clocked " +
                (this.clockIn ? "in" : "out") +
                " successfully.",
            });

            // Change the text into the clock img
            this.clockIn = !this.clockIn;
          }
        })
        .catch((error) => {
          console.log(error);
          this.$notify({
            group: "result",
            type: "error",
            position: "top center",
            duration: -1,
            title: "Error",
            text: "",
          });
        });
    },

    // Get the clock assigned to the user, in order to know if the next click on
    // the image will be a clock in or, a clock out
    getClockedIn: function () {
      console.log("getClockedIn ...");

      axios
        .get(config.API_ROOT + "api/clocks/" + this.user.id, {
          headers: {
            Authorization: this.user.token,
          },
        })
        .then((response) => {
          //console.log(response);
          if (response.status === 200) {

            if (response.data.data !== null)
              // Get if the next clic will be a clock in or out
              this.clockIn = !response.data.data.status;
          }
        })
        .catch((error) => {
          console.log(error);
          this.$notify({
            group: "result",
            type: "error",
            position: "top center",
            duration: -1,
            title: "Error",
            text:
              "A communication to the Database failed. Please contact a supervisor.",
          });
        });
    },
  },
  beforeMount: function () {
    this.isUserAuthenticated = User.methods.isUserAuthenticated();

    if (this.isUserAuthenticated) {
      // Get user datas
      this.user = JSON.parse(localStorage.user);

      // Get the clocked in or out text
      this.getClockedIn();
    }
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
body {
  font-family: calibri;
  padding: 0;
  margin: 0;
  background-color: white;
}

.centered {
  color: black;
  font-size: 2rem;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
</style>