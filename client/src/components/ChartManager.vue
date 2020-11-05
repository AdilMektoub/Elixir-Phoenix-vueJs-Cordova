<template>
  <div class="chartmanager">
    
    <div class="container-fluid" id="main">
      <div class="row row-offcanvas row-offcanvas-left">
        

        <!-- Weekly hours chart -->
        <div class="col main">
          <div class="row mb-3">
            <div class="col-xl-3 col-sm-6 py-2">
              <div class="card h-100">
                <h4 class="card-title mb-0">Weekly hours</h4>
                <div class="card-body pt-2">
                  <bar-chart
                    id="bar"
                    :data="weeklyHours"
                    xkey="day"
                    ykeys='["hours"]'
                    bar-colors='[ "#68D4CD", "#CFF67B", "#94DAFB", "#FD8080", "#889BA3", "#26A0FC", "#6EEEC3" ]'
                    grid="true"
                    grid-text-weight="bold"
                    resize="true"
                    hideHover="true"
                    labels='["Hour(s)"]'
                  >
                  </bar-chart>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-sm-6 py-2">
              <div class="card h-100">
                <h4 class="card-title mb-0">last 3 weeks hours</h4>
                <div class="card-body">
                  <line-chart
                    id="line"
                    :data="lastWeeksHours"
                    xkey="week"
                    ykeys='["hours"]'
                    labels='["Hour(s)"]'
                    line-colors='[ "#FF6384" ]'
                    grid="true"
                    grid-text-weight="bold"
                    parseTime="false"
                    resize="true"
                    hideHover="true"
                  >
                  </line-chart>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-sm-6 py-2">
              <div class="card h-100">
                <h4 class="card-title mb-0">Weekly night hours</h4>
                <div class="card-body">
                  <donut-chart
                    id="donut"
                    :data="donutData"
                    colors='[ "#FF6384", "#36A2EB", "#FFCE56" ]'
                    resize="true"
                  >
                  </donut-chart>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-sm-6 py-2">
              <div class="card h-100">
                <h4 class="card-title mb-0">Monthly overtime hours </h4>
                <div class="card-body">
                  <area-chart
                    id="area_2"
                    data='[
                                { "key": "2013", "value": 30 },
                                { "key": "2014", "value": 25 },
                                { "key": "2015", "value": 29 },
                                { "key": "2016", "value": 50 }
                                ]'
                    resize="true"
                    line-colors='[ "#FF6384", "#36A2EB" ]'
                    grid="true"
                    grid-text-weight="bold"
                  >
                  </area-chart>
                </div>
              </div>
            </div>
          </div>
        </div>
        <!--/main col-->
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import config from "../config";

import User from "./User.vue";

// Charts import
import Raphael from "raphael/raphael";
import { BarChart, LineChart, DonutChart, AreaChart } from "vue-morris";
global.Raphael = Raphael;

export default {
  name: "ChartManager",
  components: {
    BarChart,
    LineChart,
    DonutChart,
    AreaChart,
  },
  data() {
    return {
      weeklyHours: [
        { day: "Monday", hours: 0 },
        { day: "Tuesday", hours: 0 },
        { day: "Wednesday", hours: 0 },
        { day: "Thirsday", hours: 0 },
        { day: "Friday", hours: 0 },
        { day: "Saturday", hours: 0 },
        { day: "Sunday", hours: 0 },
      ],
      lastWeeksHours: [
        { week: "1", hours : 0},
        { week: "2", hours : 0},
        { week: "3", hours : 0},
        { week: "4", hours : 0}
      ],
      user: null,
      donutData: [
        { label: "Identifiant", value: 300 },
        { label: "Blue", value: 50 },
        { label: "Yellow", value: 100 },
      ],
      lineData: [],
    };
  },
  methods: {
    // Method that loads all datas of the corresponding user, which will be used by charts
    loadUserDatas: async function (id) {
      console.log("loadUserDatas(" + id + ") ...");
      let monday = this.setToMonday(new Date()).toISOString().split(".")[0];
      let sunday = this.setToSunday(new Date()).toISOString().split(".")[0];

      // Load all datas about the Weekly hours chart
      this.loadWeeklyHours(id, monday, sunday);

      // Load all datas about the Monthly hours chart
      var for_mondays_before = this.setDateToISO(new Date(new Date(monday).setDate(new Date(monday).getDate() - 21)));
      var last_sunday = this.setDateToISO(new Date(new Date(sunday).setDate(new Date(sunday).getDate() - 0)));
      this.loadLastWeeksHours(id, for_mondays_before, last_sunday);
    },

    
    //Method that loads all datas about the Weekly hours chart
    loadWeeklyHours: function (id, starting_period, ending_period) {
      console.log("loadWeeklyHours(" + id + ") ...");
      var days = new Array(7);
      days.fill(0);

      // Get the workingtimes of the current week
      axios
        .get(
          config.API_ROOT +
            "api/workingtimes/" +
            this.user.id +
            "?start=" +
            starting_period +
            "&end=" +
            ending_period,
          {
            headers: {
              Authorization: this.user.token,
            },
          }
        )
        .then((response) => {
          //console.log(response);
          if (response.status === 200) {
            // Creating the object that will be use by the chart
            response.data.data.forEach((workingtime) => {
              let starting_date = new Date(workingtime.start);
              let ending_date = new Date(workingtime.end);

              if (starting_date.getDate() === ending_date.getDate()) {
                // Adding the working hours to an unique date
                let dayOfWeek = starting_date.getDay() || 7;
                days[dayOfWeek - 1] +=
                  (ending_date - starting_date) / 1000 / 60 / 60;
              } else if (
                ending_date.getDate() - starting_date.getDate() ===
                1
              ) {
                // Adding the working hours to several dates (night work for example)
                let starting_date_end = new Date(
                  starting_date.getFullYear(),
                  starting_date.getMonth(),
                  starting_date.getDate()
                ).setHours(23, 59, 59);
                let ending_date_start = new Date(
                  ending_date.getFullYear(),
                  ending_date.getMonth(),
                  ending_date.getDate()
                ).setHours(0, 0, 0);

                // Adding workingtimes for the "starting" date
                days[(starting_date.getDay() || 7) - 1] +=
                  (starting_date_end - starting_date) / 1000 / 60 / 60;
                //console.log(new Date(starting_date_end));
                /*console.log(
                  "Ajout de " +
                    (starting_date_end - starting_date) / 1000 / 60 / 60 +
                    " heures à " +
                    this.weeklyHours[(starting_date.getDay() || 7) - 1].day
                );*/
                // Adding workingtimes for the "ending" date
                days[(ending_date.getDay() || 7) - 1] +=
                  (ending_date - ending_date_start) / 1000 / 60 / 60;
              } else {
                // Do nothing because a workingtime during 3 different days is impossible
              }
            });

            const dayLabel = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
            this.weeklyHours = [];
            for (var i = 0; i < days.length; i++) {
              this.weeklyHours.push({day: dayLabel[i], hours: days[i].toFixed(2)});
            }
            //console.log(this.weeklyHours);
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
    loadLastWeeksHours: function (id, starting_period, ending_period) {
      console.log("loadLastWeeksHours(" + id + ") ...");
      var weeks = new Array(4);
      weeks.fill(0);

      // Get the workingtimes of the last 3 weeks and the current one
      axios.get(config.API_ROOT + "api/workingtimes/" + this.user.id + "?start=" + starting_period + "&end=" + ending_period,
          {
            headers: { Authorization: this.user.token },
          }
        )
        .then((response) => {
          if (response.status === 200) {

            // Creating the object that will be use by the chart
            response.data.data.forEach((workingtime) => {
              // Getting the starting and ending date of the working time
              // in order to see if it's a night-working hour or not
              let starting_date = new Date(workingtime.start);
              let ending_date = new Date(workingtime.end);

              // If the starting and ending date is of the same week, then, add hours to the good week
              if (this.setToMonday(starting_date).toISOString() === this.setToMonday(ending_date).toISOString()) {
                // Index 0 will be 3 weeks in the past, and index 0 will be the current week
                let weekIndex = 4 - Math.floor(new Date(ending_period) / new Date(this.setToMonday(starting_date)));
                console.log('week index: ' + weekIndex);
                // Adding the working hours to the unique week
                weeks[weekIndex] +=
                  (ending_date - starting_date) / 1000 / 60 / 60;
              
              } else if ( ending_date.getDate() - starting_date.getDate() === 1) {
                // Adding the working hours to several weeks (night work for example)
                let starting_date_end = new Date( starting_date.getFullYear(), starting_date.getMonth(), starting_date.getDate()).setHours(0, 0, 0);
                let ending_date_start = new Date( ending_date.getFullYear(), ending_date.getMonth(), ending_date.getDate()).setHours(0, 0, 0);

                // Adding workingtimes for the "starting" date
                let startWeekIndex = 4 - Math.floor(new Date(ending_period) / new Date(this.setToMonday(starting_date)));
                weeks[startWeekIndex] += (starting_date_end - starting_date) / 1000 / 60 / 60;

                // Adding workingtimes for the "ending" date
                let endWeekIndex = 4 - Math.floor(new Date(ending_period) / new Date(this.setToMonday(ending_date)));
                weeks[endWeekIndex] += (ending_date - ending_date_start) / 1000 / 60 / 60;
              } else {
                // Do nothing because a workingtime during 3 different days is impossible
              }
            });

            // Get the week number corresponding to the year
            const firstWeek = new Date(starting_period);
            let onejan = new Date(new Date().setFullYear(firstWeek.getFullYear(), 0, 1));
            let weekOfYear = Math.ceil((((new Date(firstWeek.getFullYear(), firstWeek.getMonth(), firstWeek.getDate()) - onejan) / 86400000) + onejan.getDay() + 1) / 7);
            
            // Assigns the results
            this.lastWeeksHours = [];
            for (var i = 0; i < weeks.length; i++){
              this.lastWeeksHours.push({ week: (weekOfYear + i).toString(), hours: weeks[i].toFixed(2) });
            }
            //console.log(this.lastWeeksHours);
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


    // Get the date of the sunday corresponding to the current week
    setToSunday: function (date) {
      var day = date.getDay() || 7;
      if (day !== 7) date.setHours(24 * (8 - day));
      date.setUTCHours(23, 59, 59, 59);
      return date;
    },
    // Get the date of the monday corresponding to the current week
    setToMonday: function (date) {
      date = new Date(date);
      var day = date.getDay(),
        diff = date.getDate() - day + (day == 0 ? -6 : 1); // adjust when day is sunday
      date.setUTCHours(0, 0, 0, 0);
      return new Date(date.setDate(diff));
    },
    // return the date in ISO 8601 format, without concidering timezeone
    setDateToISO: function (date) {
      date = new Date(date);
      return (
        ("0000" + date.getFullYear()).slice(-4) +
        "-" +
        ("00" + (date.getMonth() + 1)).slice(-2) +
        "-" +
        ("00" + date.getDate()).slice(-2) +
        "T" +
        ("00" + date.getHours()).slice(-2) +
        ":" +
        ("00" + date.getMinutes()).slice(-2) +
        ":" +
        ("00" + date.getSeconds()).slice(-2)
      );
    },
  },
  beforeMount() {
    // Check if the user is authenticated
    this.isUserAuthenticated = User.methods.isUserAuthenticated();

    // Only if the user is authenticated
    if (this.isUserAuthenticated) {
      // load user datas
      if (this.$route.params.userid != undefined) {
        this.user = { id: this.$route.params.userid };
      } else {
        this.user = JSON.parse(localStorage.user);
      }
      //console.log(this.user);

      // Loading datas about all charts
      this.loadUserDatas(this.user.id);

      // Debug
      console.log('weeklyHours: ', this.weeklyHours);
      console.log('lastWeeksHours: ', this.lastWeeksHours);


    }
  },
};
</script>

<style scoped>

h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}

.card {
  color: black;
}

.card-title {
  margin-top: 0.7rem;
}
</style>
