import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:toastification/toastification.dart';
import 'package:http/http.dart' as http;

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _price = TextEditingController();
  String? _selectedCategory;
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _onSubmitHandler() async {
    const String url = "http://10.10.64.116:4000/api/food/add";

    if (_selectedImage == null || _productName.text.isEmpty || _description.text.isEmpty || _price.text.isEmpty) {
      toastification.show(
        context: context,
        title: const Text("Error"),
        description: const Text("Please fill all the fields."),
        backgroundColor: Colors.red,
      );
      return;
    }

    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['name'] = _productName.text;
    request.fields['description'] = _description.text;
    request.fields['price'] = _price.text;
    request.fields['category'] = _selectedCategory ?? "Salad";
    request.files.add(await http.MultipartFile.fromPath('image', _selectedImage!.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        toastification.show(
          context: context,
          title: const Text("Success"),
          description: const Text("Product added successfully!"),
          backgroundColor: Colors.green,
        );

        setState(() {
          _productName.clear();
          _description.clear();
          _price.clear();
          _selectedCategory = null;
          _selectedImage = null;
        });
      } else {
        toastification.show(
          context: context,
          title: const Text("Error"),
          description: const Text("Failed to add the product."),
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: const Text("Error"),
        description: Text("Error: $e"),
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(26.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Upload Image: "),
              Row(
                children: [
                  TextButton(
                    onPressed: _pickImage,
                    child: const Text(
                      "Pick image",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  if (_selectedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Image.file(
                        _selectedImage!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Product name: "),
              TextField(
                controller: _productName,
                decoration: const InputDecoration(hintText: "Name"),
              ),
              const SizedBox(height: 16),
              const Text("Product description: "),
              TextField(
                controller: _description,
                decoration: const InputDecoration(hintText: "Description"),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              const Text("Product category: "),
              DropdownButton<String>(
                value: _selectedCategory,
                hint: const Text("Select category"),
                items: const [
                  DropdownMenuItem(value: "Salad", child: Text("Salad")),
                  DropdownMenuItem(value: "Rolls", child: Text("Rolls")),
                  DropdownMenuItem(value: "Deserts", child: Text("Deserts")),
                  DropdownMenuItem(value: "Sandwich", child: Text("Sandwich")),
                  DropdownMenuItem(value: "Cake", child: Text("Cake")),
                  DropdownMenuItem(value: "Pure Veg", child: Text("Pure Veg")),
                  DropdownMenuItem(value: "Pasta", child: Text("Pasta")),
                  DropdownMenuItem(value: "Noodles", child: Text("Noodles")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text("Product price: "),
              TextField(
                controller: _price,
                decoration: const InputDecoration(hintText: "Price"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _onSubmitHandler,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 50)),
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text(
                    "Add Product",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
