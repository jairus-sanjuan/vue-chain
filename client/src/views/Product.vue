<template>
  <b-row align-h="center">
    <b-col lg="6">
      <h3 class="mb-4">Product Form</h3>
      <b-row>
        <b-col lg="12"
          ><b-form-group
            id="form-group"
            label="Product Owner."
            label-for="form-group__owner"
          >
            <b-form-input
              id="form-group__owner"
              v-model="owner"
              trim
            ></b-form-input> </b-form-group
        ></b-col>
        <b-col lg="8">
          <b-form-group
            id="form-group"
            label="Model Number."
            label-for="form-group__model"
          >
            <b-form-input
              id="form-group__model"
              v-model="model"
              trim
            ></b-form-input>
          </b-form-group>
        </b-col>
        <b-col lg="4"
          ><b-form-group
            id="form-group"
            label="Part Number."
            label-for="form-group__part"
          >
            <b-form-input
              id="form-group__part"
              v-model="part"
              trim
            ></b-form-input> </b-form-group
        ></b-col>

        <b-col lg="12"
          ><b-form-group
            id="form-group"
            label="Serial Number."
            label-for="form-group__serial"
          >
            <b-form-input
              id="form-group__serial"
              v-model="serial"
              trim
            ></b-form-input> </b-form-group
        ></b-col>

        <b-col lg="12"
          ><b-form-group
            id="form-group"
            label="Product Cost."
            label-for="form-group__cost"
          >
            <b-form-input
              id="form-group__cost"
              v-model="cost"
              trim
            ></b-form-input> </b-form-group
        ></b-col>
      </b-row>
      <b-row>
        <b-col lg="4" class="mx-auto"
          ><b-button variant="primary" @click="submit"
            >Submit Form</b-button
          ></b-col
        >
      </b-row>
    </b-col>
  </b-row>
</template>

<script>
export default {
  methods: {
    submit: function() {
      console.log('Data : ', this._data)
    }
  },
  data() {
    return {
      model: '',
      part: '',
      serial: '',
      owner: '',
      cost: ''
    }
  }
}
</script>

<style scoped>
.col-lg-6 {
  padding: 20px 50px;
  background: #ffffff 0% 0% no-repeat padding-box;
  box-shadow: 0px 7px 23px #88888852;
  border-radius: 12px;
}

.form-group {
  margin-bottom: 1rem;
}
</style>
