<template>
  <b-row align-h="center" class="mb-5">
    <b-col lg="8">
      <h3 class="mb-4">Product Form</h3>
      <b-form-group
        id="form-group"
        label="Enter Model Number."
        label-for="form-group__model"
        :state="model.length > 0"
      >
        <b-form-input
          id="form-group__model"
          v-model="model"
          :state="model.length > 0"
          trim
        ></b-form-input>
      </b-form-group>
      <b-form-group
        id="form-group"
        label="Enter Part Number."
        label-for="form-group__part"
        :state="part.length > 0"
      >
        <b-form-input
          id="form-group__part"
          v-model="part"
          :state="part.length > 0"
          trim
        ></b-form-input>
      </b-form-group>
      <b-form-group
        id="form-group"
        label="Enter Serial Number."
        label-for="form-group__serial"
        :state="serial.length > 0"
      >
        <b-form-input
          id="form-group__serial"
          v-model="serial"
          :state="serial.length > 0"
          trim
        ></b-form-input>
      </b-form-group>
      <b-form-group
        id="form-group"
        label="Enter Product Owner."
        label-for="form-group__owner"
        :state="owner.length > 0"
      >
        <b-form-input
          id="form-group__owner"
          v-model="owner"
          :state="owner.length > 0"
          trim
        ></b-form-input>
      </b-form-group>
      <b-form-group
        id="form-group"
        label="Enter Product Cost."
        label-for="form-group__cost"
        :state="cost.length > 0"
      >
        <b-form-input
          id="form-group__cost"
          v-model="cost"
          :state="cost.length > 0"
          trim
        ></b-form-input>
      </b-form-group>

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
.col-lg-8 {
  padding: 20px 50px;
  background: #ffffff 0% 0% no-repeat padding-box;
  box-shadow: 0px 7px 23px #88888852;
  border-radius: 12px;
}

.form-group {
  margin-bottom: 1rem;
}
</style>
