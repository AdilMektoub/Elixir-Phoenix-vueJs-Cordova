<template>
  <div
    id="register"
    class="div-content content d-flex flex-column justify-content-center"
  >
    <!-- Registration form -->
    <div class="loginBox col-md-3" v-if="!registered">
      <b-form @submit="onSubmit">
        <h2>Registration</h2>

        <!-- Username -->
        <b-input-group>
          <b-input-group-prepend>
            <span class="input-group-text"
              ><i class="fa fa-user fa-lg"></i
            ></span>
          </b-input-group-prepend>
          <b-form-input
            id="input-username"
            v-model="form.username"
            required
            placeholder="Username"
          ></b-form-input>
        </b-input-group>

        <!-- Email -->
        <b-input-group>
          <b-input-group-prepend>
            <span class="input-group-text"
              ><i class="fa fa-envelope fa-lg"></i
            ></span>
          </b-input-group-prepend>
          <b-form-input
            id="input-email"
            v-model="form.email"
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
            v-model="form.password"
            required
          >
          </b-form-input>
          <b-form-invalid-feedback :state="validationPassword">
            Your password must contain at least 8 characters, with at least,
            one uppercase letter, one lowercase letter and one digit
          </b-form-invalid-feedback>
        </b-input-group>

        <!-- Password confirmation -->
        <div class="need-verification">
          <b-input-group>
            <b-input-group-prepend>
              <span class="input-group-text"
                ><i class="fa fa-lock fa-lg"></i
              ></span>
            </b-input-group-prepend>
            <b-form-input
              type="password"
              id="input-password-confirm"
              placeholder="Password"
              v-model="form.password_confirmation"
              required
            ></b-form-input>
            <b-form-invalid-feedback :state="validationConfirmation">
              It must be the same password as above.
            </b-form-invalid-feedback>
          </b-input-group>
        </div>

        <!-- Submission -->
        <div class="form-row justify-content-around">
          <b-button type="submit" variant="primary" class="col-md-6"
            >Sign up</b-button
          >
        </div>

        <!-- Already sign up ? -->
        <div class="d-flex justify-content-center align-items-center mt-5">
          <p>
            Already have an account ? <a href="/sign_in">Sign in</a>
          </p>
        </div>
      </b-form>
    </div>
    <b-card title="Welcome !" v-else>
      <b-card-text> You successfully logged in. </b-card-text>

      <b-link href="/sign_in" class="card-link text-yellow"
        >Clic here to sign in</b-link
      >
    </b-card>
  </div>
</template>

<script>
//import User from './User';
import axios from "axios";
//import sha256 from 'js-sha256';
import config from "../config";

export default {
  data() {
    return {
      form: {
        email: "",
        username: "",
        password: "",
        password_confirmation: "",
      },
      registered: false,
    };
  },
  computed: {
    validationPassword() {
      if (this.form.password !== "" && this.form.password !== null)
        return (this.form.password.match(/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z]{8,}$/) !== null ? true : false);
      else return true;
    },
    validationConfirmation() {
      if (this.form.password !== "") {
        return (
          this.form.password_confirmation === this.form.password &&
          this.form.password_confirmation !== ""
        );
      }
      return true;
    },
  },
  methods: {
    onSubmit: function (evt) {
      evt.preventDefault();

      // API Request
      if (
        this.form.email !== null &&
        this.form.username !== "" &&
        this.form.password !== null &&
        this.validationPassword &&
        this.validationConfirmation
      ) {
        let hashedPassword = /*sha256*/(this.form.password);

        // Send the registration data to the API (hashed password)
        axios
          .post(config.API_ROOT + "api/sign_up", {
            user: {
              email: this.form.email,
              password: hashedPassword,
              username: this.form.username,
            },
          })
          // If API Responds
          .then((response) => {
            console.log(response);
            if (response.status === 201) {
              this.$notify({
                group: "result",
                type: "success",
                position: "top center",
                duration: 3000,
                title: "Success",
                text: "You have been successfully registered !"
              });

              this.registered = true;
            }
          })
          // If API didn't responds
          .catch((error) => {
            var errorObj = Object.assign({}, error);

            var strError =
              "Your account couldn't be registered because of the following issues :";

            console.log(errorObj.response.data.errors);

            for (const [field, value] of Object.entries(
              errorObj.response.data.errors
            )) {
              strError += "<br>Concerning your " + field + "<br>";
              for (var i = 0; i < value.length; i++) {
                strError += "  - " + value[i] + "<br>";
              }
              strError += "<br>";
            }

            this.$notify({
              group: "result",
              type: "error",
              position: "top center",
              duration: -1,
              title: "Error",
              text: strError,
            });
          });
      }
    },
  },
};
</script>

<style scoped>
#register {
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

/*.loginBox {
}*/

.loginBox,
.card {
  margin: 1% auto 0% auto;
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

#input-password,
#input-password-confirm {
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

.loginBox input[type="text"],
.loginBox input[type="password"],
.loginBox input[type="email"],
.loginBox input[type="date"],
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

.invalid-feedback {
  position: initial;
  background-color:#313A48;
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