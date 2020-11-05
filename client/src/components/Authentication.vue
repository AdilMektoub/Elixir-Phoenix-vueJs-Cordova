<template>
    <div id="authentication" class="authentication div-content content d-flex flex-column justify-content-center">

        <!-- Registration form -->
        <div class="loginBox col-md-3">
            <b-form @submit="signIn">
                <h2>Authentication</h2>

                <!-- Email -->
                <b-input-group>
                    <b-input-group-prepend>
                        <span class="input-group-text"
                            ><i class="fa fa-envelope fa-lg"></i
                        ></span>
                    </b-input-group-prepend>
                    <b-form-input
                    id="input-email"
                    v-model="email"
                    type="email"
                    required
                    placeholder="Email"
                    ></b-form-input>
                </b-input-group>

                <!-- Password -->
                <b-input-group>
                    <b-input-group-prepend>
                        <span class="input-group-text"
                            ><i class="fa fa-lock fa-lg"></i
                        ></span>
                    </b-input-group-prepend>
                    <b-form-input
                    type="password"
                    id="input-password"
                    placeholder="Password"
                    v-model="password"
                    required
                    >
                    </b-form-input>
                </b-input-group>

                <!-- Submission -->
                <div class="form-row justify-content-around">
                    <b-button type="submit" variant="primary" class="col-md-6"
                        >Sign in</b-button
                    >
                </div>

                <!-- No account ? -->
                <div class="d-flex justify-content-center align-items-center mt-5">
                <p>
                    Don't have an account yet ? <a href="/sign_up">Sign up</a>
                </p>
                </div>
            </b-form>
        </div>
    </div>
</template>

<script>
import axios from "axios";
//import sha256 from 'js-sha256';
import config from "../config";

export default {
  name: "Authentication",
  data() {
    return {
      email: null,
      password: null,
    };
  },
  methods: {
    signIn: function (e) {
      console.log("Signing in ...");
      e.preventDefault();
      if (this.password != null) {
        // Hash the password
        let hashedPassword = /*sha256*/(this.password);

        // Ask the API if the password is the good one
        axios
          .post(config.API_ROOT + "api/sign_in", {
            session: {
              email: this.email,
              password: hashedPassword,
            },
          })
          .then((response) => {
            console.log(response);
            if (response.status === 200) {
              response.data.data.token = 'bearer ' + response.data.data.token;

              // Store the user into the localStorage
              localStorage.user = JSON.stringify(response.data.data);
              console.log(localStorage.user);

              // Redirection to the dashboard
              this.$router.push("dashboard");

              // Success notif
              this.$notify({
                group: "result",
                type: "success",
                position: "top center",
                duration: 3000,
                title: "Success",
                text: "Welcome !",
              });
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
              text: "Your password is incorrect",
            });
          });
      }
      return false;
    },
    signOut: function() {
        return delete localStorage.user;
    }
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
#authentication {
  top: 0;
}

body {
  font-family: calibri;
  padding: 0;
  margin: 0;
  margin: ;
  padding: ;
  background-color: white;
}

.loginBox {
  margin: 1% auto 0% auto;
  /*margin: calc(1% - 2.5rem) auto 0% auto;*/
  padding: 0.5rem 1rem 0.5rem 1rem;
  /*max-height: 80%;
  min-height: 80%;*/
  box-sizing: border-box;
  background: rgba(0, 0, 0, 0.5);
  border-radius: 2%;
  background-color: #31343ca6;
  overflow: auto;
  display: table;
}

h2 {
  margin: 0;
  padding: 0 0 20px;
  text-align: center;
  color: white;
}

.loginBox p {
  margin: 0;
  padding: 0;
  font-weight: bold;
  color: #fff;
}

#input-password {
  border-top-right-radius: 0.25rem;
  border-bottom-right-radius: 0.25rem;
}

.input-group {
    height: auto !important;
}

.input-group,
.input-group-prepend,
.input-group-prepend .input-group-text,
.loginBox .form-control {
  background-color: #222832;
  height: 2rem;
  margin: 0 0 20px 0;
}

.loginBox input[type="password"],
.loginBox input[type="email"],
.input-group-text {
  border: 1px solid grey;
  /*border-bottom: 1px solid grey;*/
  background: transparent;
  outline: none;
  color: #fff;
  font-size: 14px;
  line-height: 14px;
  text-align: left;
}

.input-group-prepend, .input-group-text, input {
    margin-bottom: 0 !important;
}


input {
  border-left: none !important;
  padding-bottom: 0;
}

.input-group-text {
  border-right: none;
  width: 2rem;
}

::placeholder {
  color: white;
  opacity: 0.3;
  text-align: left;
}

.loginBox input[type="submit"] {
  border: 1px solid;
  height: 40px;
  color: violet;
  background-color: transparent;
}

.loginBox input[type="submit"]:hover {
  color: pink;
  border: 2px solid;
}

b-form a {
  color: violet;
  text-decoration: none;
}
</style>