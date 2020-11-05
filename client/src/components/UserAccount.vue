<template>
  <div class="UserAccount">
    <!-- Title -->
    <div class="row">
      <div class="col-md-12 mt-3 mb-3">
        <h1><i class="fa fa-users pr-3" aria-hidden="true"></i>My account</h1>
      </div>
    </div>

    <!-- Account panel -->
    <div class="row">
      <div class="col-md-10 offset-md-1">
        <div class="col main">
          <div class="row mb-3">
            <div class="card user-card">
              <div class="card-body">
                <!-- Username and Email labels -->
                <div class="labels row">
                  <div class="col-md-6">
                    <label for="input-username" class="required"
                      >Username :</label
                    >
                  </div>
                  <div class="col-md-6">
                    <label for="input-email" class="required">Email :</label>
                  </div>
                </div>

                <!-- Inputs -->
                <b-form @submit="saveModifications">
                  <!-- Username + Email -->
                  <div class="row">
                    <!-- Username -->
                    <b-input-group class="col-md-6">
                      <b-input-group-prepend>
                        <span class="input-group-text"
                          ><i class="fa fa-user fa-lg"></i
                        ></span>
                      </b-input-group-prepend>
                      <b-form-input
                        id="input-username"
                        v-model="user_datas.username"
                        type="text"
                        required
                        size="lg"
                        placeholder="Username"
                      ></b-form-input>
                    </b-input-group>

                    <!-- Email -->
                    <b-input-group class="col-md-6">
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
                        size="lg"
                        placeholder="Email"
                      ></b-form-input>
                    </b-input-group>
                  </div>
                  <!-- End of Username + Email -->

                  <p class="edit-indication pt-2 mb-1">
                    <i class="fa fa-exclamation pr-3" aria-hidden="true"></i>To
                    save modifications, please type in your password
                  </p>

                  <!-- Password -->
                  <div class="labels row mt-1">
                    <div class="col-md-6">
                      <label for="input-password" class="required"
                        >Password :</label
                      >
                    </div>
                  </div>

                  <b-input-group class="col-md-6">
                    <b-input-group-prepend>
                      <span class="input-group-text"
                        ><i class="fa fa-lock fa-lg"></i
                      ></span>
                    </b-input-group-prepend>
                    <b-form-input
                      type="password"
                      id="input-password"
                      placeholder="Current password"
                      v-model="form.password"
                      size="lg"
                      required
                    >
                    </b-form-input>
                  </b-input-group>
                  <!-- End of password -->

                  <!-- New password -->
                  <div class="labels row mt-3">
                    <div class="col-md-6">
                      <label for="input-new-password">New password :</label>
                    </div>
                  </div>

                  <div class="row">
                    <b-input-group class="col-md-6">
                      <b-input-group-prepend>
                        <span class="input-group-text"
                          ><i class="fa fa-lock fa-lg"></i
                        ></span>
                      </b-input-group-prepend>
                      <b-form-input
                        type="password"
                        id="input-new-password"
                        placeholder="New password"
                        v-model="form.newPassword"
                        size="lg"
                      >
                      </b-form-input>
                    </b-input-group>
                    <b-form-invalid-feedback
                      class="row"
                      :state="validationPassword"
                    >
                      Your password must contain at least 8 characters, with at
                      least, one uppercase letter, one lowercase letter and one
                      digit
                    </b-form-invalid-feedback>

                    <!-- Confirm new password -->
                    <b-input-group class="col-md-6">
                      <b-input-group-prepend>
                        <span class="input-group-text"
                          ><i class="fa fa-lock fa-lg"></i
                        ></span>
                      </b-input-group-prepend>
                      <b-form-input
                        type="password"
                        id="input-new-password-confirm"
                        placeholder="Confirm new password"
                        v-model="form.newPasswordConfirm"
                        size="lg"
                      >
                      </b-form-input>
                    </b-input-group>
                    <b-form-invalid-feedback :state="validationConfirmation">
                      Both need to be the same.
                    </b-form-invalid-feedback>
                  </div>
                  <!-- End of new password -->

                  <p class="mt-3 mb-0 required-indication">
                    <span class="required"></span> denotes required field
                  </p>

                  <!-- Submission -->
                  <div class="form-row justify-content-around mt-4">
                    <b-button
                      type="submit"
                      variant="success"
                      class="col-md-6 btn-lg"
                      >Save</b-button
                    >
                  </div>
                </b-form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- End of Account panel -->

    <!-- Delete panel -->
    <div class="row pt-5">
      <div class="col-md-10 offset-md-1">
        <div class="col main">
          <div class="row mb-3">
            <div class="card user-card">
              <div class="card-body">
                <p>Delete the account and all linked datas</p>
                <p>Attention, you need to inform your manager about that !</p>
                <b-button
                  variant="danger"
                  class="col-md-2 btn-lg"
                  v-b-modal.modal-confirm-deleting
                  >Delete my account</b-button
                >
                <!--<b-button
                  @click="confirmDelete"
                  variant="danger"
                  class="col-md-2 btn-lg"
                  >Delete my account</b-button
                >-->
                <b-modal
                  id="modal-confirm-deleting"
                  ref="modal"
                  title="Deleting your account"
                  @show="resetModal"
                  @hidden="resetModal"
                  @ok="handleOk"
                >
                  <form ref="form" @submit.stop.prevent="deleteAccount">
                    <b-form-group
                      :state="deletePasswordState"
                      label="Password"
                      label-for="delete-password-input"
                      invalid-feedback="Password is required"
                    >
                      <b-form-input
                        id="delete-password-input"
                        v-model="form.password"
                        :state="deletePasswordState"
                        required
                      ></b-form-input>
                    </b-form-group>
                  </form>
                </b-modal>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- End of delete panel -->
  </div>
</template>

<script>
import User from "./User";
import Authentication from "./Authentication";

import axios from "axios";
import config from "../config";

export default {
  name: "UserAccount",
  data() {
    return {
      user: null,
      user_datas: {
        username: "",
        email: "",
      },
      form: {
        email: "",
        password: null,
        newPassword: null,
        newPasswordConfirm: null,
      },
      deletePasswordState: null,
    };
  },
  // Auto-checks
  computed: {
    // Does the new password fit the requirements
    validationPassword() {
      if (this.form.newPassword !== "" && this.form.newPassword !== null)
        return this.form.newPassword.match(
          /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z]{8,}$/
        ) !== null
          ? true
          : false;
      else return true;
    },
    // Does the confirmation password corresponds to the new password
    validationConfirmation: function () {
      if (this.form.newPassword !== "") {
        return (
          this.form.newPasswordConfirm === this.form.newPassword &&
          this.form.newPasswordConfirm !== ""
        );
      }
      return true;
    },
  },
  methods: {
    // Save modifications into the DB
    saveModifications: async function (e) {
      e.preventDefault();
      if (
        this.form.password !== null &&
        this.form.password !== "" &&
        this.user_datas.email !== null &&
        this.user_datas.email !== "" &&
        this.user_datas.username !== "" &&
        this.user_datas.username !== null
      ) {
        // Check if it's the correct password
        if (await this.isPasswordCorrect(this.form.password)) {
          // Do we need to update the password ?
          var password = this.form.password;
          if (
            this.form.newPassword !== "" &&
            this.form.newPassword !== null &&
            this.form.newPasswordConfirm === this.form.newPassword
          ) {
            password = this.form.newPassword;
          }

          // Asking API for updating user datas
          axios
            .put(
              config.API_ROOT + "api/users/" + this.user.id,
              {
                user: {
                  username: this.user_datas.username,
                  email: this.form.email,
                  password: password,
                },
              },
              { headers: { Authorization: this.user.token } }
            )
            // Success
            .then(() => {
              this.$notify({
                group: "result",
                type: "success",
                position: "top center",
                duration: -1,
                title: "Success",
                text: "All datas have been saved",
              });

              setTimeout(function () {
                location.reload();
              }, 3000);
            })
            // Error
            .catch((error) => {
              console.error(error);
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
        }
      }
    },
    // Are you sure about deleting your account ?
    confirmDelete: function () {
      console.log(this.$bvModal);
      this.confirmDelete = "";
      this.$bvModal
        .msgBoxConfirm(
          "You're about to delete your account forever, are you sure?"
        )
        .then((value) => {
          if (value) this.deleteAccount();
        })
        .catch((err) => {
          console.log(err);
        });
    },
    // Deleting the account
    deleteAccount: async function () {
      // If the deleting form is valid
      if (!this.checkFormValidity()) {
        return;
      }

      // If the password is correct, then delete the account
      if (await this.isPasswordCorrect(this.form.password)){
        axios
            .delete(
              config.API_ROOT + "api/users/" + this.user.id,
              { headers: { Authorization: this.user.token } }
            )
            // Success
            .then(() => {
              this.$notify({
                group: "result",
                type: "success",
                position: "top center",
                duration: -1,
                title: "Success",
                text: "Your account has been deleted successfully",
              });

              setTimeout(function () {
                Authentication.methods.signOut();
                location.reload();
              }, 3000);
            })
            // Error
            .catch((error) => {
              console.error(error);
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
      }

      // Hiding the deleting form
      this.$nextTick(() => {
        this.$bvModal.hide("modal-confirm-deleting");
      });
    },
    // Reset the deleting form
    resetModal() {
      this.form.password = "";
      this.deletePasswordState = null;
    },
    // Check for the deleting form validation
    checkFormValidity() {
      const valid = this.$refs.form.checkValidity();
      this.deletePasswordState = valid;
      return valid;
    },
    // Prevent the deleting form from being submitted
    handleOk(bvModalEvt) {
      // Prevent modal from closing
      bvModalEvt.preventDefault();
      // Trigger submit handler
      this.deleteAccount();
    },
    isPasswordCorrect: function (password) {
      return axios
        .post(config.API_ROOT + "api/sign_in", {
          session: {
            email: this.user_datas.email,
            password: password,
          },
        })
        .then((response) => {
          if (response.status === 200) {
            return true;
          }
          return false;
        })
        .catch((error) => {
          var errorObj = Object.assign({}, error);

          var strerror;
          // If it's the wrong password
          if (errorObj.response.request.status === 401) {
            strerror = "Wrong password";
          } else {
            strerror = errorObj.response.request.statusText;
          }
          this.$notify({
            group: "result",
            type: "error",
            position: "top center",
            duration: -1,
            title: "Error",
            text: strerror,
          });
          return false;
        });
    },
  },
  beforeMount: async function () {
    this.isUserAuthenticated = User.methods.isUserAuthenticated();

    if (this.isUserAuthenticated) {
      // Get user token & id
      this.user = JSON.parse(localStorage.user);

      // Get user datas
      this.user_datas = await User.methods.getUser(this.user.id);
      // Save the mail in case the user wants to change it (in order to check the password thanks to API)
      this.form.email = this.user_datas.email;

      //console.log(this.user_datas);
    }
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
  width: 100%;
  color: black;
}

.user-card {
  font-size: 1.3rem;
  /*background-color: #17a2b8;*/
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

.input-group-text {
  width: 3rem;
  text-align: center;
}

.input-group-text i {
  width: 100%;
}

.labels .col-md-6 {
  padding-left: calc(3rem + 1rem + 1rem);
  text-align: left;
}

.edit-indication {
  text-align: left;
  padding-left: 1rem;
  color: orange;
}

.required-indication {
  text-align: left;
  margin-left: 1rem;
}

.required::after {
  content: "*";
  font-size: 2rem;
  color: red;
}
</style>
