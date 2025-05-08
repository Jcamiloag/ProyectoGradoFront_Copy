class Dog {
  final String breed;
  final String image;

  // Constructor de la clase Dog con los atributos requeridos
  Dog({
    required this.breed,
    required this.image,
  });

  // Método factory para crear una instancia de Dog desde un JSON
  factory Dog.fromJson(Map<String, dynamic> json, String breed) {
    return Dog(
      breed: breed,
      image: json['message'], // La API devuelve la URL de la imagen en 'message'
    );
  }
}