resource "local_file" "pet" {
    filename = "/home/ubuntu/pets.txt"
    content = "We Love Pets!"
}