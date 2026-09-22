resource "local_file" "pet" {
  filename = var.filename[count.index]
#   count = 3
  count = length(var.filename)
}

variable "filename" {
  default = [
    "/root/pets.txt",
    "/root/dogs.txt",
    "/root/cats.txt",
  ]
}


resource "local_file" "pet" {
  filename = each.value
#   for_each = var.filename
  for_each = toset(var.filename)
}

variable "filename" {
    # type = set(string)
    type = list(string)
  default = [
    "/root/pets.txt",
    "/root/dogs.txt",
    "/root/cats.txt",
  ]
}

output "pets" {
  value = local_file.pet
}