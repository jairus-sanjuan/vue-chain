<template>
  <b-card
    title="Title"
    img-src="https://placekitten.com/g/300/450"
    img-alt="Image"
    img-top
  >
    <b-card-text> Type : {{ type }} </b-card-text>
    <b-card-text> Address : {{ address }} </b-card-text>
    <template v-slot:footer>
      <small class="text-muted">Timestamp : {{ timestamp }}</small>
    </template>
  </b-card>
</template>

<script>
export default {
  props: ['type', 'address', 'timestamp']
}
</script>

<style>
</style>