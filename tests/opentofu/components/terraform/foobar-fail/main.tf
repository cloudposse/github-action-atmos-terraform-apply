resource "random_id" "foo" {
  keepers = {
    # Generate a new id each time we switch to a new seed
    seed = "${module.this.id}-${var.example}-${var.seed}"
  }
  byte_length = 8
}


resource "null_resource" "default" {
  count = var.fail ? 1 : 0
  triggers = {
    test = random_id.foo["test"]
  }
}